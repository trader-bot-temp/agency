import { useState } from 'react';
import { useParams, Link, Navigate } from 'react-router-dom';
import { ArrowLeft, Cpu, UserCog, ChevronDown, Building2 } from 'lucide-react';

import { getServiceBySlug } from '../../data/services.js';
import Icon from '../../components/Icon.jsx';
import GlowButton from '../../components/GlowButton.jsx';
import ScrollReveal from '../../components/ScrollReveal.jsx';

function FaqItem({ q, a }) {
  const [open, setOpen] = useState(false);
  return (
    <div className="accordion-item" data-open={open}>
      <button
        className="accordion-trigger"
        aria-expanded={open}
        onClick={() => setOpen((v) => !v)}
      >
        {q}
        <ChevronDown className="chev" size={20} aria-hidden="true" />
      </button>
      {open && <div className="accordion-panel">{a}</div>}
    </div>
  );
}

export default function ServiceDetail() {
  const { slug } = useParams();
  const service = getServiceBySlug(slug);

  if (!service) return <Navigate to="/services" replace />;

  return (
    <>
      {/* HERO */}
      <section className="sd-hero">
        <div className="container">
          <div className="sd-hero-inner">
            <div>
              <Link to="/services" className="sd-back">
                <ArrowLeft size={16} /> All services
              </Link>
              <p className="eyebrow">{service.category}</p>
              <h1 className="sd-title">{service.name}</h1>
              <p className="sd-tagline">{service.tagline}</p>
              <div className="hero-ctas">
                <GlowButton to="/contact">Start This Service</GlowButton>
                {service.aiAssisted && <span className="badge badge-ai">AI-Assisted</span>}
              </div>
            </div>
            <div className="sd-illustration" aria-hidden="true">
              <span className="ill-icon">
                <Icon name={service.icon} size={84} strokeWidth={1.2} />
              </span>
            </div>
          </div>
        </div>
      </section>

      {/* WHAT WE DO */}
      <section className="section container">
        <div className="section-head">
          <p className="eyebrow">What we do</p>
          <h2 className="section-title">Three ways we move the needle.</h2>
        </div>
        <div className="sd-deliverables">
          {service.whatWeDo.map((d, i) => (
            <ScrollReveal className="sd-deliver" delay={(i % 3) + 1} key={d.title}>
              <span className="d-icon" aria-hidden="true">
                <Icon name={d.icon} size={24} />
              </span>
              <h3>{d.title}</h3>
              <p>{d.desc}</p>
            </ScrollReveal>
          ))}
        </div>
      </section>

      {/* AI + HUMAN */}
      <section className="section container">
        <div className="section-head">
          <p className="eyebrow">How AI + humans work together here</p>
          <h2 className="section-title">Speed from AI. Judgment from people.</h2>
        </div>
        <div className="aihuman">
          <div className="aihuman-body">
            <div className="aihuman-side ai">
              <span className="label">
                <Cpu size={15} /> AI accelerates
              </span>
              <p>{service.aiHuman.ai}</p>
            </div>
            <div className="aihuman-side human">
              <span className="label">
                <UserCog size={15} /> Humans decide
              </span>
              <p>{service.aiHuman.human}</p>
            </div>
          </div>
        </div>
      </section>

      {/* PROCESS */}
      <section className="section container">
        <div className="section-head">
          <p className="eyebrow">How it works</p>
          <h2 className="section-title">A clear path, every engagement.</h2>
        </div>
        <div className="timeline">
          {service.process.map((p, i) => (
            <ScrollReveal className="timeline-item" delay={(i % 4) + 1} key={p.step}>
              <span className="t-year">STEP {String(i + 1).padStart(2, '0')}</span>
              <h3>{p.step}</h3>
              <p>{p.desc}</p>
            </ScrollReveal>
          ))}
        </div>
      </section>

      {/* TOOLS */}
      <section className="section container">
        <div className="section-head">
          <p className="eyebrow">Tools &amp; technologies</p>
          <h2 className="section-title">The stack behind the work.</h2>
        </div>
        <div className="tools-list">
          {service.tools.map((t) => (
            <span className="tech-chip" key={t}>
              {t}
            </span>
          ))}
        </div>
      </section>

      {/* ROI */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">Outcomes you can measure</p>
          <h2 className="section-title">What good looks like.</h2>
        </div>
        <div className="roi-grid">
          {service.roi.map((r, i) => (
            <ScrollReveal className="roi-card" delay={(i % 3) + 1} key={r.label}>
              <div className="roi-metric">{r.metric}</div>
              <div className="roi-label">{r.label}</div>
            </ScrollReveal>
          ))}
        </div>
      </section>

      {/* CASE STUDY */}
      <section className="section container">
        <div className="case-study">
          <p className="eyebrow">Mini case study</p>
          <p className="cs-quote">{service.caseStudy.result}</p>
          <span className="cs-client">
            <Building2 size={15} /> {service.caseStudy.client}
          </span>
        </div>
      </section>

      {/* FAQ */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">FAQ</p>
          <h2 className="section-title">Questions, answered.</h2>
        </div>
        <div className="accordion">
          {service.faq.map((f) => (
            <FaqItem key={f.q} q={f.q} a={f.a} />
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="section container">
        <div className="cta-banner">
          <p className="eyebrow">Let&apos;s get started</p>
          <h2>Ready to put {service.name} to work?</h2>
          <div className="cta-actions">
            <GlowButton to="/contact">Start This Service</GlowButton>
            <GlowButton to="/services" ghost arrow={false}>
              Browse other services
            </GlowButton>
          </div>
        </div>
      </section>
    </>
  );
}
