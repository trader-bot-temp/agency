import { useEffect, useRef } from 'react';

/**
 * CursorTrail
 * Custom glow cursor: a small dot that tracks instantly and a ring that
 * lags with easing. The ring expands when hovering interactive elements.
 * Only active on fine pointers without reduced-motion; otherwise renders
 * nothing and the native cursor is used.
 */
export default function CursorTrail() {
  const dotRef = useRef(null);
  const ringRef = useRef(null);

  useEffect(() => {
    const fine = window.matchMedia('(pointer: fine)').matches;
    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (!fine || prefersReduced) return undefined;

    document.body.classList.add('has-cursor-trail');

    const dot = dotRef.current;
    const ring = ringRef.current;
    const pos = { x: window.innerWidth / 2, y: window.innerHeight / 2 };
    const ringPos = { ...pos };
    let rafId = null;

    const onMove = (e) => {
      pos.x = e.clientX;
      pos.y = e.clientY;
      if (dot) {
        dot.style.left = `${pos.x}px`;
        dot.style.top = `${pos.y}px`;
      }
    };

    const isInteractive = (el) =>
      el && (el.closest('a, button, [data-cta], input, textarea, select, [role="button"]'));

    const onOver = (e) => {
      if (ring) ring.classList.toggle('is-hover', !!isInteractive(e.target));
    };

    const loop = () => {
      ringPos.x += (pos.x - ringPos.x) * 0.18;
      ringPos.y += (pos.y - ringPos.y) * 0.18;
      if (ring) {
        ring.style.left = `${ringPos.x}px`;
        ring.style.top = `${ringPos.y}px`;
      }
      rafId = requestAnimationFrame(loop);
    };

    window.addEventListener('mousemove', onMove, { passive: true });
    window.addEventListener('mouseover', onOver, { passive: true });
    loop();

    return () => {
      document.body.classList.remove('has-cursor-trail');
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseover', onOver);
      if (rafId) cancelAnimationFrame(rafId);
    };
  }, []);

  return (
    <>
      <div ref={dotRef} className="cursor-dot" aria-hidden="true" />
      <div ref={ringRef} className="cursor-ring" aria-hidden="true" />
    </>
  );
}
