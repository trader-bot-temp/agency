import { Crown, Cpu, Palette } from 'lucide-react';
import ScrollReveal from '../components/ScrollReveal.jsx';
import GlowButton from '../components/GlowButton.jsx';

const TEAM = [
  {
    icon: Crown,
    title: 'Leadership',
    desc: 'Operators who have built, scaled and sold companies — they own outcomes, not hours.',
  },
  {
    icon: Cpu,
    title: 'AI & Engineering',
    desc: 'Engineers who wire AI into real workflows: dashboards, automations, RAG pipelines and apps.',
  },
  {
    icon: Palette,
    title: 'Creative Studio',
    desc: 'Designers, editors and animators who make early-stage brands look genuinely funded.',
  },
];

const TIMELINE = [
  { year: '2021', title: 'Founded on one frustration', desc: 'Three operators were tired of watching founders stitch together six vendors. Cortinix started as a single pod.' },
  { year: '2022', title: 'AI woven into delivery', desc: 'We rebuilt every workflow around AI-assisted research, drafting and QA — cutting turnaround without cutting quality.' },
  { year: '2023', title: '15 services under one roof', desc: 'From marketing to ERP to data, we became the single accountable team clients had been missing.' },
  { year: '2024', title: '40+ active clients', desc: 'Retention crossed 98% as engagements grew from one project into long-term partnerships.' },
  { year: 'Today', title: 'Building the AI-native agency', desc: 'We keep humans in charge of judgment and let AI handle the grind — faster delivery, smarter outcomes.' },
];

const VALUES = [
  { title: 'Outcomes over output', reveal: 'We measure ourselves on the metric you care about, not the volume of deliverables we ship.' },
  { title: 'AI with a human owner', reveal: 'Every AI-accelerated task has a senior human accountable for the final call. No autopilot.' },
  { title: 'Radical ownership', reveal: 'One team, one throat to choke. We do not pass blame between vendors because there are none.' },
  { title: 'Speed without sloppiness', reveal: 'Fast is a feature — but never at the cost of taste, accuracy or your brand.' },
  { title: 'Transparent by default', reveal: 'You own every account, file and dashboard. We share the good and the bad in plain language.' },
  { title: 'Compounding partnerships', reveal: 'We optimize for the relationship that lasts years, not the invoice that clears this month.' },
];

const TECH = [
  'React', 'Next.js', 'Node.js', 'TypeScript', 'Python', 'OpenAI', 'LangChain',
  'HubSpot', 'Salesforce', 'Shopify', 'Zapier', 'n8n', 'Make', 'Power BI',
  'Tableau', 'Figma', 'After Effects', 'GA4', 'MongoDB', 'PostgreSQL',
];

export default function About() {
  return (
    <>
      <header className="page-hero container">
        <p className="eyebrow">About Cortinix</p>
        <h1>
          Human intelligence, <span className="text-gradient">AI precision</span> — one team for it
          all.
        </h1>
        <p>
          We exist so founders can stop managing vendors and start building. Faster delivery, smarter
          outcomes, and a single team accountable for the whole picture.
        </p>
      </header>

      {/* Story */}
      <section className="section container">
        <div className="split">
          <ScrollReveal className="about-story">
            <p className="eyebrow">Who we are</p>
            <h2 className="section-title">We&apos;re the in-house team you can&apos;t yet afford to hire.</h2>
          </ScrollReveal>
          <ScrollReveal className="about-story" delay={1}>
            <p>
              Cortinix began when three operators kept watching the same thing kill good companies:
              not a lack of ideas, but a tangle of disconnected freelancers, tools and agencies that
              nobody owned end to end.
            </p>
            <p>
              So we built the opposite — one senior team across 15 services, with AI woven into every
              workflow to compress the timeline. AI drafts, researches and watches for problems;
              humans set strategy, make the taste calls, and stay accountable for results.
            </p>
            <p>
              The outcome is simple: you get the speed of automation and the judgment of seasoned
              specialists, without hiring fifteen of them.
            </p>
          </ScrollReveal>
        </div>
      </section>

      {/* Team */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">The people behind it</p>
          <h2 className="section-title">Three teams, one shared scoreboard.</h2>
        </div>
        <div className="team-grid">
          {TEAM.map((t, i) => (
            <ScrollReveal className="team-card" delay={(i % 3) + 1} key={t.title}>
              <span className="t-icon" aria-hidden="true">
                <t.icon size={26} strokeWidth={1.8} />
              </span>
              <h3>{t.title}</h3>
              <p>{t.desc}</p>
            </ScrollReveal>
          ))}
        </div>
      </section>

      {/* Timeline */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">Our journey</p>
          <h2 className="section-title">From one pod to an AI-native agency.</h2>
        </div>
        <div className="timeline">
          {TIMELINE.map((m, i) => (
            <ScrollReveal className="timeline-item" delay={(i % 4) + 1} key={m.year}>
              <span className="t-year">{m.year}</span>
              <h3>{m.title}</h3>
              <p>{m.desc}</p>
            </ScrollReveal>
          ))}
        </div>
      </section>

      {/* Values */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">What we believe</p>
          <h2 className="section-title">Six values we actually operate by.</h2>
          <p className="section-lead">Hover any card to see how it shows up in the work.</p>
        </div>
        <div className="values-grid">
          {VALUES.map((v, i) => (
            <div className="value-card" key={v.title}>
              <span className="v-num">0{i + 1}</span>
              <h3>{v.title}</h3>
              <p className="v-reveal">{v.reveal}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Tech parade */}
      <section className="section container">
        <div className="section-head center">
          <p className="eyebrow">Our toolkit</p>
          <h2 className="section-title">The stack we use to move fast.</h2>
        </div>
        <div className="tech-parade">
          {TECH.map((t) => (
            <span className="tech-chip" key={t}>
              {t}
            </span>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="section container">
        <div className="cta-banner">
          <p className="eyebrow">Let&apos;s build together</p>
          <h2>See what one accountable team can do.</h2>
          <div className="cta-actions">
            <GlowButton to="/contact">Get Free Consultation</GlowButton>
            <GlowButton to="/services" ghost arrow={false}>
              Explore services
            </GlowButton>
          </div>
        </div>
      </section>
    </>
  );
}
