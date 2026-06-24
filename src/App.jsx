import { lazy, Suspense, useEffect } from 'react';
import { Routes, Route, useLocation } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

import Navbar from './components/Navbar.jsx';
import Footer from './components/Footer.jsx';
import CursorTrail from './components/CursorTrail.jsx';
import ScrollProgress from './components/ScrollProgress.jsx';

gsap.registerPlugin(ScrollTrigger);

// ── Lazy-loaded routes ───────────────────────────────────
const Home = lazy(() => import('./pages/Home.jsx'));
const About = lazy(() => import('./pages/About.jsx'));
const ServicesIndex = lazy(() => import('./pages/Services/index.jsx'));
const ServiceDetail = lazy(() => import('./pages/Services/ServiceDetail.jsx'));
const Contact = lazy(() => import('./pages/Contact.jsx'));
const Blog = lazy(() => import('./pages/Blog.jsx'));

function RouteLoader() {
  return (
    <div className="route-loader" role="status" aria-live="polite">
      <span className="spinner" aria-hidden="true" />
      <span className="sr-only">Loading…</span>
    </div>
  );
}

function NotFound() {
  return (
    <section className="notfound container">
      <p className="eyebrow">404</p>
      <h1>This page wandered off the roadmap.</h1>
      <p className="section-lead">
        The link you followed may be broken, or the page may have been moved.
      </p>
      <a className="glow-btn" href="/">
        Back to home
      </a>
    </section>
  );
}

const pageVariants = {
  initial: { opacity: 0, y: 24 },
  enter: { opacity: 1, y: 0, transition: { duration: 0.45, ease: [0.22, 1, 0.36, 1] } },
  exit: { opacity: 0, y: -16, transition: { duration: 0.28, ease: [0.4, 0, 1, 1] } },
};

function Page({ children }) {
  const reduce =
    typeof window !== 'undefined' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  if (reduce) return <>{children}</>;

  return (
    <motion.div variants={pageVariants} initial="initial" animate="enter" exit="exit">
      {children}
    </motion.div>
  );
}

export default function App() {
  const location = useLocation();

  // Scroll to top + refresh/cleanup ScrollTrigger on every route change.
  useEffect(() => {
    window.scrollTo({ top: 0, left: 0, behavior: 'instant' in window ? 'instant' : 'auto' });
    // Kill triggers from the page we just left so they don't leak.
    ScrollTrigger.getAll().forEach((t) => t.kill());
    // Let the new page mount, then recalculate.
    const id = window.requestAnimationFrame(() => ScrollTrigger.refresh());
    return () => window.cancelAnimationFrame(id);
  }, [location.pathname]);

  return (
    <div className="app-shell">
      <a href="#main" className="skip-link">
        Skip to content
      </a>
      <ScrollProgress />
      <CursorTrail />
      <Navbar />

      <main id="main" className="app-main">
        <Suspense fallback={<RouteLoader />}>
          <AnimatePresence mode="wait">
            <Routes location={location} key={location.pathname}>
              <Route
                path="/"
                element={
                  <Page>
                    <Home />
                  </Page>
                }
              />
              <Route
                path="/about"
                element={
                  <Page>
                    <About />
                  </Page>
                }
              />
              <Route
                path="/services"
                element={
                  <Page>
                    <ServicesIndex />
                  </Page>
                }
              />
              <Route
                path="/services/:slug"
                element={
                  <Page>
                    <ServiceDetail />
                  </Page>
                }
              />
              <Route
                path="/contact"
                element={
                  <Page>
                    <Contact />
                  </Page>
                }
              />
              <Route
                path="/blog"
                element={
                  <Page>
                    <Blog />
                  </Page>
                }
              />
              <Route
                path="*"
                element={
                  <Page>
                    <NotFound />
                  </Page>
                }
              />
            </Routes>
          </AnimatePresence>
        </Suspense>
      </main>

      <Footer />
    </div>
  );
}
