import { useEffect, useMemo, useRef, useState } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import {
  Clock,
  Layers,
  TrendingDown,
  Cpu,
  UserCog,
  ChevronRight,
  Quote,
} from 'lucide-react';

import ParticleField from '../components/ParticleField.jsx';
import GlowButton from '../components/GlowButton.jsx';
import AnimatedCounter from '../components/AnimatedCounter.jsx';
import ServiceCard from '../components/ServiceCard.jsx';
import ScrollReveal from '../components/ScrollReveal.jsx';
import Icon from '../components/Icon.jsx';
import { services, CATEGORIES } from '../data/services.js';

gsap.registerPlugin(ScrollTrigger);

/* Splits a string into word-rise animated spans. */
function SplitWords({ text, className = '', start = 0 }) {
  const words = text.split(' ');
  return (
    <span className={className}>
      {words.map((w, i) => (
        <span className="split-word" key={`${w}-${i}`}>
          <span style={{ animationDelay: `${start + i * 0.06}s` }}>{w}&nbsp;</span>
        </span>
      ))}
    </span>
  );
}

const PROBLEMS = [
  {
    icon: Clock,
    end: 70,
    suffix: '%',
    title: 'Time lost to busywork',
    desc: 'Founders burn most of their week on tasks software and specialists should own — not on growth.',
  },
  {
    icon: Layers,
    end: 9,
    suffix: '+',
    title: 'Too many disconnected vendors',
    desc: 'A design freelancer here, a dev shop there, an agency for ads. Nothing talks to each other.',
  },
  {
    icon: TrendingDown,
    end: 40,
    suffix: '%',
    title: 'Budget leaking on the wrong work',
    desc: 'Without a single accountable partner, spend scatters and outcomes stall. We fix the whole system.',
  },
];

const STATS = [
  { end: 200, suffix: '+', label: 'Projects shipped' },
  { end: 98, suffix: '%', label: 'Client retention' },
  { end: 3, suffix: 'x', label: 'Faster turnaround' },
  { end: 40, suffix: '+', label: 'Active clients' },
];

const INDUSTRIES = [
  'SaaS',
  'Fintech',
  'E-Commerce',
  'HealthTech',
  'EdTech',
  'D2C Brands',
  'Marketplaces',
  'Logistics',
  'Real Estate',
  'Web3',
  'Agencies',
  'Manufacturing',
];

const PROCESS = [
  { step: 'Discover', desc: 'We map your goals, constraints and the real bottlenecks before touching a single tool.' },
  { step: 'Strategize', desc: 'A prioritized plan with owners, timelines and the metric each workstream moves.' },
  { step: 'Execute', desc: 'Senior specialists ship, with AI accelerating research, drafting and QA at every step.' },
  { step: 'Optimize', desc: 'We measure, learn and tune — turning first results into repeatable systems.' },
  { step: 'Scale', desc: 'Once it works, we automate and expand so growth no longer depends on your hours.' },
];

const TESTIMONIALS = [
  {
    quote:
      'NexusWorks replaced four vendors with one team. We shipped our rebrand, new site and paid engine in six weeks — and our CAC dropped a third.',
    name: 'Priya Nair',
    role: 'Founder, seed-stage SaaS',
  },
  {
    quote:
      'The AI-plus-human model is not marketing fluff. Drafts arrive fast, but a real strategist owns the call. It is the first agency that felt like an in-house team.',
    name: 'Marcus Lee',
    role: 'COO, D2C brand',
  },
  {
    quote:
      'They automated our entire order-to-invoice flow and set up the CRM our sales team actually uses. We got our weeks back.',
    name: 'Sofia Almeida',
    role: 'Head of Ops, logistics startup',
  },
];

function ProblemCard({ icon: I, end, suffix, title, desc, delay }) {
  return (
    <ScrollReveal className="problem-card" delay={delay}>
      <span className="p-icon" aria-hidden="true">
        <I size={24} strokeWidth={1.8} />
      </span>
      <h3>{title}</h3>
      <p>{desc}</p>
      <span className="p-stat">
        <AnimatedCounter end={end} suffix={suffix} />
      </span>
    </ScrollReveal>
  );
}

function AiHumanModel() {
  const [active, setActive] = useState(services[0].id);
  const current = services.find((s) => s.id === active) || services[0];

  return (
    <div className="aihuman">
      <div className="aihuman-tabs" role="tablist" aria-label="Services">
        {services.slice(0, 8).map((s) => (
          <button
            key={s.id}
            role="tab"
            aria-selected={s.id === active}
            className={`aihuman-tab ${s.id === active ? 'active' : ''}`}
            onClick={() => setActive(s.id)}
          >
            {s.name}
          </button>
        ))}
      </div>
      <div className="aihuman-body">
        <div className="aihuman-side ai">
          <span className="label">
            <Cpu size={15} /> AI accelerates
          </span>
          <p>{current.aiHuman.ai}</p>
        </div>
        <div className="aihuman-side human">
          <span className="label">
            <UserCog size={15} /> Humans decide
          </span>
          <p>{current.aiHuman.human}</p>
        </div>
      </div>
    </div>
  );
}

function ProcessSection() {
  const sectionRef = useRef(null);
  const trackRef = useRef(null);

  useEffect(() => {
    const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const coarse = window.matchMedia('(pointer: coarse)').matches;
    const section = sectionRef.current;
    const track = trackRef.current;
    if (reduce || coarse || !section || !track) return undefined;

    const ctx = gsap.context(() => {
      const distance = track.scrollWidth - window.innerWidth;
      if (distance <= 0) return;
      gsap.to(track, {
        x: -distance,
        ease: 'none',
        scrollTrigger: {
          trigger: section,
          start: 'top top',
          end: () => `+=${distance + window.innerHeight * 0.5}`,
          scrub: 1,
          pin: true,
          anticipatePin: 1,
          invalidateOnRefresh: true,
        },
      });
    }, section);

    return () => ctx.revert();
  }, []);

  const reduceOrTouch =
    typeof window !== 'undefined' &&
    (window.matchMedia('(prefers-reduced-motion: reduce)').matches ||
      window.matchMedia('(pointer: coarse)').matches);

  return (
    <section
      ref={sectionRef}
      className={`process-pin ${reduceOrTouch ? 'process-fallback' : ''}`}
      aria-label="Our process"
    >
      <div className="process-track" ref={trackRef}>
        <div className="process-intro process-step">
          <p className="eyebrow">How we work</p>
          <h2>Five steps from chaos to compounding growth.</h2>
          <p className="text-muted">
            One accountable team, one system — scroll through how a NexusWorks engagement unfolds.
          </p>
        </div>
        {PROCESS.map((p, i) => (
          <div className="process-step" key={p.step}>
            <span className="p-num">STEP {String(i + 1).padStart(2, '0')}</span>
            <h3>{p.step}</h3>
            <p>{p.desc}</p>
            <span className="p-index" aria-hidden="true">
              {String(i + 1).padStart(2, '0')}
            </span>
          </div>
        ))}
      </div>
    </section>
  );
}

export default function Home() {
  const [filter, setFilter] = useState('All');

  const filtered = useMemo(
    () => (filter === 'All' ? services : services.filter((s) => s.category === filter)),
    [filter]
  );

  return (
    <>
      {/* ── HERO ───────────────────────────────────────── */}
      <section className="hero">
        <ParticleField nodeCount={54} />
        <div className="hero-overlay" aria-hidden="true" />
        <div className="container hero-content">
          <p className="eyebrow">Where human intelligence meets AI precision</p>
          <h1 className="hero-title">
            <SplitWords text="We Build, Scale & Automate Your Entire Business —" />
            <SplitWords text="So You Can Focus on Growth." className="accent" start={0.5} />
          </h1>
          <p className="hero-sub">
            AI + human collaboration across 15+ specialized services — faster delivery, smarter
            outcomes, one accountable team.
          </p>
          <div className="hero-ctas">
            <GlowButton to="/services">Explore Services</GlowButton>
            <GlowButton to="/contact" ghost arrow={false}>
              Get Free Consultation
            </GlowButton>
          </div>
        </div>
        <div className="hero-scroll-hint" aria-hidden="true">
          <span className="mouse" />
          <span className="mono">scroll</span>
        </div>
      </section>

      {/* ── PROBLEM ────────────────────────────────────── */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">The problem we solve</p>
          <h2 className="section-title">Growing a company shouldn&apos;t mean drowning in vendors.</h2>
          <p className="section-lead">
            Most founders stitch together freelancers and tools, then spend their time managing the
            mess. We become the single team that runs it all.
          </p>
        </div>
        <div className="problem-grid">
          {PROBLEMS.map((p, i) => (
            <ProblemCard key={p.title} {...p} delay={(i % 3) + 1} />
          ))}
        </div>
      </section>

      {/* ── AI + HUMAN MODEL ───────────────────────────── */}
      <section className="section container">
        <div className="section-head">
          <p className="eyebrow">Our AI + human model</p>
          <h2 className="section-title">AI does the heavy lifting. Humans make the judgment calls.</h2>
          <p className="section-lead">
            Every service pairs AI speed with senior human taste. Pick a service to see exactly where
            each one earns its keep.
          </p>
        </div>
        <AiHumanModel />
      </section>

      {/* ── STATS ──────────────────────────────────────── */}
      <section className="section container">
        <div className="stats-bar">
          {STATS.map((s) => (
            <div className="stat" key={s.label}>
              <div className="stat-num text-gradient">
                <AnimatedCounter end={s.end} suffix={s.suffix} />
              </div>
              <div className="stat-label text-muted">{s.label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ── SERVICES GRID ──────────────────────────────── */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">What we do</p>
          <h2 className="section-title">15 services. One team. Zero hand-off chaos.</h2>
          <p className="section-lead">
            Filter by what you need today — and know the same crew can take on the rest tomorrow.
          </p>
        </div>
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

      {/* ── INDUSTRIES TICKER ──────────────────────────── */}
      <section className="section" aria-label="Industries we serve">
        <div className="container section-head center">
          <p className="eyebrow">Industries we serve</p>
          <h2 className="section-title">Built for fast-moving teams in every category.</h2>
        </div>
        <div className="marquee" aria-hidden="true">
          <div className="marquee-track">
            {[...INDUSTRIES, ...INDUSTRIES].map((ind, i) => (
              <span className="ticker-item" key={`${ind}-${i}`}>
                <ChevronRight size={15} /> {ind}
              </span>
            ))}
          </div>
        </div>
      </section>

      {/* ── PROCESS (GSAP pinned) ──────────────────────── */}
      <ProcessSection />

      {/* ── TESTIMONIALS ───────────────────────────────── */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">What clients say</p>
          <h2 className="section-title">Teams that stopped juggling vendors.</h2>
        </div>
        <div className="testi-grid">
          {TESTIMONIALS.map((t, i) => (
            <ScrollReveal className="testi-card" delay={(i % 3) + 1} key={t.name}>
              <Quote size={28} aria-hidden="true" style={{ color: 'var(--accent-1)' }} />
              <p className="quote">{t.quote}</p>
              <div className="testi-author">
                <span className="testi-avatar" aria-hidden="true">
                  {t.name.charAt(0)}
                </span>
                <div>
                  <span className="name">{t.name}</span>
                  <br />
                  <span className="role">{t.role}</span>
                </div>
              </div>
            </ScrollReveal>
          ))}
        </div>
      </section>

      {/* ── CTA BANNER ─────────────────────────────────── */}
      <section className="section container">
        <div className="cta-banner">
          <p className="eyebrow">Ready when you are</p>
          <h2>One team to build, scale and automate it all.</h2>
          <p className="section-lead">
            Book a free consultation and we&apos;ll map the fastest path from where you are to where
            you want to be.
          </p>
          <div className="cta-actions">
            <GlowButton to="/contact">Get Free Consultation</GlowButton>
            <GlowButton to="/services" ghost arrow={false}>
              Browse all services
            </GlowButton>
          </div>
        </div>
      </section>
    </>
  );
}
