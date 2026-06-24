import { Link } from 'react-router-dom';
import { Linkedin, Twitter, Github, Dribbble } from 'lucide-react';
import services from '../data/services';

const topServices = services.slice(0, 6);

export default function Footer() {
  const year = new Date().getFullYear();

  return (
    <footer className="footer">
      <div className="container">
        <div className="footer-grid">
          <div className="footer-brand">
            <Link to="/" className="logo">
              Nexus<span className="text-gradient">Works</span>
            </Link>
            <p>
              Where human intelligence meets AI precision. We build, scale and automate your entire
              business across 15+ specialized services — so you can focus on growth.
            </p>
          </div>

          <div className="footer-col">
            <h4>Company</h4>
            <Link to="/about">About</Link>
            <Link to="/services">Services</Link>
            <Link to="/blog">Blog</Link>
            <Link to="/contact">Contact</Link>
          </div>

          <div className="footer-col">
            <h4>Top Services</h4>
            {topServices.map((s) => (
              <Link key={s.slug} to={`/services/${s.slug}`}>
                {s.name}
              </Link>
            ))}
          </div>

          <div className="footer-col">
            <h4>Get Started</h4>
            <Link to="/contact">Free Consultation</Link>
            <Link to="/services">Explore Services</Link>
            <a href="mailto:hello@nexusworks.com">hello@nexusworks.com</a>
          </div>
        </div>

        <div className="footer-bottom">
          <span>© {year} NexusWorks. Faster delivery, smarter outcomes.</span>
          <div className="footer-socials">
            <a href="https://linkedin.com" aria-label="LinkedIn" target="_blank" rel="noreferrer">
              <Linkedin size={18} />
            </a>
            <a href="https://twitter.com" aria-label="Twitter / X" target="_blank" rel="noreferrer">
              <Twitter size={18} />
            </a>
            <a href="https://github.com" aria-label="GitHub" target="_blank" rel="noreferrer">
              <Github size={18} />
            </a>
            <a href="https://dribbble.com" aria-label="Dribbble" target="_blank" rel="noreferrer">
              <Dribbble size={18} />
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
