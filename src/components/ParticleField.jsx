import { useEffect, useRef } from 'react';
import * as THREE from 'three';

/**
 * ParticleField
 * A subtle WebGL "neural network": ~50 nodes drifting in 3D, connected by
 * lines when close, with mouse parallax. Performance-aware:
 *  - skips entirely under prefers-reduced-motion or on coarse pointers (touch)
 *  - caps devicePixelRatio
 *  - cancels rAF and disposes all GPU resources on unmount
 */
export default function ParticleField({ nodeCount = 50 }) {
  const mountRef = useRef(null);

  useEffect(() => {
    const mount = mountRef.current;
    if (!mount) return undefined;

    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const isCoarse = window.matchMedia('(pointer: coarse)').matches;
    // On touch / reduced-motion we render a single static frame (no rAF loop).
    const animate = !prefersReduced && !isCoarse;

    const width = mount.clientWidth;
    const height = mount.clientHeight;

    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(60, width / height, 0.1, 1000);
    camera.position.z = 60;

    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setSize(width, height);
    renderer.setClearColor(0x000000, 0);
    mount.appendChild(renderer.domElement);

    // ── Nodes ──────────────────────────────────────────────
    const range = 70;
    const positions = new Float32Array(nodeCount * 3);
    const velocities = [];
    for (let i = 0; i < nodeCount; i += 1) {
      positions[i * 3] = (Math.random() - 0.5) * range;
      positions[i * 3 + 1] = (Math.random() - 0.5) * range * 0.7;
      positions[i * 3 + 2] = (Math.random() - 0.5) * range * 0.6;
      velocities.push(
        new THREE.Vector3(
          (Math.random() - 0.5) * 0.06,
          (Math.random() - 0.5) * 0.06,
          (Math.random() - 0.5) * 0.06
        )
      );
    }

    const nodeGeo = new THREE.BufferGeometry();
    nodeGeo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    const nodeMat = new THREE.PointsMaterial({
      color: 0x00d4aa,
      size: 1.6,
      transparent: true,
      opacity: 0.9,
      sizeAttenuation: true,
    });
    const points = new THREE.Points(nodeGeo, nodeMat);
    scene.add(points);

    // ── Connecting lines ───────────────────────────────────
    const lineMat = new THREE.LineBasicMaterial({
      color: 0x6c63ff,
      transparent: true,
      opacity: 0.22,
    });
    const lineGeo = new THREE.BufferGeometry();
    const maxLineVerts = nodeCount * nodeCount * 2;
    const linePositions = new Float32Array(maxLineVerts * 3);
    lineGeo.setAttribute('position', new THREE.BufferAttribute(linePositions, 3));
    const lines = new THREE.LineSegments(lineGeo, lineMat);
    scene.add(lines);

    const connectDist = 18;
    const rebuildLines = () => {
      let v = 0;
      const pos = nodeGeo.attributes.position.array;
      for (let i = 0; i < nodeCount; i += 1) {
        for (let j = i + 1; j < nodeCount; j += 1) {
          const dx = pos[i * 3] - pos[j * 3];
          const dy = pos[i * 3 + 1] - pos[j * 3 + 1];
          const dz = pos[i * 3 + 2] - pos[j * 3 + 2];
          const d = Math.sqrt(dx * dx + dy * dy + dz * dz);
          if (d < connectDist) {
            linePositions[v++] = pos[i * 3];
            linePositions[v++] = pos[i * 3 + 1];
            linePositions[v++] = pos[i * 3 + 2];
            linePositions[v++] = pos[j * 3];
            linePositions[v++] = pos[j * 3 + 1];
            linePositions[v++] = pos[j * 3 + 2];
          }
        }
      }
      lineGeo.setDrawRange(0, v / 3);
      lineGeo.attributes.position.needsUpdate = true;
    };

    // ── Mouse parallax ─────────────────────────────────────
    const mouse = { x: 0, y: 0 };
    const target = { x: 0, y: 0 };
    const onMouseMove = (e) => {
      target.x = (e.clientX / window.innerWidth - 0.5) * 2;
      target.y = (e.clientY / window.innerHeight - 0.5) * 2;
    };
    if (animate) window.addEventListener('mousemove', onMouseMove, { passive: true });

    let rafId = null;
    const tick = () => {
      const pos = nodeGeo.attributes.position.array;
      for (let i = 0; i < nodeCount; i += 1) {
        pos[i * 3] += velocities[i].x;
        pos[i * 3 + 1] += velocities[i].y;
        pos[i * 3 + 2] += velocities[i].z;
        // bounce within the box
        for (let a = 0; a < 3; a += 1) {
          const limit = a === 0 ? range / 2 : a === 1 ? (range * 0.7) / 2 : (range * 0.6) / 2;
          if (pos[i * 3 + a] > limit || pos[i * 3 + a] < -limit) {
            velocities[i].setComponent(a, -velocities[i].getComponent(a));
          }
        }
      }
      nodeGeo.attributes.position.needsUpdate = true;
      rebuildLines();

      mouse.x += (target.x - mouse.x) * 0.04;
      mouse.y += (target.y - mouse.y) * 0.04;
      scene.rotation.y = mouse.x * 0.3;
      scene.rotation.x = mouse.y * 0.2;
      points.rotation.z += 0.0006;
      lines.rotation.z = points.rotation.z;

      renderer.render(scene, camera);
      rafId = requestAnimationFrame(tick);
    };

    if (animate) {
      tick();
    } else {
      rebuildLines();
      renderer.render(scene, camera);
    }

    // ── Resize ─────────────────────────────────────────────
    const onResize = () => {
      const w = mount.clientWidth;
      const h = mount.clientHeight;
      camera.aspect = w / h;
      camera.updateProjectionMatrix();
      renderer.setSize(w, h);
      if (!animate) renderer.render(scene, camera);
    };
    window.addEventListener('resize', onResize);

    // ── Cleanup ────────────────────────────────────────────
    return () => {
      if (rafId) cancelAnimationFrame(rafId);
      window.removeEventListener('resize', onResize);
      window.removeEventListener('mousemove', onMouseMove);
      nodeGeo.dispose();
      nodeMat.dispose();
      lineGeo.dispose();
      lineMat.dispose();
      renderer.dispose();
      if (renderer.domElement.parentNode === mount) {
        mount.removeChild(renderer.domElement);
      }
    };
  }, [nodeCount]);

  return <div ref={mountRef} className="particle-field" aria-hidden="true" />;
}
