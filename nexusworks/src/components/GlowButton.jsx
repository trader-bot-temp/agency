import { useRef } from 'react';
import { Link } from 'react-router-dom';
import { ArrowUpRight } from 'lucide-react';

/**
 * GlowButton
 * Gradient/ghost CTA with a magnetic pull toward the cursor (within 80px).
 * Renders as a router <Link> when `to` is set, otherwise a <button>.
 *
 * @param {string}  to        internal route -> renders a Link
 * @param {boolean} ghost     outlined variant
 * @param {boolean} arrow     show the trailing arrow icon (default true)
 * @param {boolean} magnetic  enable magnetic effect (default true)
 */
export default function GlowButton({
  children,
  to,
  ghost = false,
  arrow = true,
  magnetic = true,
  className = '',
  onClick,
  type = 'button',
  ...rest
}) {
  const ref = useRef(null);

  const handleMove = (e) => {
    if (!magnetic) return;
    const el = ref.current;
    if (!el) return;
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    const rect = el.getBoundingClientRect();
    const cx = rect.left + rect.width / 2;
    const cy = rect.top + rect.height / 2;
    const dx = e.clientX - cx;
    const dy = e.clientY - cy;
    const dist = Math.hypot(dx, dy);
    const radius = 80;
    if (dist < radius) {
      const pull = (1 - dist / radius) * 10;
      el.style.transform = `translate(${(dx / dist) * pull}px, ${(dy / dist) * pull}px)`;
    }
  };

  const handleLeave = () => {
    const el = ref.current;
    if (el) el.style.transform = '';
  };

  const cls = `glow-btn ${ghost ? 'ghost' : ''} ${className}`.trim();
  const inner = (
    <>
      {children}
      {arrow && <ArrowUpRight className="icon" size={18} strokeWidth={2.2} aria-hidden="true" />}
    </>
  );

  const sharedProps = {
    ref,
    className: cls,
    onMouseMove: handleMove,
    onMouseLeave: handleLeave,
    'data-cta': true,
    ...rest,
  };

  if (to) {
    return (
      <Link to={to} {...sharedProps} onClick={onClick}>
        {inner}
      </Link>
    );
  }

  return (
    <button type={type} {...sharedProps} onClick={onClick}>
      {inner}
    </button>
  );
}
