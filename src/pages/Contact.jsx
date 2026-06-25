import { useState } from 'react';
import { Mail, Clock, Sparkles, Check } from 'lucide-react';
import { services } from '../data/services.js';
import { submitQuery } from '../utils/api.js';
import GlowButton from '../components/GlowButton.jsx';

const BUDGETS = [
  'Under $5k',
  '$5k–$15k',
  '$15k–$30k',
  '$30k–$60k',
  '$60k+',
];

const TIMELINES = ['ASAP', 'Within 1 month', '1–3 months', 'Just exploring'];

const INFO = [
  {
    icon: Mail,
    title: 'Email us',
    body: 'hello@cortinix.com — we reply within one business day.',
  },
  {
    icon: Clock,
    title: 'Fast turnaround',
    body: 'Most engagements kick off within a week of your free consultation.',
  },
  {
    icon: Sparkles,
    title: 'AI + human from day one',
    body: 'You get the speed of automation and the judgment of senior specialists.',
  },
];

const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default function Contact() {
  const [form, setForm] = useState({
    name: '',
    email: '',
    phone: '',
    company: '',
    services: [],
    budgetIndex: 1,
    timeline: TIMELINES[1],
    message: '',
  });
  const [errors, setErrors] = useState({});
  const [status, setStatus] = useState('idle'); // idle | submitting | success | error
  const [serverError, setServerError] = useState('');

  const setField = (key, value) => setForm((f) => ({ ...f, [key]: value }));

  const toggleService = (name) =>
    setForm((f) => ({
      ...f,
      services: f.services.includes(name)
        ? f.services.filter((s) => s !== name)
        : [...f.services, name],
    }));

  const validate = () => {
    const e = {};
    if (!form.name.trim()) e.name = 'Please tell us your name.';
    if (!form.email.trim()) e.email = 'An email is required.';
    else if (!emailRe.test(form.email)) e.email = 'That email doesn’t look right.';
    if (!form.message.trim()) e.message = 'A short message helps us prepare.';
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleSubmit = async () => {
    setServerError('');
    if (!validate()) return;
    setStatus('submitting');

    const payload = {
      name: form.name.trim(),
      email: form.email.trim(),
      phone: form.phone.trim(),
      company: form.company.trim(),
      services: form.services,
      budget: BUDGETS[form.budgetIndex],
      timeline: form.timeline,
      message: form.message.trim(),
    };

    const res = await submitQuery(payload);
    if (res.success) {
      setStatus('success');
    } else {
      setStatus('error');
      setServerError(res.error || 'Something went wrong. Please try again.');
    }
  };

  return (
    <>
      <header className="page-hero container">
        <p className="eyebrow">Get in touch</p>
        <h1>
          Tell us the goal. We&apos;ll map the <span className="text-gradient">fastest path</span>.
        </h1>
        <p>
          One free consultation, one clear plan, one accountable team. No obligation, no jargon.
        </p>
      </header>

      <section className="section container">
        <div className="contact-split">
          {/* LEFT — info cards */}
          <div className="contact-info">
            {INFO.map((c) => (
              <div className="info-card" key={c.title}>
                <span className="i-icon" aria-hidden="true">
                  <c.icon size={22} strokeWidth={1.8} />
                </span>
                <div>
                  <h3>{c.title}</h3>
                  <p className="text-muted">{c.body}</p>
                </div>
              </div>
            ))}
          </div>

          {/* RIGHT — form / success */}
          <div className="contact-form">
            {status === 'success' ? (
              <div className="form-success" role="status" aria-live="polite">
                <span className="success-check" aria-hidden="true">
                  <Check size={40} strokeWidth={3} />
                </span>
                <h2>Got it — your request is in.</h2>
                <p>
                  Thanks, {form.name.split(' ')[0] || 'there'}. A strategist will reach out within one
                  business day with next steps and a few quick questions.
                </p>
                <GlowButton to="/services" arrow={false}>
                  Browse services while you wait
                </GlowButton>
              </div>
            ) : (
              <div>
                <div className="form-row">
                  <div className="field">
                    <label htmlFor="name">
                      Name <span className="req">*</span>
                    </label>
                    <input
                      id="name"
                      type="text"
                      value={form.name}
                      aria-invalid={!!errors.name}
                      onChange={(e) => setField('name', e.target.value)}
                      placeholder="Your name"
                    />
                    {errors.name && <span className="err">{errors.name}</span>}
                  </div>
                  <div className="field">
                    <label htmlFor="email">
                      Email <span className="req">*</span>
                    </label>
                    <input
                      id="email"
                      type="email"
                      value={form.email}
                      aria-invalid={!!errors.email}
                      onChange={(e) => setField('email', e.target.value)}
                      placeholder="you@company.com"
                    />
                    {errors.email && <span className="err">{errors.email}</span>}
                  </div>
                </div>

                <div className="form-row">
                  <div className="field">
                    <label htmlFor="phone">Phone</label>
                    <input
                      id="phone"
                      type="tel"
                      value={form.phone}
                      onChange={(e) => setField('phone', e.target.value)}
                      placeholder="Optional"
                    />
                  </div>
                  <div className="field">
                    <label htmlFor="company">Company</label>
                    <input
                      id="company"
                      type="text"
                      value={form.company}
                      onChange={(e) => setField('company', e.target.value)}
                      placeholder="Optional"
                    />
                  </div>
                </div>

                <div className="field">
                  <label>Services you&apos;re interested in</label>
                  <div className="multi-select">
                    {services.map((s) => (
                      <button
                        type="button"
                        key={s.id}
                        className={`ms-chip ${form.services.includes(s.name) ? 'active' : ''}`}
                        aria-pressed={form.services.includes(s.name)}
                        onClick={() => toggleService(s.name)}
                      >
                        {s.name}
                      </button>
                    ))}
                  </div>
                </div>

                <div className="form-row">
                  <div className="field">
                    <label htmlFor="budget">Project budget</label>
                    <div className="range-wrap">
                      <input
                        id="budget"
                        type="range"
                        min="0"
                        max={BUDGETS.length - 1}
                        step="1"
                        value={form.budgetIndex}
                        onChange={(e) => setField('budgetIndex', Number(e.target.value))}
                      />
                      <span className="range-value">{BUDGETS[form.budgetIndex]}</span>
                    </div>
                  </div>
                  <div className="field">
                    <label htmlFor="timeline">Timeline</label>
                    <select
                      id="timeline"
                      value={form.timeline}
                      onChange={(e) => setField('timeline', e.target.value)}
                    >
                      {TIMELINES.map((t) => (
                        <option key={t} value={t}>
                          {t}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>

                <div className="field">
                  <label htmlFor="message">
                    What are you trying to achieve? <span className="req">*</span>
                  </label>
                  <textarea
                    id="message"
                    value={form.message}
                    aria-invalid={!!errors.message}
                    onChange={(e) => setField('message', e.target.value)}
                    placeholder="A sentence or two about your goal, product or current bottleneck."
                  />
                  {errors.message && <span className="err">{errors.message}</span>}
                </div>

                {status === 'error' && serverError && (
                  <p className="err" role="alert" style={{ marginBottom: '1rem' }}>
                    {serverError}
                  </p>
                )}

                <GlowButton
                  arrow
                  magnetic={false}
                  onClick={handleSubmit}
                  type="button"
                  aria-busy={status === 'submitting'}
                >
                  {status === 'submitting' ? 'Sending…' : 'Start My Project'}
                </GlowButton>
              </div>
            )}
          </div>
        </div>
      </section>
    </>
  );
}
