import { useEffect, useRef, useState } from 'react';

/**
 * CursorTrail
 * Custom glow cursor: a small dot that tracks instantly and a ring that
 * lags with easing. The ring expands when hovering interactive elements.
 *
 * Only runs on true mouse devices (fine pointer + hover capable) without
 * reduced-motion. On touch / coarse-pointer devices it renders nothing,
 * so the elements can never get stuck in a corner. It also hides itself
 * whenever the pointer leaves the window (or the tab loses focus) and
 * reappears on return.
 */
export default function CursorTrail() {
  const dotRef = useRef(null);
  const ringRef = useRef(null);
  const [enabled, setEnabled] = useState(false);

  // 1) Capability detection — decide once, on the client, whether to mount
  //    the custom cursor at all. Touch / coarse-pointer devices get nothing.
  useEffect(() => {
    const mq = window.matchMedia(
      '(pointer: fine) and (hover: hover) and (prefers-reduced-motion: no-preference)'
    );
    const apply = () => setEnabled(mq.matches);
    apply();
    // React to device/setting changes (e.g. plugging in a mouse).
    mq.addEventListener?.('change', apply);
    return () => {
      mq.removeEventListener?.('change', apply);
    };
  }, []);

  // 2) Animation + listeners — only once enabled (and the nodes are in the DOM).
  useEffect(() => {
    if (!enabled) return undefined;

    const dot = dotRef.current;
    const ring = ringRef.current;
    if (!dot || !ring) return undefined;

    document.body.classList.add('has-cursor-trail');

    const pos = { x: window.innerWidth / 2, y: window.innerHeight / 2 };
    const ringPos = { ...pos };
    let rafId = null;

    const onMove = (e) => {
      pos.x = e.clientX;
      pos.y = e.clientY;
      dot.style.left = `${pos.x}px`;
      dot.style.top = `${pos.y}px`;
    };

    const isInteractive = (el) =>
      el && el.closest('a, button, [data-cta], input, textarea, select, [role="button"]');

    const onOver = (e) => {
      ring.classList.toggle('is-hover', !!isInteractive(e.target));
    };

    // Hide when the pointer leaves the window; show when it returns.
    const hide = () => {
      dot.classList.add('is-hidden');
      ring.classList.add('is-hidden');
    };
    const show = () => {
      dot.classList.remove('is-hidden');
      ring.classList.remove('is-hidden');
    };

    const loop = () => {
      ringPos.x += (pos.x - ringPos.x) * 0.18;
      ringPos.y += (pos.y - ringPos.y) * 0.18;
      ring.style.left = `${ringPos.x}px`;
      ring.style.top = `${ringPos.y}px`;
      rafId = requestAnimationFrame(loop);
    };

    window.addEventListener('mousemove', onMove, { passive: true });
    window.addEventListener('mouseover', onOver, { passive: true });
    // `mouseleave`/`mouseenter` on document fire as the pointer crosses the
    // window boundary; blur/focus cover tab and window switches.
    document.addEventListener('mouseleave', hide);
    document.addEventListener('mouseenter', show);
    window.addEventListener('blur', hide);
    window.addEventListener('focus', show);
    loop();

    return () => {
      document.body.classList.remove('has-cursor-trail');
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseover', onOver);
      document.removeEventListener('mouseleave', hide);
      document.removeEventListener('mouseenter', show);
      window.removeEventListener('blur', hide);
      window.removeEventListener('focus', show);
      if (rafId) cancelAnimationFrame(rafId);
    };
  }, [enabled]);

  // Nothing is rendered on touch / coarse-pointer / reduced-motion devices,
  // so the dot and ring can never appear stuck in a corner.
  if (!enabled) return null;

  return (
    <>
      <div ref={dotRef} className="cursor-dot" aria-hidden="true" />
      <div ref={ringRef} className="cursor-ring" aria-hidden="true" />
    </>
  );
}
