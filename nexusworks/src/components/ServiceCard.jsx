import { useRef } from 'react';
import { Link } from 'react-router-dom';
import { ArrowUpRight, Sparkles } from 'lucide-react';
import Icon from './Icon';

/**
 * ServiceCard
 * Glass card with a 3D perspective tilt that tracks the cursor.
 * The full description slides up on hover; whole card links to the
 * service detail page. Tilt is disabled under reduced-motion / touch.
 */
export default function ServiceCard({ service, featured = false }) {
  const ref = useRef(null);

  const handleMove = (e) => {
    const el = ref.current;
    if (!el) return;
    if (
      window.matchMedia('(prefers-reduced-motion: reduce)').matches ||
      window.matchMedia('(pointer: coarse)').matches
    )
      return;
    const rect = el.getBoundingClientRect();
    const px = (e.clientX - rect.left) / rect.width - 0.5;
    const py = (e.clientY - rect.top) / rect.height - 0.5;
    el.style.transform = `perspective(900px) rotateY(${px * 9}deg) rotateX(${-py * 9}deg) translateY(-6px)`;
  };

  const handleLeave = () => {
    const el = ref.current;
    if (el) el.style.transform = '';
  };

  return (
    <Link
      to={`/services/${service.slug}`}
      className={`service-card tilt-card ${featured ? 'gradient-border' : ''}`}
      ref={ref}
      onMouseMove={handleMove}
      onMouseLeave={handleLeave}
      style={{ '--card-accent': service.accent }}
      aria-label={`${service.name} — ${service.tagline}`}
    >
      <div className="tilt-inner service-card-inner">
        <div className="service-card-top">
          <span className="service-icon">
            <Icon name={service.icon} size={26} />
          </span>
          {service.aiAssisted && (
            <span className="badge badge-ai">
              <Sparkles size={12} /> AI-Assisted
            </span>
          )}
        </div>

        <h3 className="service-card-name">{service.name}</h3>
        <p className="service-card-teaser">{service.teaser}</p>

        <div className="service-card-foot">
          <span className="mono service-card-cat">{service.category}</span>
          <span className="service-card-go">
            View service <ArrowUpRight size={16} />
          </span>
        </div>
      </div>
    </Link>
  );
}
