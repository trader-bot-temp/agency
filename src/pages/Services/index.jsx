import { useMemo, useState } from 'react';
import ServiceCard from '../../components/ServiceCard.jsx';
import GlowButton from '../../components/GlowButton.jsx';
import { services, CATEGORIES, getServicesByCategory } from '../../data/services.js';

export default function ServicesIndex() {
  const [filter, setFilter] = useState('All');

  const filtered = useMemo(() => getServicesByCategory(filter), [filter]);

  return (
    <>
      <header className="page-hero container">
        <p className="eyebrow">Services</p>
        <h1>
          Everything you need to build, scale &amp;{' '}
          <span className="text-gradient">automate</span>.
        </h1>
        <p>
          Fifteen specialized services, one senior team, AI woven through every one — pick a starting
          point and grow into the rest.
        </p>
      </header>

      <section className="section container">
        <div className="filter-bar" role="tablist" aria-label="Filter services by category">
          {CATEGORIES.map((c) => (
            <button
              key={c}
              role="tab"
              aria-selected={filter === c}
              className={`filter-chip ${filter === c ? 'active' : ''}`}
              onClick={() => setFilter(c)}
            >
              {c}
            </button>
          ))}
        </div>

        <div className="services-grid">
          {filtered.map((s) => (
            <ServiceCard key={s.id} service={s} featured={s.aiAssisted} />
          ))}
        </div>
      </section>

      <section className="section container">
        <div className="cta-banner">
          <p className="eyebrow">Not sure where to start?</p>
          <h2>Tell us the goal — we&apos;ll map the services to it.</h2>
          <p className="section-lead">
            One free consultation, one clear plan, one team to execute it.
          </p>
          <div className="cta-actions">
            <GlowButton to="/contact">Get Free Consultation</GlowButton>
          </div>
        </div>
      </section>
    </>
  );
}
