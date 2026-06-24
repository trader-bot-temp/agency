import GlowButton from '../components/GlowButton.jsx';

export default function Blog() {
  return (
    <section className="blog-stub container">
      <div>
        <p className="eyebrow">Blog</p>
        <h1>
          Playbooks on growth, AI &amp; <span className="text-gradient">automation</span> — coming
          soon.
        </h1>
        <p className="section-lead" style={{ margin: '1.2rem auto 2rem' }}>
          We&apos;re writing the practical guides we wish we&apos;d had as founders. Want them first?
          Reach out and we&apos;ll send them your way.
        </p>
        <GlowButton to="/contact">Get on the list</GlowButton>
      </div>
    </section>
  );
}
