#!/usr/bin/env bash
# build.sh — scaffold the complete Cortinix project (folders + every file).
# Usage (from an empty directory):  bash build.sh && cd cortinix && npm install
set -euo pipefail
ROOT="cortinix"
echo "→ Scaffolding Cortinix into ./$ROOT"
mkdir -p "$ROOT"
mkdir -p "$ROOT/backend"
mkdir -p "$ROOT/backend/middleware"
mkdir -p "$ROOT/backend/models"
mkdir -p "$ROOT/backend/routes"
mkdir -p "$ROOT/public"
mkdir -p "$ROOT/src"
mkdir -p "$ROOT/src/components"
mkdir -p "$ROOT/src/data"
mkdir -p "$ROOT/src/pages"
mkdir -p "$ROOT/src/pages/Services"
mkdir -p "$ROOT/src/styles"
mkdir -p "$ROOT/src/utils"
echo "  • .env.example"
cat > "$ROOT/.env.example" << 'CORTINIX_EOF'
# ── Backend ───────────────────────────────────────────────
# MongoDB connection string (Atlas or local). Fill in user/password/cluster.
MONGODB_URI=mongodb+srv://<user>:<password>@cluster.mongodb.net/cortinix

# Port the Express API listens on
PORT=5000

# Frontend origin allowed by CORS
CLIENT_URL=http://localhost:5173

# Environment: development | production
NODE_ENV=development

# Basic-auth credentials protecting GET /api/queries (admin)
ADMIN_USER=admin
ADMIN_PASS=change-me-please

# ── Frontend (Vite) ───────────────────────────────────────
# Base URL the React app uses for API calls.
# Leave blank to use the Vite dev proxy (recommended in development).
VITE_API_URL=
CORTINIX_EOF
echo "  • .gitignore"
cat > "$ROOT/.gitignore" << 'CORTINIX_EOF'
# Dependencies
node_modules/
backend/node_modules/
.pnp
.pnp.js

# Build output
dist/
dist-ssr/
build/
*.local

# Environment
.env
.env.local
.env.*.local
backend/.env

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Editor / OS
.vscode/*
!.vscode/extensions.json
.idea/
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
Thumbs.db

# Misc
coverage/
.cache/
.temp/
CORTINIX_EOF
echo "  • README.md"
cat > "$ROOT/README.md" << 'CORTINIX_EOF'
# Cortinix

**Where Human Intelligence Meets AI Precision — Faster Delivery, Smarter Outcomes.**

A production-ready, fully animated agency website for an all-in-one services agency serving startups and SMEs. Dark-first design, AI + human messaging throughout, 15 service pages, a MongoDB-backed contact pipeline, and motion built with Framer Motion, GSAP/ScrollTrigger and a Three.js hero.

---

## Tech stack

| Layer       | Choice                                                        |
| ----------- | ------------------------------------------------------------- |
| Frontend    | React 18 + Vite + React Router v6                             |
| Animation   | Framer Motion (page transitions, reveals), GSAP + ScrollTrigger (pinned process), CSS keyframes (micro-interactions) |
| Styling     | Hand-written CSS with custom properties — no Tailwind          |
| 3D / Viz    | Three.js neural-network particle field on the hero            |
| Icons       | Lucide React                                                  |
| Backend     | Node.js + Express                                             |
| Database    | MongoDB + Mongoose                                            |

---

## Project structure

```
cortinix/
├── backend/
│   ├── middleware/      cors.js, errorHandler.js
│   ├── models/          Query.js          (Mongoose schema)
│   ├── routes/          queryRoutes.js    (POST + admin GET)
│   └── server.js        Express entry
├── public/              favicon.svg
├── src/
│   ├── components/      Navbar, Footer, ParticleField, ServiceCard,
│   │                    ScrollReveal, GlowButton, CursorTrail,
│   │                    AnimatedCounter, ScrollProgress, Icon
│   ├── data/            services.js       (single source for all 15 services)
│   ├── pages/           Home, About, Contact, Blog,
│   │                    Services/index.jsx + Services/ServiceDetail.jsx
│   ├── styles/          variables.css, animations.css, globals.css,
│   │                    components.css, pages.css
│   ├── utils/           api.js, useScrollAnimation.js
│   ├── App.jsx          router + global layout
│   └── main.jsx         React entry (imports all stylesheets)
├── .env.example
├── .gitignore
├── index.html
├── vite.config.js
└── package.json
```

> **Note on styles:** the brief specified three stylesheets. They were split into five (`components.css` and `pages.css` added) purely for maintainability — same tokens, just easier to navigate. They are imported in order in `src/main.jsx`.

> **Note on service pages:** all 15 service detail pages are rendered by one dynamic component (`Services/ServiceDetail.jsx`) driven by `src/data/services.js`, reachable at `/services/:slug`.

---

## Getting started

### 1. Install dependencies

```bash
npm install
```

This installs both the frontend and backend dependencies (they share one `package.json`).

### 2. Configure environment

```bash
cp .env.example .env
```

Then edit `.env`:

| Variable       | Purpose                                                        |
| -------------- | -------------------------------------------------------------- |
| `MONGODB_URI`  | MongoDB connection string (Atlas or local)                     |
| `PORT`         | Express API port (default 5000)                                |
| `CLIENT_URL`   | Allowed CORS origin (default `http://localhost:5173`)          |
| `NODE_ENV`     | `development` or `production`                                  |
| `ADMIN_USER`   | Basic-auth user for `GET /api/queries`                         |
| `ADMIN_PASS`   | Basic-auth password for the admin endpoint                     |
| `VITE_API_URL` | Frontend API base — leave blank in dev to use the Vite proxy   |

### 3. Run the backend

```bash
npm run server        # node backend/server.js
# or, with auto-reload:
npm run server:dev    # nodemon backend/server.js
```

### 4. Run the frontend (in a second terminal)

```bash
npm run dev
```

The app opens at `http://localhost:5173`. API calls to `/api/*` are proxied to the Express server on port 5000 automatically.

### 5. Production build

```bash
npm run build         # outputs to dist/
npm run preview       # preview the production build locally
```

Serve `dist/` from any static host and deploy `backend/` to a Node host. Set `VITE_API_URL` to the deployed API origin before building for production.

---

## API

### `POST /api/queries`

Body:

```json
{
  "name": "Ada Lovelace",
  "email": "ada@example.com",
  "phone": "+1 555 0100",
  "company": "Analytical Engines",
  "services": ["Web & App Development", "AI Web Tools & AI-Powered Apps"],
  "budget": "$15k–$30k",
  "timeline": "1–3 months",
  "message": "We need an AI dashboard and a new site."
}
```

Success → `201 { "success": true, "message": "Query received", "id": "..." }`
Validation error → `400 { "success": false, "errors": [...] }`

### `GET /api/queries` *(admin, basic-auth)*

Returns all queries sorted by `createdAt` desc. Protected by `ADMIN_USER` / `ADMIN_PASS`.

Validation runs on both the client (Contact form) and the server (express-validator + Mongoose schema). The public API is CORS-restricted and rate-limited (60 requests / 15 min / IP).

---

## Accessibility & performance

- Skip-to-content link, focus-visible rings, ARIA labels on interactive controls.
- `prefers-reduced-motion` is respected across CSS keyframes, the scroll-reveal hook, GSAP pinning, and the Three.js field (which also skips on touch devices).
- Service detail pages are lazy-loaded with `React.lazy` + `Suspense`.
- The Three.js renderer disposes all GPU resources and cancels its animation frame on unmount.
- All GSAP ScrollTrigger instances are killed on route change.

---

## Packaging

```bash
tar -czf cortinix.tar.gz cortinix/
```
CORTINIX_EOF
echo "  • backend/middleware/cors.js"
cat > "$ROOT/backend/middleware/cors.js" << 'CORTINIX_EOF'
import cors from 'cors';

/**
 * CORS configured from the CLIENT_URL env var. In development we also allow
 * the common Vite origins so the app works out of the box.
 */
const allowed = [
  process.env.CLIENT_URL,
  'http://localhost:5173',
  'http://127.0.0.1:5173',
].filter(Boolean);

const corsMiddleware = cors({
  origin(origin, callback) {
    // Allow non-browser tools (curl, server-to-server) with no origin.
    if (!origin || allowed.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error(`Origin ${origin} not allowed by CORS`));
  },
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
});

export default corsMiddleware;
CORTINIX_EOF
echo "  • backend/middleware/errorHandler.js"
cat > "$ROOT/backend/middleware/errorHandler.js" << 'CORTINIX_EOF'
/* eslint-disable no-unused-vars */

/** 404 handler — reached when no route matches. */
export function notFound(req, res, next) {
  res.status(404).json({ success: false, error: `Not found: ${req.method} ${req.originalUrl}` });
}

/**
 * Central error handler. Must keep the 4-arg signature for Express to
 * recognise it as an error middleware.
 */
export function errorHandler(err, req, res, next) {
  const status = err.statusCode || err.status || 500;

  // Mongoose validation errors -> 400 with readable messages.
  if (err.name === 'ValidationError') {
    const messages = Object.values(err.errors).map((e) => e.message);
    return res.status(400).json({ success: false, error: messages.join(', ') });
  }

  if (process.env.NODE_ENV !== 'test') {
    // eslint-disable-next-line no-console
    console.error('[error]', err.message);
  }

  return res.status(status).json({
    success: false,
    error: status === 500 ? 'Internal server error' : err.message,
  });
}
CORTINIX_EOF
echo "  • backend/models/Query.js"
cat > "$ROOT/backend/models/Query.js" << 'CORTINIX_EOF'
import mongoose from 'mongoose';

const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

const querySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required'],
      trim: true,
      maxlength: 120,
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      trim: true,
      lowercase: true,
      match: [emailRegex, 'Please provide a valid email address'],
    },
    phone: { type: String, trim: true, maxlength: 40, default: '' },
    company: { type: String, trim: true, maxlength: 160, default: '' },
    services: { type: [String], default: [] },
    budget: { type: String, trim: true, default: '' },
    timeline: { type: String, trim: true, default: '' },
    message: {
      type: String,
      required: [true, 'Message is required'],
      trim: true,
      maxlength: 5000,
    },
    status: {
      type: String,
      enum: ['new', 'read', 'replied'],
      default: 'new',
    },
  },
  { timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' } }
);

const Query = mongoose.model('Query', querySchema);

export default Query;
CORTINIX_EOF
echo "  • backend/routes/queryRoutes.js"
cat > "$ROOT/backend/routes/queryRoutes.js" << 'CORTINIX_EOF'
import { Router } from 'express';
import { body, validationResult } from 'express-validator';
import basicAuth from 'express-basic-auth';
import Query from '../models/Query.js';

const router = Router();

/* ── Validation chain for incoming queries ──────────────── */
const validateQuery = [
  body('name').trim().notEmpty().withMessage('Name is required').isLength({ max: 120 }),
  body('email').trim().isEmail().withMessage('A valid email is required').normalizeEmail(),
  body('phone').optional({ checkFalsy: true }).trim().isLength({ max: 40 }),
  body('company').optional({ checkFalsy: true }).trim().isLength({ max: 160 }),
  body('services').optional().isArray().withMessage('Services must be an array'),
  body('services.*').optional().isString().trim(),
  body('budget').optional({ checkFalsy: true }).trim().isLength({ max: 60 }),
  body('timeline').optional({ checkFalsy: true }).trim().isLength({ max: 60 }),
  body('message')
    .trim()
    .notEmpty()
    .withMessage('Message is required')
    .isLength({ max: 5000 })
    .withMessage('Message is too long'),
];

/**
 * POST /api/queries
 * Validate, sanitize and persist a contact query.
 */
router.post('/queries', validateQuery, async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, errors: errors.array() });
  }

  try {
    const { name, email, phone, company, services, budget, timeline, message } = req.body;
    const doc = await Query.create({
      name,
      email,
      phone,
      company,
      services: Array.isArray(services) ? services : [],
      budget,
      timeline,
      message,
    });
    return res.status(201).json({ success: true, message: 'Query received', id: doc._id });
  } catch (err) {
    return next(err);
  }
});

/* ── Admin basic-auth guard (GET only) ──────────────────── */
const adminAuth = basicAuth({
  users: { [process.env.ADMIN_USER || 'admin']: process.env.ADMIN_PASS || 'changeme' },
  challenge: true,
  realm: 'Cortinix Admin',
});

/**
 * GET /api/queries  (protected)
 * Returns all queries, newest first.
 */
router.get('/queries', adminAuth, async (req, res, next) => {
  try {
    const queries = await Query.find().sort({ createdAt: -1 }).lean();
    return res.json({ success: true, count: queries.length, queries });
  } catch (err) {
    return next(err);
  }
});

export default router;
CORTINIX_EOF
echo "  • backend/server.js"
cat > "$ROOT/backend/server.js" << 'CORTINIX_EOF'
import express from 'express';
import mongoose from 'mongoose';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';

import corsMiddleware from './middleware/cors.js';
import { notFound, errorHandler } from './middleware/errorHandler.js';
import queryRoutes from './routes/queryRoutes.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/cortinix';

// ── Core middleware ─────────────────────────────────────
app.disable('x-powered-by');
app.use(corsMiddleware);
app.use(express.json({ limit: '100kb' }));
app.use(express.urlencoded({ extended: true, limit: '100kb' }));

// ── Rate limiting (protects the public POST endpoint) ───
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 60, // 60 requests / IP / window
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: 'Too many requests — please try again later.' },
});
app.use('/api/', limiter);

// ── Health check ────────────────────────────────────────
app.get('/api/health', (req, res) => {
  res.json({ success: true, status: 'ok', uptime: process.uptime() });
});

// ── Routes ──────────────────────────────────────────────
app.use('/api', queryRoutes);

// ── 404 + error handling (must be last) ─────────────────
app.use(notFound);
app.use(errorHandler);

// ── Start ───────────────────────────────────────────────
async function start() {
  try {
    await mongoose.connect(MONGODB_URI);
    // eslint-disable-next-line no-console
    console.log('✓ MongoDB connected');
    app.listen(PORT, () => {
      // eslint-disable-next-line no-console
      console.log(`✓ Cortinix API running on http://localhost:${PORT}`);
    });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('✗ Failed to start server:', err.message);
    process.exit(1);
  }
}

start();

export default app;
CORTINIX_EOF
echo "  • index.html"
cat > "$ROOT/index.html" << 'CORTINIX_EOF'
<!doctype html>
<html lang="en" data-theme="dark">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta
      name="description"
      content="Cortinix — Where Human Intelligence Meets AI Precision. We build, scale and automate your entire business across 15+ specialized services."
    />
    <meta name="theme-color" content="#080C14" />

    <!-- Open Graph -->
    <meta property="og:title" content="Cortinix — Human Intelligence Meets AI Precision" />
    <meta
      property="og:description"
      content="AI + Human collaboration across 15+ specialized services. Faster delivery, smarter outcomes."
    />
    <meta property="og:type" content="website" />

    <!-- Fonts: Syne (display), Inter (body), JetBrains Mono (mono) -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500;700&display=swap"
      rel="stylesheet"
    />

    <title>Cortinix — Human Intelligence Meets AI Precision</title>
  </head>
  <body>
    <a class="skip-link" href="#main-content">Skip to content</a>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
CORTINIX_EOF
echo "  • package.json"
cat > "$ROOT/package.json" << 'CORTINIX_EOF'
{
  "name": "cortinix",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "description": "Cortinix — Where Human Intelligence Meets AI Precision. Production agency website.",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext js,jsx --report-unused-disable-directives --max-warnings 0",
    "server": "node backend/server.js",
    "server:dev": "nodemon backend/server.js"
  },
  "dependencies": {
    "axios": "^1.7.7",
    "cors": "^2.8.5",
    "dotenv": "^16.4.5",
    "express": "^4.21.0",
    "express-basic-auth": "^1.2.1",
    "express-rate-limit": "^7.4.0",
    "express-validator": "^7.2.0",
    "framer-motion": "^11.5.4",
    "gsap": "^3.12.5",
    "lucide-react": "^0.445.0",
    "mongoose": "^8.6.3",
    "react": "^18.3.1",
    "react-countup": "^6.5.3",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.26.2",
    "three": "^0.168.0"
  },
  "devDependencies": {
    "@types/react": "^18.3.5",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "eslint": "^8.57.0",
    "eslint-plugin-react": "^7.35.0",
    "eslint-plugin-react-hooks": "^4.6.2",
    "eslint-plugin-react-refresh": "^0.4.12",
    "nodemon": "^3.1.7",
    "vite": "^5.4.6"
  }
}
CORTINIX_EOF
echo "  • public/favicon.svg"
cat > "$ROOT/public/favicon.svg" << 'CORTINIX_EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#6C63FF"/>
      <stop offset="1" stop-color="#00D4AA"/>
    </linearGradient>
  </defs>
  <rect width="32" height="32" rx="8" fill="#080C14"/>
  <path d="M9 23V9h2.6l8.8 9.8V9H23v14h-2.6L11.6 13.2V23H9z" fill="url(#g)"/>
</svg>
CORTINIX_EOF
echo "  • src/App.jsx"
cat > "$ROOT/src/App.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/components/AnimatedCounter.jsx"
cat > "$ROOT/src/components/AnimatedCounter.jsx" << 'CORTINIX_EOF'
import CountUp from 'react-countup';
import useScrollAnimation from '../utils/useScrollAnimation';

/**
 * AnimatedCounter
 * Counts up to `end` when scrolled into view. Supports prefix/suffix and
 * decimals. Respects reduced-motion (the hook reveals instantly there,
 * and CountUp's duration becomes negligible).
 *
 * @param {number} end       target value
 * @param {string} prefix    text before the number (e.g. "$")
 * @param {string} suffix    text after the number (e.g. "+", "%", "x")
 * @param {number} decimals  decimal places (default 0)
 * @param {number} duration  seconds (default 2)
 */
export default function AnimatedCounter({
  end,
  prefix = '',
  suffix = '',
  decimals = 0,
  duration = 2,
  className = '',
}) {
  const [ref, isVisible] = useScrollAnimation({ threshold: 0.4 });

  return (
    <span ref={ref} className={className}>
      {isVisible ? (
        <CountUp
          end={end}
          duration={duration}
          decimals={decimals}
          prefix={prefix}
          suffix={suffix}
          separator=","
        />
      ) : (
        <span>
          {prefix}0{suffix}
        </span>
      )}
    </span>
  );
}
CORTINIX_EOF
echo "  • src/components/CursorTrail.jsx"
cat > "$ROOT/src/components/CursorTrail.jsx" << 'CORTINIX_EOF'
import { useEffect, useRef, useState } from 'react';

/**
 * CursorTrail
 * Custom glow cursor: a small dot that tracks instantly and a ring that
 * lags with easing. The ring expands when hovering interactive elements.
 *
 * Only runs on true mouse devices (fine pointer + hover capable) without
 * reduced-motion. On touch / coarse-pointer devices it renders nothing,
 * so the elements can never get stuck in a corner. It also hides itself
 * whenever the pointer leaves the window (or the tab loses focus) and
 * reappears on return.
 */
export default function CursorTrail() {
  const dotRef = useRef(null);
  const ringRef = useRef(null);
  const [enabled, setEnabled] = useState(false);

  // 1) Capability detection — decide once, on the client, whether to mount
  //    the custom cursor at all. Touch / coarse-pointer devices get nothing.
  useEffect(() => {
    const mq = window.matchMedia(
      '(pointer: fine) and (hover: hover) and (prefers-reduced-motion: no-preference)'
    );
    const apply = () => setEnabled(mq.matches);
    apply();
    // React to device/setting changes (e.g. plugging in a mouse).
    mq.addEventListener?.('change', apply);
    return () => {
      mq.removeEventListener?.('change', apply);
    };
  }, []);

  // 2) Animation + listeners — only once enabled (and the nodes are in the DOM).
  useEffect(() => {
    if (!enabled) return undefined;

    const dot = dotRef.current;
    const ring = ringRef.current;
    if (!dot || !ring) return undefined;

    document.body.classList.add('has-cursor-trail');

    const pos = { x: window.innerWidth / 2, y: window.innerHeight / 2 };
    const ringPos = { ...pos };
    let rafId = null;

    const onMove = (e) => {
      pos.x = e.clientX;
      pos.y = e.clientY;
      dot.style.left = `${pos.x}px`;
      dot.style.top = `${pos.y}px`;
    };

    const isInteractive = (el) =>
      el && el.closest('a, button, [data-cta], input, textarea, select, [role="button"]');

    const onOver = (e) => {
      ring.classList.toggle('is-hover', !!isInteractive(e.target));
    };

    // Hide when the pointer leaves the window; show when it returns.
    const hide = () => {
      dot.classList.add('is-hidden');
      ring.classList.add('is-hidden');
    };
    const show = () => {
      dot.classList.remove('is-hidden');
      ring.classList.remove('is-hidden');
    };

    const loop = () => {
      ringPos.x += (pos.x - ringPos.x) * 0.18;
      ringPos.y += (pos.y - ringPos.y) * 0.18;
      ring.style.left = `${ringPos.x}px`;
      ring.style.top = `${ringPos.y}px`;
      rafId = requestAnimationFrame(loop);
    };

    window.addEventListener('mousemove', onMove, { passive: true });
    window.addEventListener('mouseover', onOver, { passive: true });
    // `mouseleave`/`mouseenter` on document fire as the pointer crosses the
    // window boundary; blur/focus cover tab and window switches.
    document.addEventListener('mouseleave', hide);
    document.addEventListener('mouseenter', show);
    window.addEventListener('blur', hide);
    window.addEventListener('focus', show);
    loop();

    return () => {
      document.body.classList.remove('has-cursor-trail');
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseover', onOver);
      document.removeEventListener('mouseleave', hide);
      document.removeEventListener('mouseenter', show);
      window.removeEventListener('blur', hide);
      window.removeEventListener('focus', show);
      if (rafId) cancelAnimationFrame(rafId);
    };
  }, [enabled]);

  // Nothing is rendered on touch / coarse-pointer / reduced-motion devices,
  // so the dot and ring can never appear stuck in a corner.
  if (!enabled) return null;

  return (
    <>
      <div ref={dotRef} className="cursor-dot" aria-hidden="true" />
      <div ref={ringRef} className="cursor-ring" aria-hidden="true" />
    </>
  );
}
CORTINIX_EOF
echo "  • src/components/Footer.jsx"
cat > "$ROOT/src/components/Footer.jsx" << 'CORTINIX_EOF'
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
              Corti<span className="text-gradient">nix</span>
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
            <a href="mailto:hello@cortinix.com">hello@cortinix.com</a>
          </div>
        </div>

        <div className="footer-bottom">
          <span>© {year} Cortinix. Faster delivery, smarter outcomes.</span>
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
CORTINIX_EOF
echo "  • src/components/GlowButton.jsx"
cat > "$ROOT/src/components/GlowButton.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/components/Icon.jsx"
cat > "$ROOT/src/components/Icon.jsx" << 'CORTINIX_EOF'
import * as Lucide from 'lucide-react';

/**
 * Icon
 * Resolves a Lucide icon by its component name (string) so data files
 * can reference icons declaratively. Falls back to a neutral dot.
 *
 * @param {string} name  Lucide component name, e.g. "Megaphone"
 */
export default function Icon({ name, size = 22, strokeWidth = 1.8, ...rest }) {
  const Cmp = Lucide[name] || Lucide.Circle;
  return <Cmp size={size} strokeWidth={strokeWidth} aria-hidden="true" {...rest} />;
}
CORTINIX_EOF
echo "  • src/components/Navbar.jsx"
cat > "$ROOT/src/components/Navbar.jsx" << 'CORTINIX_EOF'
import { useEffect, useState } from 'react';
import { Link, NavLink, useLocation } from 'react-router-dom';
import { Menu, X } from 'lucide-react';
import GlowButton from './GlowButton';

const LINKS = [
  { to: '/', label: 'Home', end: true },
  { to: '/about', label: 'About' },
  { to: '/services', label: 'Services' },
  { to: '/blog', label: 'Blog' },
  { to: '/contact', label: 'Contact' },
];

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  const location = useLocation();

  // Add a solid background once the user scrolls.
  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 24);
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  // Close mobile menu on route change.
  useEffect(() => {
    setOpen(false);
  }, [location.pathname]);

  // Lock body scroll while the mobile menu is open.
  useEffect(() => {
    document.body.style.overflow = open ? 'hidden' : '';
    return () => {
      document.body.style.overflow = '';
    };
  }, [open]);

  return (
    <header className={`navbar ${scrolled ? 'is-scrolled' : ''}`}>
      <nav className="navbar-inner container" aria-label="Primary">
        <Link to="/" className="navbar-logo" aria-label="Cortinix home">
          <span className="logo-mark" aria-hidden="true">
            C
          </span>
          <span className="logo-text">
            Corti<span className="text-gradient">nix</span>
          </span>
        </Link>

        <ul className="navbar-links">
          {LINKS.map((l) => (
            <li key={l.to}>
              <NavLink
                to={l.to}
                end={l.end}
                className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}
              >
                {l.label}
              </NavLink>
            </li>
          ))}
        </ul>

        <div className="navbar-actions">
          <div className="navbar-cta-desktop">
            <GlowButton to="/contact">Get Free Consultation</GlowButton>
          </div>

          <button
            className="navbar-burger"
            onClick={() => setOpen((o) => !o)}
            aria-label={open ? 'Close menu' : 'Open menu'}
            aria-expanded={open}
          >
            {open ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </nav>

      {/* Mobile menu */}
      <div className={`mobile-menu ${open ? 'is-open' : ''}`} aria-hidden={!open}>
        <ul>
          {LINKS.map((l) => (
            <li key={l.to}>
              <NavLink
                to={l.to}
                end={l.end}
                className={({ isActive }) => `mobile-link ${isActive ? 'active' : ''}`}
              >
                {l.label}
              </NavLink>
            </li>
          ))}
        </ul>
        <GlowButton to="/contact" className="mobile-cta">
          Get Free Consultation
        </GlowButton>
      </div>
    </header>
  );
}
CORTINIX_EOF
echo "  • src/components/ParticleField.jsx"
cat > "$ROOT/src/components/ParticleField.jsx" << 'CORTINIX_EOF'
import { useEffect, useRef } from 'react';
import * as THREE from 'three';

/**
 * ParticleField
 * A subtle WebGL "neural network": ~50 nodes drifting in 3D, connected by
 * lines when close, with mouse parallax. Performance-aware:
 *  - skips entirely under prefers-reduced-motion or on coarse pointers (touch)
 *  - caps devicePixelRatio
 *  - cancels rAF and disposes all GPU resources on unmount
 */
export default function ParticleField({ nodeCount = 50 }) {
  const mountRef = useRef(null);

  useEffect(() => {
    const mount = mountRef.current;
    if (!mount) return undefined;

    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const isCoarse = window.matchMedia('(pointer: coarse)').matches;
    // On touch / reduced-motion we render a single static frame (no rAF loop).
    const animate = !prefersReduced && !isCoarse;

    const width = mount.clientWidth;
    const height = mount.clientHeight;

    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(60, width / height, 0.1, 1000);
    camera.position.z = 60;

    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setSize(width, height);
    renderer.setClearColor(0x000000, 0);
    mount.appendChild(renderer.domElement);

    // ── Nodes ──────────────────────────────────────────────
    const range = 70;
    const positions = new Float32Array(nodeCount * 3);
    const velocities = [];
    for (let i = 0; i < nodeCount; i += 1) {
      positions[i * 3] = (Math.random() - 0.5) * range;
      positions[i * 3 + 1] = (Math.random() - 0.5) * range * 0.7;
      positions[i * 3 + 2] = (Math.random() - 0.5) * range * 0.6;
      velocities.push(
        new THREE.Vector3(
          (Math.random() - 0.5) * 0.06,
          (Math.random() - 0.5) * 0.06,
          (Math.random() - 0.5) * 0.06
        )
      );
    }

    const nodeGeo = new THREE.BufferGeometry();
    nodeGeo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    const nodeMat = new THREE.PointsMaterial({
      color: 0x00d4aa,
      size: 1.6,
      transparent: true,
      opacity: 0.9,
      sizeAttenuation: true,
    });
    const points = new THREE.Points(nodeGeo, nodeMat);
    scene.add(points);

    // ── Connecting lines ───────────────────────────────────
    const lineMat = new THREE.LineBasicMaterial({
      color: 0x6c63ff,
      transparent: true,
      opacity: 0.22,
    });
    const lineGeo = new THREE.BufferGeometry();
    const maxLineVerts = nodeCount * nodeCount * 2;
    const linePositions = new Float32Array(maxLineVerts * 3);
    lineGeo.setAttribute('position', new THREE.BufferAttribute(linePositions, 3));
    const lines = new THREE.LineSegments(lineGeo, lineMat);
    scene.add(lines);

    const connectDist = 18;
    const rebuildLines = () => {
      let v = 0;
      const pos = nodeGeo.attributes.position.array;
      for (let i = 0; i < nodeCount; i += 1) {
        for (let j = i + 1; j < nodeCount; j += 1) {
          const dx = pos[i * 3] - pos[j * 3];
          const dy = pos[i * 3 + 1] - pos[j * 3 + 1];
          const dz = pos[i * 3 + 2] - pos[j * 3 + 2];
          const d = Math.sqrt(dx * dx + dy * dy + dz * dz);
          if (d < connectDist) {
            linePositions[v++] = pos[i * 3];
            linePositions[v++] = pos[i * 3 + 1];
            linePositions[v++] = pos[i * 3 + 2];
            linePositions[v++] = pos[j * 3];
            linePositions[v++] = pos[j * 3 + 1];
            linePositions[v++] = pos[j * 3 + 2];
          }
        }
      }
      lineGeo.setDrawRange(0, v / 3);
      lineGeo.attributes.position.needsUpdate = true;
    };

    // ── Mouse parallax ─────────────────────────────────────
    const mouse = { x: 0, y: 0 };
    const target = { x: 0, y: 0 };
    const onMouseMove = (e) => {
      target.x = (e.clientX / window.innerWidth - 0.5) * 2;
      target.y = (e.clientY / window.innerHeight - 0.5) * 2;
    };
    if (animate) window.addEventListener('mousemove', onMouseMove, { passive: true });

    let rafId = null;
    const tick = () => {
      const pos = nodeGeo.attributes.position.array;
      for (let i = 0; i < nodeCount; i += 1) {
        pos[i * 3] += velocities[i].x;
        pos[i * 3 + 1] += velocities[i].y;
        pos[i * 3 + 2] += velocities[i].z;
        // bounce within the box
        for (let a = 0; a < 3; a += 1) {
          const limit = a === 0 ? range / 2 : a === 1 ? (range * 0.7) / 2 : (range * 0.6) / 2;
          if (pos[i * 3 + a] > limit || pos[i * 3 + a] < -limit) {
            velocities[i].setComponent(a, -velocities[i].getComponent(a));
          }
        }
      }
      nodeGeo.attributes.position.needsUpdate = true;
      rebuildLines();

      mouse.x += (target.x - mouse.x) * 0.04;
      mouse.y += (target.y - mouse.y) * 0.04;
      scene.rotation.y = mouse.x * 0.3;
      scene.rotation.x = mouse.y * 0.2;
      points.rotation.z += 0.0006;
      lines.rotation.z = points.rotation.z;

      renderer.render(scene, camera);
      rafId = requestAnimationFrame(tick);
    };

    if (animate) {
      tick();
    } else {
      rebuildLines();
      renderer.render(scene, camera);
    }

    // ── Resize ─────────────────────────────────────────────
    const onResize = () => {
      const w = mount.clientWidth;
      const h = mount.clientHeight;
      camera.aspect = w / h;
      camera.updateProjectionMatrix();
      renderer.setSize(w, h);
      if (!animate) renderer.render(scene, camera);
    };
    window.addEventListener('resize', onResize);

    // ── Cleanup ────────────────────────────────────────────
    return () => {
      if (rafId) cancelAnimationFrame(rafId);
      window.removeEventListener('resize', onResize);
      window.removeEventListener('mousemove', onMouseMove);
      nodeGeo.dispose();
      nodeMat.dispose();
      lineGeo.dispose();
      lineMat.dispose();
      renderer.dispose();
      if (renderer.domElement.parentNode === mount) {
        mount.removeChild(renderer.domElement);
      }
    };
  }, [nodeCount]);

  return <div ref={mountRef} className="particle-field" aria-hidden="true" />;
}
CORTINIX_EOF
echo "  • src/components/ScrollProgress.jsx"
cat > "$ROOT/src/components/ScrollProgress.jsx" << 'CORTINIX_EOF'
import { motion, useScroll, useSpring } from 'framer-motion';

/**
 * ScrollProgress
 * A thin violet line at the top of the viewport that fills with page
 * scroll. Uses Framer Motion's scroll progress + a spring for smoothness.
 */
export default function ScrollProgress() {
  const { scrollYProgress } = useScroll();
  const scaleX = useSpring(scrollYProgress, {
    stiffness: 120,
    damping: 30,
    restDelta: 0.001,
  });

  return <motion.div className="scroll-progress" style={{ scaleX }} aria-hidden="true" />;
}
CORTINIX_EOF
echo "  • src/components/ScrollReveal.jsx"
cat > "$ROOT/src/components/ScrollReveal.jsx" << 'CORTINIX_EOF'
import useScrollAnimation from '../utils/useScrollAnimation';

/**
 * ScrollReveal
 * Wraps children in an element that fades/slides up when scrolled into view.
 * Uses the `.reveal` CSS class + `is-visible` toggle.
 *
 * @param {1|2|3|4} delay   stagger step (maps to CSS data-delay)
 * @param {string}  as      element tag to render (default "div")
 */
export default function ScrollReveal({
  children,
  delay,
  as: Tag = 'div',
  className = '',
  ...rest
}) {
  const [ref, isVisible] = useScrollAnimation();

  return (
    <Tag
      ref={ref}
      className={`reveal ${isVisible ? 'is-visible' : ''} ${className}`.trim()}
      data-delay={delay}
      {...rest}
    >
      {children}
    </Tag>
  );
}
CORTINIX_EOF
echo "  • src/components/ServiceCard.jsx"
cat > "$ROOT/src/components/ServiceCard.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/data/services.js"
cat > "$ROOT/src/data/services.js" << 'CORTINIX_EOF'
/**
 * services.js
 * Single source of truth for all 15 Cortinix services.
 * Consumed by the Services index (cards) and the dynamic
 * ServiceDetail page. `icon`/deliverable `icon` values are
 * Lucide React component names resolved at render time.
 */

export const CATEGORIES = ['All', 'Tech', 'Creative', 'Business', 'Data'];

export const services = [
  {
    id: 1,
    slug: 'digital-marketing',
    name: 'Digital Marketing',
    category: 'Business',
    icon: 'Megaphone',
    accent: 'var(--accent-1)',
    aiAssisted: true,
    tagline: 'Pipeline that compounds — not ad spend that evaporates.',
    teaser: 'SEO, paid, social and email run as one growth engine, tuned daily by AI and steered by strategists.',
    illustration: 'funnel',
    whatWeDo: [
      { icon: 'Search', title: 'Search & SEO', desc: 'Technical fixes, topic clusters and content that ranks for buyer intent, not vanity keywords.' },
      { icon: 'Target', title: 'Paid Acquisition', desc: 'Google, Meta and LinkedIn campaigns built around CAC and payback, with weekly creative refreshes.' },
      { icon: 'Mail', title: 'Lifecycle & Email', desc: 'Nurture, onboarding and win-back flows that turn one-time visitors into repeat revenue.' },
    ],
    aiHuman: {
      ai: 'AI clusters thousands of keywords, drafts ad-copy variants, and flags budget leaks the moment ROAS dips.',
      human: 'Strategists set positioning, approve messaging, and make the calls AI cannot — what to say, to whom, and why now.',
    },
    process: [
      { step: 'Audit', desc: 'We map your funnel, channels and unit economics to find where money is actually leaking.' },
      { step: 'Plan', desc: 'A 90-day channel mix with targets tied to CAC, LTV and payback period.' },
      { step: 'Launch', desc: 'Campaigns, landing pages and tracking go live with clean attribution from day one.' },
      { step: 'Optimize', desc: 'AI-assisted daily bid and creative tuning; humans reallocate budget weekly.' },
      { step: 'Scale', desc: 'Double down on winning channels and expand into new audiences and geos.' },
    ],
    tools: ['Google Ads', 'Meta Ads', 'GA4', 'Ahrefs', 'HubSpot', 'Klaviyo', 'Looker Studio'],
    roi: [
      { metric: '35%', label: 'Lower CAC within 90 days' },
      { metric: '3.2x', label: 'Average return on ad spend' },
      { metric: '2.5x', label: 'More qualified pipeline' },
    ],
    caseStudy: {
      client: 'A seed-stage B2B SaaS',
      result: 'Cut blended CAC 38% and tripled demo bookings in one quarter by killing three losing channels and reinvesting in intent-based search.',
    },
    faq: [
      { q: 'How fast do we see results?', a: 'Paid channels move within weeks; SEO and lifecycle compound over 3–6 months. We report leading indicators from week one.' },
      { q: 'Do we own the accounts and data?', a: 'Always. Every ad account, analytics property and email list stays in your name — we never hold your growth hostage.' },
      { q: 'What budget do we need?', a: 'We work with media budgets from $3k/mo upward and will tell you honestly if a channel is not yet worth funding.' },
      { q: 'How is AI used here?', a: 'For research, drafting and anomaly detection — never to auto-publish. A human approves everything customer-facing.' },
    ],
  },
  {
    id: 2,
    slug: 'graphic-design',
    name: 'Graphic Design',
    category: 'Creative',
    icon: 'Palette',
    accent: 'var(--accent-3)',
    aiAssisted: true,
    tagline: 'A brand that looks funded — long before you are.',
    teaser: 'Branding, UI kits, decks and collateral with one consistent system, shipped in days not months.',
    illustration: 'palette',
    whatWeDo: [
      { icon: 'Sparkles', title: 'Brand Identity', desc: 'Logo, palette, type and a usage system your whole team can apply without us.' },
      { icon: 'LayoutGrid', title: 'Marketing Collateral', desc: 'Social templates, one-pagers and ads that stay on-brand at any scale.' },
      { icon: 'Presentation', title: 'Pitch & Sales Decks', desc: 'Investor and sales decks engineered to hold attention and close.' },
    ],
    aiHuman: {
      ai: 'AI generates moodboards and rapid layout variations so we explore ten directions in the time one used to take.',
      human: 'Designers make the taste calls — hierarchy, restraint, and the details that separate "designed" from "templated".',
    },
    process: [
      { step: 'Discover', desc: 'We learn your market, audience and the feeling your brand should trigger.' },
      { step: 'Explore', desc: 'Multiple distinct directions, not three tints of the same idea.' },
      { step: 'Refine', desc: 'We sharpen the chosen route into a complete, documented system.' },
      { step: 'Deliver', desc: 'Source files, brand guidelines and ready-to-use templates.' },
    ],
    tools: ['Figma', 'Illustrator', 'Photoshop', 'After Effects', 'Midjourney', 'Brandbook'],
    roi: [
      { metric: '5 days', label: 'To a usable brand system' },
      { metric: '+47%', label: 'Lift in landing-page trust signals' },
      { metric: '1', label: 'Consistent system, infinite assets' },
    ],
    caseStudy: {
      client: 'A fintech raising a pre-seed',
      result: 'Rebuilt identity and pitch deck in 8 days; the founder credited the new look with warmer first meetings and a faster close.',
    },
    faq: [
      { q: 'Do we get editable source files?', a: 'Yes — fully organised Figma and Adobe files, plus guidelines so your team can extend the system.' },
      { q: 'How many revisions are included?', a: 'Each milestone includes two structured revision rounds; we focus feedback so rounds stay productive.' },
      { q: 'Can you match an existing brand?', a: 'Absolutely. We can evolve what you have or rebuild from scratch — your call.' },
      { q: 'Where does AI fit in?', a: 'In ideation and asset generation. Final craft, composition and brand decisions are always human-led.' },
    ],
  },
  {
    id: 3,
    slug: 'video-editing-production',
    name: 'Video Editing & Production',
    category: 'Creative',
    icon: 'Video',
    accent: 'var(--accent-3)',
    aiAssisted: true,
    tagline: 'Stop the scroll. Then earn the next ten seconds.',
    teaser: 'Reels, explainers, ads and YouTube content edited for retention, captioned and reformatted for every platform.',
    illustration: 'film',
    whatWeDo: [
      { icon: 'Clapperboard', title: 'Short-Form & Reels', desc: 'Hook-first edits sized for Reels, Shorts and TikTok with on-brand captions.' },
      { icon: 'MonitorPlay', title: 'Explainers & Ads', desc: 'Story-driven product videos and performance ad variants built to convert.' },
      { icon: 'Youtube', title: 'Long-Form & YouTube', desc: 'Full episode editing, thumbnails and chaptering for channel growth.' },
    ],
    aiHuman: {
      ai: 'AI auto-transcribes, generates captions, and surfaces the highest-retention moments to cut around.',
      human: 'Editors shape pacing, sound and story — the rhythm that makes a viewer stay is a human craft.',
    },
    process: [
      { step: 'Brief', desc: 'We align on platform, goal and the single message each video must land.' },
      { step: 'Assemble', desc: 'Rough cut focused on the hook and core narrative beats.' },
      { step: 'Polish', desc: 'Color, sound design, captions and motion graphics.' },
      { step: 'Adapt', desc: 'Reframed and resized exports for every channel you publish to.' },
    ],
    tools: ['Premiere Pro', 'After Effects', 'DaVinci Resolve', 'CapCut', 'Descript', 'Frame.io'],
    roi: [
      { metric: '+62%', label: 'Average watch-time vs prior edits' },
      { metric: '4x', label: 'Output across platforms per shoot' },
      { metric: '48h', label: 'Typical turnaround on short-form' },
    ],
    caseStudy: {
      client: 'A DTC skincare brand',
      result: 'Turned one studio day into 24 platform-native ads; the top three variants cut cost-per-acquisition by nearly a third.',
    },
    faq: [
      { q: 'Do you handle filming too?', a: 'We can produce end-to-end or edit footage you supply — both are common.' },
      { q: 'What is the turnaround?', a: 'Short-form usually 48–72 hours; explainers and long-form scale with complexity. We agree dates up front.' },
      { q: 'Who owns the footage?', a: 'You do — all raw files and project exports are handed over on delivery.' },
      { q: 'How is AI used?', a: 'Transcription, captioning and rough selects. Creative cut decisions stay with the editor.' },
    ],
  },
  {
    id: 4,
    slug: 'motion-graphics-animation',
    name: 'Motion Graphics & 2D Animation',
    category: 'Creative',
    icon: 'Film',
    accent: 'var(--accent-3)',
    aiAssisted: true,
    tagline: 'Make the abstract obvious — in motion.',
    teaser: 'Brand intros, animated infographics and product demos that explain complex ideas in seconds.',
    illustration: 'motion',
    whatWeDo: [
      { icon: 'Wand2', title: 'Brand Intros & Logo Stings', desc: 'Signature animated logos and openers that make you memorable.' },
      { icon: 'BarChart3', title: 'Animated Infographics', desc: 'Data and processes turned into clear, shareable motion.' },
      { icon: 'Boxes', title: 'Product Demos', desc: 'Animated walkthroughs that show value before a single sales call.' },
    ],
    aiHuman: {
      ai: 'AI accelerates storyboarding and roughs in-betweens, compressing pre-production dramatically.',
      human: 'Animators own timing, easing and the personality that makes motion feel alive rather than mechanical.',
    },
    process: [
      { step: 'Script', desc: 'We write the narration and define every beat before a frame is drawn.' },
      { step: 'Storyboard', desc: 'Frames and a style frame lock look and flow.' },
      { step: 'Animate', desc: 'Design, rigging and animation with iterative previews.' },
      { step: 'Finish', desc: 'Sound design, voiceover and delivery in every format you need.' },
    ],
    tools: ['After Effects', 'Lottie', 'Figma', 'Illustrator', 'Cavalry', 'GSAP'],
    roi: [
      { metric: '90s', label: 'To explain what took a 20-min call' },
      { metric: '+44%', label: 'Demo-page conversion with motion' },
      { metric: '100%', label: 'On-brand, reusable asset library' },
    ],
    caseStudy: {
      client: 'A logistics startup',
      result: 'A 75-second animated explainer replaced a dense slide deck and lifted demo requests off the product page by 44%.',
    },
    faq: [
      { q: 'Can you animate for web with Lottie?', a: 'Yes — we export lightweight Lottie/JSON so animations run crisp and tiny in your product.' },
      { q: 'Do you write the script too?', a: 'We can. Most projects start with us scripting and storyboarding before any animation.' },
      { q: 'What about voiceover?', a: 'We arrange professional VO or sync to one you provide.' },
      { q: 'Where does AI help?', a: 'Storyboard generation and rough timing. Final animation craft is entirely human.' },
    ],
  },
  {
    id: 5,
    slug: 'web-app-development',
    name: 'Web & App Development',
    category: 'Tech',
    icon: 'Code2',
    accent: 'var(--accent-1)',
    aiAssisted: true,
    tagline: 'Ship the product, not the excuses.',
    teaser: 'React/Next.js sites, mobile apps and PWAs built clean, fast and ready to scale with your roadmap.',
    illustration: 'code',
    whatWeDo: [
      { icon: 'Globe', title: 'Marketing & Product Sites', desc: 'Fast, accessible, SEO-ready React/Next.js front-ends.' },
      { icon: 'Smartphone', title: 'Mobile Apps & PWAs', desc: 'Cross-platform apps and installable PWAs from one codebase.' },
      { icon: 'Server', title: 'APIs & Integrations', desc: 'Node back-ends, databases and third-party integrations done right.' },
    ],
    aiHuman: {
      ai: 'AI pair-programming accelerates scaffolding, tests and boilerplate so engineers spend time on architecture.',
      human: 'Senior engineers own system design, security and the trade-offs that keep your codebase maintainable.',
    },
    process: [
      { step: 'Scope', desc: 'We turn your idea into a clear spec, milestones and a realistic timeline.' },
      { step: 'Architect', desc: 'Data models, stack and infrastructure decided before code is written.' },
      { step: 'Build', desc: 'Iterative sprints with working previews you can click every week.' },
      { step: 'Harden', desc: 'Testing, accessibility, performance budgets and security review.' },
      { step: 'Launch', desc: 'CI/CD, monitoring and a clean handover with documentation.' },
    ],
    tools: ['React', 'Next.js', 'Node.js', 'TypeScript', 'PostgreSQL', 'MongoDB', 'Vercel', 'Docker'],
    roi: [
      { metric: '<1.5s', label: 'Target largest-contentful-paint' },
      { metric: '40%', label: 'Faster delivery with AI-assisted dev' },
      { metric: '90+', label: 'Lighthouse scores at launch' },
    ],
    caseStudy: {
      client: 'A marketplace startup',
      result: 'Rebuilt a sluggish legacy app as a Next.js PWA; page loads dropped from 6s to under 1.5s and signups rose 28%.',
    },
    faq: [
      { q: 'Do we own the code?', a: 'Yes — full repo access from day one, no lock-in, clean documentation on handover.' },
      { q: 'Can you join an existing codebase?', a: 'We do regularly. We start with an audit and a low-risk first ticket to prove fit.' },
      { q: 'Do you offer maintenance?', a: 'Optional retainers cover updates, monitoring and new features after launch.' },
      { q: 'How does AI factor in?', a: 'As a productivity multiplier for our engineers — every line is reviewed by a human before merge.' },
    ],
  },
  {
    id: 6,
    slug: 'ai-web-tools',
    name: 'AI Web Tools & AI-Powered Apps',
    category: 'Tech',
    icon: 'BrainCircuit',
    accent: 'var(--accent-2)',
    aiAssisted: true,
    tagline: 'Put a brain behind your product.',
    teaser: 'Custom GPT integrations, RAG pipelines, chatbots and AI dashboards wired safely into your real workflows.',
    illustration: 'neural',
    whatWeDo: [
      { icon: 'MessageSquareCode', title: 'Chatbots & Assistants', desc: 'Support and internal assistants grounded in your own data.' },
      { icon: 'Database', title: 'RAG Pipelines', desc: 'Retrieval systems that let LLMs answer from your documents accurately.' },
      { icon: 'Gauge', title: 'AI Dashboards & Workflows', desc: 'LLM-powered automations and dashboards embedded in your stack.' },
    ],
    aiHuman: {
      ai: 'The product itself is AI — models reason, summarise and generate inside the workflows we build.',
      human: 'Engineers handle evaluation, guardrails and the prompts and retrieval that keep outputs accurate and safe.',
    },
    process: [
      { step: 'Use case', desc: 'We pick a high-value, low-risk workflow where AI clearly beats the status quo.' },
      { step: 'Prototype', desc: 'A working proof-of-concept with real data inside two weeks.' },
      { step: 'Ground', desc: 'Retrieval, evaluation and guardrails to keep answers accurate and on-policy.' },
      { step: 'Integrate', desc: 'Embed into your product or tools with monitoring and cost controls.' },
      { step: 'Improve', desc: 'Ongoing eval and prompt/retrieval tuning as usage grows.' },
    ],
    tools: ['OpenAI', 'Anthropic', 'LangChain', 'Pinecone', 'pgvector', 'Vercel AI SDK', 'Python'],
    roi: [
      { metric: '70%', label: 'Of repetitive tickets auto-resolved' },
      { metric: '2 weeks', label: 'To a working AI prototype' },
      { metric: '24/7', label: 'Coverage without extra headcount' },
    ],
    caseStudy: {
      client: 'A B2B support team',
      result: 'A RAG assistant grounded in their help docs deflected 70% of tier-1 tickets while keeping a human in the loop for edge cases.',
    },
    faq: [
      { q: 'Will the AI make things up?', a: 'We ground responses in your data and add evaluation plus guardrails to minimise and contain hallucination.' },
      { q: 'Is our data used to train models?', a: 'No. We use enterprise endpoints with no-training terms and keep your data in your environment where possible.' },
      { q: 'What does it cost to run?', a: 'We design for token efficiency and give you transparent cost monitoring from day one.' },
      { q: 'Which models do you use?', a: 'Whatever fits the task and budget — we stay model-agnostic and can switch as the landscape changes.' },
    ],
  },
  {
    id: 7,
    slug: 'crm-setup-management',
    name: 'CRM Setup & Management',
    category: 'Business',
    icon: 'Users',
    accent: 'var(--accent-1)',
    aiAssisted: true,
    tagline: 'Stop running sales out of a spreadsheet.',
    teaser: 'HubSpot, Salesforce or custom CRM builds with pipelines, automation and reporting your team will actually use.',
    illustration: 'pipeline',
    whatWeDo: [
      { icon: 'GitBranch', title: 'Pipeline Design', desc: 'Stages, fields and automation that mirror how you really sell.' },
      { icon: 'Workflow', title: 'Automation & Enablement', desc: 'Lead routing, sequences and playbooks that remove busywork.' },
      { icon: 'LineChart', title: 'Reporting & Forecasting', desc: 'Dashboards leadership can trust for pipeline and revenue.' },
    ],
    aiHuman: {
      ai: 'AI scores leads, drafts follow-ups and surfaces deals at risk before they go cold.',
      human: 'Consultants design the process and train your team — adoption is a people problem AI cannot solve alone.',
    },
    process: [
      { step: 'Map', desc: 'We document your real sales motion and where deals stall today.' },
      { step: 'Configure', desc: 'Pipelines, fields, permissions and integrations built to match.' },
      { step: 'Automate', desc: 'Routing, sequences and AI lead scoring switched on.' },
      { step: 'Train', desc: 'Hands-on enablement so the team adopts it, not avoids it.' },
    ],
    tools: ['HubSpot', 'Salesforce', 'Pipedrive', 'Zapier', 'Make', 'Clay'],
    roi: [
      { metric: '+31%', label: 'Sales-rep productivity' },
      { metric: '100%', label: 'Pipeline visibility for leadership' },
      { metric: '–50%', label: 'Time lost to manual data entry' },
    ],
    caseStudy: {
      client: 'A 12-person sales team',
      result: 'Migrated off spreadsheets to HubSpot with AI lead scoring; reps reclaimed roughly a day a week and forecast accuracy jumped.',
    },
    faq: [
      { q: 'Which CRM should we pick?', a: 'We recommend based on team size, budget and complexity — not on which vendor pays the most commission.' },
      { q: 'Can you migrate our existing data?', a: 'Yes — we clean, de-duplicate and migrate records with validation before go-live.' },
      { q: 'Will the team actually use it?', a: 'Adoption is the goal. We design around their workflow and train hands-on, then measure usage.' },
      { q: 'How is AI applied?', a: 'Lead scoring, follow-up drafting and risk alerts — surfaced to reps, never sent without review.' },
    ],
  },
  {
    id: 8,
    slug: 'erp-implementation',
    name: 'ERP Implementation',
    category: 'Business',
    icon: 'Building2',
    accent: 'var(--accent-1)',
    aiAssisted: false,
    tagline: 'Run the whole business from one source of truth.',
    teaser: 'Process mapping, ERP selection, migration and training — delivered without the horror-story timeline.',
    illustration: 'erp',
    whatWeDo: [
      { icon: 'Map', title: 'Process Mapping', desc: 'We document how work really flows before choosing any system.' },
      { icon: 'ClipboardCheck', title: 'Selection & Migration', desc: 'Vendor-neutral selection, then a phased, low-risk migration.' },
      { icon: 'GraduationCap', title: 'Training & Support', desc: 'Role-based training and post-launch support so it sticks.' },
    ],
    aiHuman: {
      ai: 'AI assists with data cleansing and reconciliation during migration to catch mismatches fast.',
      human: 'Implementation leads own change management — the human work of getting a company to adopt new systems.',
    },
    process: [
      { step: 'Assess', desc: 'Map current processes, pain points and integration needs.' },
      { step: 'Select', desc: 'Shortlist and choose the ERP that fits — no vendor bias.' },
      { step: 'Migrate', desc: 'Phased data migration with validation at each gate.' },
      { step: 'Train', desc: 'Role-based enablement and documentation.' },
      { step: 'Support', desc: 'Hypercare after go-live, then steady-state support.' },
    ],
    tools: ['NetSuite', 'Odoo', 'SAP B1', 'Zoho', 'Microsoft Dynamics'],
    roi: [
      { metric: '–35%', label: 'Manual reconciliation effort' },
      { metric: '1', label: 'Source of truth across teams' },
      { metric: 'Phased', label: 'Rollout to de-risk go-live' },
    ],
    caseStudy: {
      client: 'A growing manufacturer',
      result: 'Replaced five disconnected tools with one ERP in a phased rollout; month-end close went from nine days to three.',
    },
    faq: [
      { q: 'How long does implementation take?', a: 'Typically 8–16 weeks depending on scope. We phase rollouts to avoid a risky big-bang launch.' },
      { q: 'Are you tied to one ERP vendor?', a: 'No. We are vendor-neutral and recommend what fits your processes and budget.' },
      { q: 'What about the data mess we have now?', a: 'Cleansing and reconciliation are built into migration — we validate at every gate.' },
      { q: 'Do you train our staff?', a: 'Yes, role-based training plus documentation and post-launch hypercare.' },
    ],
  },
  {
    id: 9,
    slug: 'ecommerce-setup',
    name: 'E-Commerce Setup',
    category: 'Business',
    icon: 'ShoppingCart',
    accent: 'var(--accent-2)',
    aiAssisted: true,
    tagline: 'From idea to "add to cart" in weeks.',
    teaser: 'Shopify, WooCommerce or custom storefronts with catalog, payments and a checkout built to convert.',
    illustration: 'store',
    whatWeDo: [
      { icon: 'Store', title: 'Storefront Build', desc: 'Fast, branded Shopify/Woo or custom stores ready to sell.' },
      { icon: 'PackageOpen', title: 'Catalog & Payments', desc: 'Product setup, variants, taxes and payment gateways configured.' },
      { icon: 'MousePointerClick', title: 'Conversion UX', desc: 'Checkout and PDP optimisation to lift conversion from launch.' },
    ],
    aiHuman: {
      ai: 'AI generates product descriptions and tags at scale and suggests pricing and merchandising tweaks.',
      human: 'Designers and CRO specialists shape the store experience and the trust signals that close the sale.',
    },
    process: [
      { step: 'Plan', desc: 'Platform choice, catalog structure and payment/shipping setup.' },
      { step: 'Build', desc: 'Theme, product import and integrations configured.' },
      { step: 'Optimize', desc: 'Checkout, PDP and speed tuned for conversion.' },
      { step: 'Launch', desc: 'Analytics, tracking and a go-live checklist completed.' },
    ],
    tools: ['Shopify', 'WooCommerce', 'Stripe', 'Klaviyo', 'Meta Pixel', 'GA4'],
    roi: [
      { metric: '2–3 wk', label: 'From kickoff to live store' },
      { metric: '+22%', label: 'Checkout completion vs default themes' },
      { metric: '100%', label: 'Tracking wired in at launch' },
    ],
    caseStudy: {
      client: 'A handmade-goods founder',
      result: 'Launched a Shopify store in 18 days with AI-written catalog copy; first-month conversion beat the industry median.',
    },
    faq: [
      { q: 'Shopify or WooCommerce?', a: 'Depends on your catalog, budget and team. We recommend honestly and can build custom when neither fits.' },
      { q: 'Can you migrate my existing store?', a: 'Yes — products, customers and orders migrated with redirects to protect SEO.' },
      { q: 'Do you set up payments and tax?', a: 'We configure gateways, taxes and shipping so you can sell on day one.' },
      { q: 'Where is AI used?', a: 'Bulk product copy, tagging and merchandising suggestions — reviewed before publish.' },
    ],
  },
  {
    id: 10,
    slug: 'ecommerce-management',
    name: 'E-Commerce Management',
    category: 'Business',
    icon: 'TrendingUp',
    accent: 'var(--accent-2)',
    aiAssisted: true,
    tagline: 'Your store, run like a growth team owns it.',
    teaser: 'Inventory, orders, ads and analytics managed end-to-end so you grow revenue instead of fighting fires.',
    illustration: 'growth',
    whatWeDo: [
      { icon: 'Boxes', title: 'Inventory & Orders', desc: 'Stock, fulfilment and returns kept clean and on time.' },
      { icon: 'Megaphone', title: 'Ads & Retention', desc: 'Paid acquisition plus email/SMS flows that bring buyers back.' },
      { icon: 'BarChart4', title: 'Analytics & Growth', desc: 'Weekly reporting and experiments that move the metrics that matter.' },
    ],
    aiHuman: {
      ai: 'AI forecasts demand, flags stockouts, and auto-segments customers for targeted campaigns.',
      human: 'Managers own merchandising, supplier relationships and the judgement calls behind every promotion.',
    },
    process: [
      { step: 'Audit', desc: 'Baseline revenue, margins, inventory health and channel mix.' },
      { step: 'Stabilise', desc: 'Fix leaks: stockouts, broken flows, wasted ad spend.' },
      { step: 'Grow', desc: 'Scale winning channels and launch retention programs.' },
      { step: 'Report', desc: 'Weekly numbers and a clear plan for the next sprint.' },
    ],
    tools: ['Shopify', 'Klaviyo', 'Meta Ads', 'Google Ads', 'Triple Whale', 'Gorgias'],
    roi: [
      { metric: '+28%', label: 'Repeat-purchase rate' },
      { metric: '–18%', label: 'Stockout-driven lost sales' },
      { metric: '3.0x+', label: 'Blended return on ad spend' },
    ],
    caseStudy: {
      client: 'A scaling DTC brand',
      result: 'Took over operations and ads; demand forecasting cut stockouts 18% while retention flows added a quarter to repeat revenue.',
    },
    faq: [
      { q: 'Do you handle fulfilment?', a: 'We manage the systems and 3PL coordination; physical fulfilment stays with your logistics partner.' },
      { q: 'Is this a fixed retainer?', a: 'Usually a monthly retainer scoped to your store size, with clear deliverables and reporting.' },
      { q: 'Can you work with our team?', a: 'Yes — we plug into your team or run it fully, whatever you need.' },
      { q: 'How does AI help operations?', a: 'Demand forecasting, stockout alerts and customer segmentation — humans approve every action.' },
    ],
  },
  {
    id: 11,
    slug: 'recruitment-talent',
    name: 'Recruitment & Talent Acquisition',
    category: 'Business',
    icon: 'UserSearch',
    accent: 'var(--accent-1)',
    aiAssisted: true,
    tagline: 'Hire the right person before your competitor does.',
    teaser: 'JD writing, sourcing, screening, ATS management and employer branding to fill roles faster, with better fit.',
    illustration: 'hire',
    whatWeDo: [
      { icon: 'FileText', title: 'JD & Sourcing', desc: 'Sharp job descriptions and proactive sourcing of passive talent.' },
      { icon: 'Filter', title: 'Screening & ATS', desc: 'Structured screening and a clean, well-run applicant pipeline.' },
      { icon: 'BadgeCheck', title: 'Employer Branding', desc: 'A careers story that makes good candidates want to apply.' },
    ],
    aiHuman: {
      ai: 'AI parses and ranks applications and drafts outreach, clearing the top-of-funnel grind.',
      human: 'Recruiters assess fit, culture and motivation — and treat every candidate like a person, not a row.',
    },
    process: [
      { step: 'Define', desc: 'Nail the role, must-haves and what great looks like.' },
      { step: 'Source', desc: 'Active and passive sourcing across the right channels.' },
      { step: 'Screen', desc: 'Structured, bias-aware screening and shortlisting.' },
      { step: 'Close', desc: 'Coordinate interviews, references and a strong offer.' },
    ],
    tools: ['LinkedIn Recruiter', 'Greenhouse', 'Lever', 'Ashby', 'Gem'],
    roi: [
      { metric: '–40%', label: 'Time-to-hire on key roles' },
      { metric: '3:1', label: 'Strong shortlist ratio' },
      { metric: '90%+', label: 'Offer-acceptance on closed roles' },
    ],
    caseStudy: {
      client: 'A Series A startup',
      result: 'Filled four engineering roles in six weeks with AI-assisted sourcing and structured screening, well ahead of their plan.',
    },
    faq: [
      { q: 'Is AI screening fair?', a: 'AI assists ranking and outreach only; humans make every shortlist and hiring decision with bias-aware criteria.' },
      { q: 'Do you work on contingency or retainer?', a: 'Both models are available — we will recommend the right fit for your role volume.' },
      { q: 'Can you manage our ATS?', a: 'Yes — we run your pipeline end-to-end or support your in-house team.' },
      { q: 'What roles do you cover?', a: 'Tech, creative, ops and leadership across startup and SME stages.' },
    ],
  },
  {
    id: 12,
    slug: 'background-verification',
    name: 'Background Verification',
    category: 'Business',
    icon: 'ShieldCheck',
    accent: 'var(--accent-3)',
    aiAssisted: true,
    tagline: 'Hire with confidence — and a clean audit trail.',
    teaser: 'Education, employment, criminal and reference checks plus digital identity verification, done compliantly.',
    illustration: 'shield',
    whatWeDo: [
      { icon: 'School', title: 'Education & Employment', desc: 'Verify credentials and history with documented evidence.' },
      { icon: 'Scale', title: 'Criminal & Reference', desc: 'Compliant criminal screening and structured reference checks.' },
      { icon: 'Fingerprint', title: 'Digital Identity', desc: 'Identity and document verification to stop fraud at the gate.' },
    ],
    aiHuman: {
      ai: 'AI extracts and cross-checks document data and flags inconsistencies for review.',
      human: 'Verification specialists handle judgement, compliance and adverse-action handling with care.',
    },
    process: [
      { step: 'Consent', desc: 'Candidate consent and scope agreed before any check begins.' },
      { step: 'Verify', desc: 'Run the agreed checks against authoritative sources.' },
      { step: 'Review', desc: 'Specialists assess flags and confirm findings.' },
      { step: 'Report', desc: 'A clear, defensible report with full audit trail.' },
    ],
    tools: ['Checkr', 'Onfido', 'Persona', 'Secure Portal', 'Audit Log'],
    roi: [
      { metric: '24–72h', label: 'Typical turnaround per check' },
      { metric: '100%', label: 'Consent-based & auditable' },
      { metric: '↓', label: 'Bad-hire and fraud risk' },
    ],
    caseStudy: {
      client: 'A fintech scaling fast',
      result: 'Standardised verification across all hires with a consent-first, fully auditable process that satisfied their compliance review.',
    },
    faq: [
      { q: 'Is this compliant with privacy law?', a: 'Yes — checks are consent-based and handled per applicable data-protection and fair-hiring rules in your region.' },
      { q: 'How fast are results?', a: 'Most checks complete in 24–72 hours; some criminal records depend on jurisdiction.' },
      { q: 'Is candidate data secure?', a: 'Data is encrypted, access-controlled and retained only as long as legally required.' },
      { q: 'How is AI used?', a: 'Document extraction and inconsistency flagging — a human reviews and signs off every report.' },
    ],
  },
  {
    id: 13,
    slug: 'workflow-automation',
    name: 'Workflow Automation',
    category: 'Tech',
    icon: 'Workflow',
    accent: 'var(--accent-2)',
    aiAssisted: true,
    tagline: 'Delete the busywork. Keep the people.',
    teaser: 'Zapier, Make and n8n pipelines plus RPA that move manual, repetitive work to reliable automation.',
    illustration: 'automation',
    whatWeDo: [
      { icon: 'Repeat', title: 'Process Mapping', desc: 'Find the repetitive tasks worth automating — and the ones not to.' },
      { icon: 'Plug', title: 'Pipeline Builds', desc: 'Connect your tools with robust, monitored automations.' },
      { icon: 'Bot', title: 'RPA & AI Steps', desc: 'Bots and AI steps for tasks rules alone cannot handle.' },
    ],
    aiHuman: {
      ai: 'AI handles the fuzzy steps — classifying, extracting and summarising — inside otherwise rule-based flows.',
      human: 'Automation engineers design for reliability and failure: the error handling that keeps automation trustworthy.',
    },
    process: [
      { step: 'Map', desc: 'Document the manual process and quantify the time it costs.' },
      { step: 'Design', desc: 'Plan the automation, triggers and failure handling.' },
      { step: 'Build', desc: 'Implement and test pipelines against real data.' },
      { step: 'Monitor', desc: 'Alerts and logging so failures surface, not hide.' },
    ],
    tools: ['Zapier', 'Make', 'n8n', 'Airtable', 'Python', 'OpenAI'],
    roi: [
      { metric: '15+ hrs', label: 'Saved per week, typical' },
      { metric: '–90%', label: 'Manual data re-entry' },
      { metric: '<1%', label: 'Error rate with monitoring' },
    ],
    caseStudy: {
      client: 'An ops-heavy agency',
      result: 'Automated client onboarding across six tools; what took a coordinator two hours per client now runs in minutes, hands-free.',
    },
    faq: [
      { q: 'What if an automation breaks?', a: 'We build monitoring and alerts in from the start, with clear fallbacks so nothing fails silently.' },
      { q: 'Which platform do you use?', a: 'Whatever fits — Zapier for speed, Make/n8n for complex logic, custom code when needed.' },
      { q: 'Can automations use AI?', a: 'Yes — AI handles the steps rules cannot, like reading messy inputs or drafting replies.' },
      { q: 'Will it replace my team?', a: 'It removes their busywork so they do higher-value work — augmentation, not replacement.' },
    ],
  },
  {
    id: 14,
    slug: 'startup-consulting',
    name: 'Business & Startup Consulting',
    category: 'Business',
    icon: 'Lightbulb',
    accent: 'var(--accent-3)',
    aiAssisted: false,
    tagline: 'Strategy you can actually execute on Monday.',
    teaser: 'Go-to-market, investor readiness, unit economics and OKR frameworks — advisory that gets specific.',
    illustration: 'strategy',
    whatWeDo: [
      { icon: 'Rocket', title: 'Go-To-Market', desc: 'Positioning, ICP and a channel plan to win your first/next 100 customers.' },
      { icon: 'PiggyBank', title: 'Investor Readiness', desc: 'Model, deck and metrics that survive due diligence.' },
      { icon: 'Compass', title: 'Unit Economics & OKRs', desc: 'Know your numbers and align the team behind clear goals.' },
    ],
    aiHuman: {
      ai: 'AI accelerates market research and scenario modelling so we test more options, faster.',
      human: 'Operators who have done it advise on the judgement calls — strategy is experience, not output.',
    },
    process: [
      { step: 'Diagnose', desc: 'Where you are, what is working, and the real constraint on growth.' },
      { step: 'Strategize', desc: 'A focused plan with priorities, not a 60-page report.' },
      { step: 'Model', desc: 'Unit economics and scenarios you can defend.' },
      { step: 'Execute', desc: 'OKRs and a cadence so the plan actually happens.' },
    ],
    tools: ['Notion', 'Causal', 'Pitch', 'Excel', 'Market Maps'],
    roi: [
      { metric: 'Clear', label: 'ICP and go-to-market focus' },
      { metric: 'DD-ready', label: 'Model and metrics for raises' },
      { metric: 'Aligned', label: 'Team on shared OKRs' },
    ],
    caseStudy: {
      client: 'A pre-Series-A founder',
      result: 'Reworked positioning and the financial model ahead of a raise; the sharper story and clean unit economics shortened diligence.',
    },
    faq: [
      { q: 'Is this just a report?', a: 'No. We deliver a focused plan plus the OKRs and cadence to execute it — and can stay on to help.' },
      { q: 'Do you help with fundraising?', a: 'We get you investor-ready: deck, model and metrics. We do not broker the raise itself.' },
      { q: 'How are engagements structured?', a: 'Project-based sprints or ongoing advisory retainers, depending on your stage.' },
      { q: 'Why no AI badge here?', a: 'We use AI for research, but strategic judgement is fully human — so we do not overstate the role of AI.' },
    ],
  },
  {
    id: 15,
    slug: 'data-services',
    name: 'Data Services',
    category: 'Data',
    icon: 'DatabaseZap',
    accent: 'var(--accent-2)',
    aiAssisted: true,
    tagline: 'Turn data you are hoarding into decisions you can make.',
    teaser: 'Migration, management, analysis and BI dashboards in Power BI, Tableau or custom React — with governance built in.',
    illustration: 'data',
    whatWeDo: [
      { icon: 'ArrowLeftRight', title: 'Migration & Management', desc: 'Move and structure data cleanly across systems.' },
      { icon: 'PieChart', title: 'Analysis & BI', desc: 'Dashboards in Power BI, Tableau or custom React.' },
      { icon: 'Lock', title: 'Data Governance', desc: 'Quality, access and lineage so numbers are trusted.' },
    ],
    aiHuman: {
      ai: 'AI accelerates cleaning, anomaly detection and first-pass analysis across large datasets.',
      human: 'Analysts frame the questions and interpret results — context turns data into a decision.',
    },
    process: [
      { step: 'Inventory', desc: 'Find your data, its quality and where it lives.' },
      { step: 'Model', desc: 'Clean, structure and define a single source of truth.' },
      { step: 'Visualise', desc: 'Build dashboards around the decisions you make.' },
      { step: 'Govern', desc: 'Access, quality checks and lineage to keep trust.' },
    ],
    tools: ['Power BI', 'Tableau', 'dbt', 'BigQuery', 'Snowflake', 'React', 'Python'],
    roi: [
      { metric: '1', label: 'Trusted source of truth' },
      { metric: '–60%', label: 'Time spent building reports' },
      { metric: 'Real-time', label: 'Dashboards for decisions' },
    ],
    caseStudy: {
      client: 'A multi-region retailer',
      result: 'Consolidated scattered data into one warehouse with governed BI dashboards; leadership stopped arguing over whose numbers were right.',
    },
    faq: [
      { q: 'Power BI, Tableau or custom?', a: 'We recommend by team, budget and need — and build custom React dashboards when off-the-shelf falls short.' },
      { q: 'Can you fix our messy data?', a: 'Yes — cleaning, de-duplication and governance are core to every engagement.' },
      { q: 'Who owns the warehouse?', a: 'You do, in your own cloud. We build, document and hand over.' },
      { q: 'Where does AI help?', a: 'Cleaning, anomaly detection and first-pass analysis — analysts validate every insight.' },
    ],
  },
];

/** Lookup a single service by its URL slug. */
export const getServiceBySlug = (slug) => services.find((s) => s.slug === slug);

/** Filter services by category label ("All" returns everything). */
export const getServicesByCategory = (cat) =>
  cat === 'All' ? services : services.filter((s) => s.category === cat);

export default services;
CORTINIX_EOF
echo "  • src/main.jsx"
cat > "$ROOT/src/main.jsx" << 'CORTINIX_EOF'
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';

// Stylesheets — order matters: tokens → keyframes → base → components → pages
import './styles/variables.css';
import './styles/animations.css';
import './styles/globals.css';
import './styles/components.css';
import './styles/pages.css';

import App from './App.jsx';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </StrictMode>
);
CORTINIX_EOF
echo "  • src/pages/About.jsx"
cat > "$ROOT/src/pages/About.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/pages/Blog.jsx"
cat > "$ROOT/src/pages/Blog.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/pages/Contact.jsx"
cat > "$ROOT/src/pages/Contact.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/pages/Home.jsx"
cat > "$ROOT/src/pages/Home.jsx" << 'CORTINIX_EOF'
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
      'Cortinix replaced four vendors with one team. We shipped our rebrand, new site and paid engine in six weeks — and our CAC dropped a third.',
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
            One accountable team, one system — scroll through how a Cortinix engagement unfolds.
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
CORTINIX_EOF
echo "  • src/pages/Services/ServiceDetail.jsx"
cat > "$ROOT/src/pages/Services/ServiceDetail.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/pages/Services/index.jsx"
cat > "$ROOT/src/pages/Services/index.jsx" << 'CORTINIX_EOF'
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
CORTINIX_EOF
echo "  • src/styles/animations.css"
cat > "$ROOT/src/styles/animations.css" << 'CORTINIX_EOF'
/* ============================================================
   Cortinix — Animations
   Keyframes + micro-interaction styles. All motion respects
   prefers-reduced-motion at the bottom of this file.
   ============================================================ */

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes rotate-slow {
  to {
    transform: rotate(360deg);
  }
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-12px);
  }
}

@keyframes pulse-glow {
  0%,
  100% {
    box-shadow: 0 0 0 0 rgba(108, 99, 255, 0.5);
  }
  50% {
    box-shadow: 0 0 36px 6px rgba(108, 99, 255, 0.35);
  }
}

@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

@keyframes gradient-pan {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

@keyframes marquee {
  from {
    transform: translateX(0);
  }
  to {
    transform: translateX(-50%);
  }
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes border-rotate {
  to {
    --angle: 360deg;
  }
}

/* ── Glow / magnetic button ────────────────────────────── */
.glow-btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  gap: 0.55rem;
  padding: 0.85rem 1.5rem;
  border-radius: var(--radius-pill);
  font-family: var(--font-display);
  font-weight: 600;
  font-size: var(--fs-base);
  letter-spacing: -0.01em;
  color: #fff;
  background: var(--gradient-brand);
  background-size: 180% 180%;
  transition: transform var(--dur) var(--ease-out), box-shadow var(--dur) var(--ease-out);
  will-change: transform;
  isolation: isolate;
}
.glow-btn::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: var(--gradient-brand);
  filter: blur(18px);
  opacity: 0;
  z-index: -1;
  transition: opacity var(--dur) var(--ease-out);
}
.glow-btn:hover {
  transform: translateY(-2px);
  animation: gradient-pan 3s ease infinite;
}
.glow-btn:hover::after {
  opacity: 0.6;
}
.glow-btn.ghost {
  background: transparent;
  color: var(--text-primary);
  border: 1px solid var(--border);
}
.glow-btn.ghost::after {
  display: none;
}
.glow-btn.ghost:hover {
  border-color: var(--accent-1);
  background: var(--accent-1-soft);
  animation: none;
}
.glow-btn .icon {
  transition: transform var(--dur) var(--ease-out);
}
.glow-btn:hover .icon {
  transform: translateX(3px);
}

/* ── Animated conic gradient border (featured cards) ───── */
@property --angle {
  syntax: '<angle>';
  initial-value: 0deg;
  inherits: false;
}
.gradient-border {
  position: relative;
  border-radius: var(--radius);
}
.gradient-border::before {
  content: '';
  position: absolute;
  inset: 0;
  padding: 1px;
  border-radius: inherit;
  background: conic-gradient(
    from var(--angle),
    var(--accent-1),
    var(--accent-2),
    var(--accent-3),
    var(--accent-1)
  );
  -webkit-mask:
    linear-gradient(#000 0 0) content-box,
    linear-gradient(#000 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  animation: border-rotate 6s linear infinite;
  pointer-events: none;
}

/* ── 3D tilt card ──────────────────────────────────────── */
.tilt-card {
  transform-style: preserve-3d;
  transition: transform var(--dur) var(--ease-out), box-shadow var(--dur) var(--ease-out);
  will-change: transform;
}
.tilt-card .tilt-inner {
  transform: translateZ(40px);
}

/* ── Scroll reveal base (JS toggles .is-visible) ───────── */
.reveal {
  opacity: 0;
  transform: translateY(28px);
  transition:
    opacity var(--dur-slow) var(--ease-out),
    transform var(--dur-slow) var(--ease-out);
}
.reveal.is-visible {
  opacity: 1;
  transform: none;
}
.reveal[data-delay='1'] {
  transition-delay: 0.1s;
}
.reveal[data-delay='2'] {
  transition-delay: 0.2s;
}
.reveal[data-delay='3'] {
  transition-delay: 0.3s;
}
.reveal[data-delay='4'] {
  transition-delay: 0.4s;
}

/* ── Staggered letter / word reveal (hero headings) ────── */
.split-word {
  display: inline-block;
  overflow: hidden;
  vertical-align: top;
}
.split-word > span {
  display: inline-block;
  transform: translateY(110%);
  animation: word-rise 0.9s var(--ease-out) forwards;
}
@keyframes word-rise {
  to {
    transform: translateY(0);
  }
}

/* ── Custom glow cursor ────────────────────────────────── */
.cursor-dot,
.cursor-ring {
  position: fixed;
  top: 0;
  left: 0;
  pointer-events: none;
  z-index: 9998;
  border-radius: 50%;
  mix-blend-mode: screen;
  opacity: 1;
  transition: opacity 0.2s var(--ease-out);
}
/* Hidden when the pointer leaves the window or the tab loses focus. */
.cursor-dot.is-hidden,
.cursor-ring.is-hidden {
  opacity: 0;
}
.cursor-dot {
  width: 7px;
  height: 7px;
  background: var(--accent-2);
  transform: translate(-50%, -50%);
}
.cursor-ring {
  width: 34px;
  height: 34px;
  border: 1.5px solid var(--accent-1);
  transform: translate(-50%, -50%);
  transition: width 0.25s var(--ease-out), height 0.25s var(--ease-out),
    border-color 0.25s var(--ease-out), background 0.25s var(--ease-out),
    opacity 0.2s var(--ease-out);
}
.cursor-ring.is-hover {
  width: 58px;
  height: 58px;
  border-color: var(--accent-2);
  background: var(--accent-2-soft);
}

/* hide native cursor only on pointer-fine devices that have the trail */
body.has-cursor-trail {
  cursor: none;
}
body.has-cursor-trail a,
body.has-cursor-trail button {
  cursor: none;
}

/* Safety net: never show the custom cursor on touch / coarse-pointer
   devices, even if scripting leaves the nodes mounted. */
@media (hover: none), (pointer: coarse) {
  .cursor-dot,
  .cursor-ring {
    display: none !important;
  }
}

/* ── Pulsing dot for live indicators ───────────────────── */
.pulse-dot {
  position: relative;
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: var(--accent-2);
}
.pulse-dot::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: var(--accent-2);
  animation: ping 1.8s var(--ease-out) infinite;
}
@keyframes ping {
  0% {
    transform: scale(1);
    opacity: 0.7;
  }
  100% {
    transform: scale(3.2);
    opacity: 0;
  }
}

/* ── Marquee / ticker ──────────────────────────────────── */
.marquee {
  overflow: hidden;
  -webkit-mask: linear-gradient(90deg, transparent, #000 8%, #000 92%, transparent);
  mask: linear-gradient(90deg, transparent, #000 8%, #000 92%, transparent);
}
.marquee-track {
  display: flex;
  gap: 1.4rem;
  width: max-content;
  animation: marquee 28s linear infinite;
}
.marquee:hover .marquee-track {
  animation-play-state: paused;
}

/* ── Shimmer skeleton ──────────────────────────────────── */
.shimmer {
  background: linear-gradient(
    90deg,
    var(--bg-secondary) 25%,
    var(--bg-tertiary) 50%,
    var(--bg-secondary) 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s linear infinite;
}

/* ============================================================
   Reduced motion: switch everything off gracefully.
   ============================================================ */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.001ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.001ms !important;
    scroll-behavior: auto !important;
  }
  .reveal {
    opacity: 1;
    transform: none;
  }
  .split-word > span {
    transform: none;
  }
  .marquee-track {
    animation: none;
  }
  .cursor-dot,
  .cursor-ring {
    display: none;
  }
  body.has-cursor-trail,
  body.has-cursor-trail a,
  body.has-cursor-trail button {
    cursor: auto;
  }
}
CORTINIX_EOF
echo "  • src/styles/components.css"
cat > "$ROOT/src/styles/components.css" << 'CORTINIX_EOF'
/* ============================================================
   Cortinix — Component styles
   Navbar, hero particle field, service cards.
   ============================================================ */

/* ── Navbar ────────────────────────────────────────────── */
.navbar {
  position: fixed;
  inset: 0 0 auto 0;
  z-index: 900;
  height: var(--nav-h);
  display: flex;
  align-items: center;
  transition: background var(--dur) var(--ease-out), border-color var(--dur) var(--ease-out),
    backdrop-filter var(--dur) var(--ease-out);
  border-bottom: 1px solid transparent;
}
.navbar.is-scrolled {
  background: color-mix(in srgb, var(--bg-primary) 78%, transparent);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-bottom-color: var(--border-soft);
}
.navbar-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  gap: 1.5rem;
}
.navbar-logo {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  font-family: var(--font-display);
  font-weight: 800;
  font-size: 1.3rem;
}
.logo-mark {
  width: 34px;
  height: 34px;
  display: grid;
  place-items: center;
  border-radius: 9px;
  background: var(--gradient-brand);
  color: #fff;
  font-size: 1.1rem;
  box-shadow: var(--glow-violet);
}
.navbar-links {
  display: flex;
  gap: 0.4rem;
  margin-inline: auto;
}
.nav-link {
  position: relative;
  padding: 0.5rem 0.9rem;
  font-size: var(--fs-sm);
  font-weight: 500;
  color: var(--text-secondary);
  border-radius: var(--radius-pill);
  transition: color var(--dur-fast) var(--ease-out), background var(--dur-fast) var(--ease-out);
}
.nav-link:hover {
  color: var(--text-primary);
}
.nav-link.active {
  color: var(--text-primary);
  background: var(--bg-glass);
}
.nav-link.active::after {
  content: '';
  position: absolute;
  left: 50%;
  bottom: 2px;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--accent-2);
  transform: translateX(-50%);
}
.navbar-actions {
  display: flex;
  align-items: center;
  gap: 0.8rem;
}
.navbar-burger {
  display: none;
  color: var(--text-primary);
}

/* Mobile menu */
.mobile-menu {
  position: fixed;
  inset: var(--nav-h) 0 0 0;
  background: var(--bg-primary);
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 0.5rem;
  padding: 2rem;
  transform: translateY(-12px);
  opacity: 0;
  pointer-events: none;
  transition: opacity var(--dur) var(--ease-out), transform var(--dur) var(--ease-out);
  z-index: 880;
}
.mobile-menu.is-open {
  opacity: 1;
  transform: none;
  pointer-events: auto;
}
.mobile-link {
  font-family: var(--font-display);
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-secondary);
  padding: 0.6rem 0;
}
.mobile-link.active {
  color: var(--accent-1);
}
.mobile-cta {
  margin-top: 1.5rem;
  align-self: flex-start;
}

@media (max-width: 920px) {
  .navbar-links,
  .navbar-cta-desktop {
    display: none;
  }
  .navbar-burger {
    display: grid;
    place-items: center;
  }
}

/* ── Particle field (hero background) ──────────────────── */
.particle-field {
  position: absolute;
  inset: 0;
  z-index: 0;
}
.particle-field canvas {
  width: 100% !important;
  height: 100% !important;
}

/* ── Service card ──────────────────────────────────────── */
.service-card {
  position: relative;
  display: block;
  background: var(--bg-secondary);
  border: 1px solid var(--border-soft);
  border-radius: var(--radius);
  padding: 1px;
  overflow: hidden;
  box-shadow: var(--shadow-card);
  transition: transform var(--dur) var(--ease-out), border-color var(--dur) var(--ease-out);
}
.service-card:hover {
  border-color: var(--border);
}
.service-card-inner {
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.85rem;
  padding: 1.6rem;
}
.service-card-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.6rem;
}
.service-icon {
  width: 52px;
  height: 52px;
  display: grid;
  place-items: center;
  border-radius: 13px;
  color: var(--card-accent, var(--accent-1));
  background: color-mix(in srgb, var(--card-accent, var(--accent-1)) 14%, transparent);
  border: 1px solid color-mix(in srgb, var(--card-accent, var(--accent-1)) 30%, transparent);
}
.service-card-name {
  font-size: var(--fs-h3);
}
.service-card-teaser {
  color: var(--text-muted);
  font-size: var(--fs-sm);
  line-height: 1.55;
  flex: 1;
}
.service-card-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 0.4rem;
  padding-top: 0.9rem;
  border-top: 1px solid var(--border-soft);
}
.service-card-cat {
  font-size: var(--fs-xs);
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text-muted);
}
.service-card-go {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: var(--fs-sm);
  font-weight: 600;
  color: var(--card-accent, var(--accent-1));
  transition: gap var(--dur) var(--ease-out);
}
.service-card:hover .service-card-go {
  gap: 0.7rem;
}
CORTINIX_EOF
echo "  • src/styles/globals.css"
cat > "$ROOT/src/styles/globals.css" << 'CORTINIX_EOF'
/* ============================================================
   Cortinix — Global styles
   Reset, base type, layout primitives, shared UI utilities.
   ============================================================ */

*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html {
  scroll-behavior: smooth;
  -webkit-text-size-adjust: 100%;
}

@media (prefers-reduced-motion: reduce) {
  html {
    scroll-behavior: auto;
  }
}

body {
  font-family: var(--font-body);
  background: var(--bg-primary);
  color: var(--text-primary);
  font-size: var(--fs-base);
  line-height: 1.65;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  overflow-x: hidden;
  transition: background var(--dur) var(--ease-out), color var(--dur) var(--ease-out);
}

/* Ambient background glow that sits behind everything */
body::before {
  content: '';
  position: fixed;
  inset: 0;
  z-index: -1;
  background:
    radial-gradient(60% 50% at 12% 0%, rgba(108, 99, 255, 0.16), transparent 70%),
    radial-gradient(45% 45% at 90% 8%, rgba(0, 212, 170, 0.1), transparent 70%);
  pointer-events: none;
}

img,
svg,
canvas {
  display: block;
  max-width: 100%;
}

a {
  color: inherit;
  text-decoration: none;
}

button {
  font: inherit;
  color: inherit;
  cursor: pointer;
  border: none;
  background: none;
}

ul,
ol {
  list-style: none;
}

h1,
h2,
h3,
h4,
h5 {
  font-family: var(--font-display);
  font-weight: 700;
  line-height: 1.08;
  letter-spacing: -0.02em;
}

input,
textarea,
select {
  font: inherit;
  color: inherit;
}

::selection {
  background: var(--accent-1);
  color: #fff;
}

/* ── Accessibility helpers ─────────────────────────────── */
.skip-link {
  position: absolute;
  left: -9999px;
  top: 0;
  z-index: 9999;
  background: var(--accent-1);
  color: #fff;
  padding: 0.7rem 1.2rem;
  border-radius: 0 0 var(--radius-sm) 0;
  font-weight: 600;
}
.skip-link:focus {
  left: 0;
}

:focus-visible {
  outline: 2px solid var(--accent-2);
  outline-offset: 3px;
  border-radius: 4px;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* ── Layout primitives ─────────────────────────────────── */
.container {
  width: 100%;
  max-width: var(--maxw);
  margin-inline: auto;
  padding-inline: clamp(1.1rem, 4vw, 2.5rem);
}

.section {
  padding-block: var(--space-section);
  position: relative;
}

.eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-family: var(--font-mono);
  font-size: var(--fs-xs);
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--accent-2);
  padding: 0.35rem 0.85rem;
  border: 1px solid var(--border);
  border-radius: var(--radius-pill);
  background: var(--accent-2-soft);
}

.section-title {
  font-size: var(--fs-h2);
  margin-block: 1rem 0.9rem;
  max-width: 22ch;
}

.section-lead {
  color: var(--text-secondary);
  font-size: var(--fs-lg);
  max-width: 56ch;
}

.text-gradient {
  background: var(--gradient-text);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.text-muted {
  color: var(--text-muted);
}

.mono {
  font-family: var(--font-mono);
}

/* ── Glass card ────────────────────────────────────────── */
.glass {
  background: var(--bg-glass);
  border: 1px solid var(--border-soft);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border-radius: var(--radius);
}

/* ── Badges / pills ────────────────────────────────────── */
.badge {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-family: var(--font-mono);
  font-size: var(--fs-xs);
  padding: 0.32rem 0.7rem;
  border-radius: var(--radius-pill);
  border: 1px solid var(--border-soft);
  color: var(--text-secondary);
  background: var(--bg-glass);
}

.badge-ai {
  color: var(--accent-2);
  border-color: var(--border);
  background: var(--accent-2-soft);
}

/* ── Grid helpers ──────────────────────────────────────── */
.grid {
  display: grid;
  gap: clamp(1rem, 2.5vw, 1.8rem);
}
.grid-3 {
  grid-template-columns: repeat(3, 1fr);
}
.grid-2 {
  grid-template-columns: repeat(2, 1fr);
}

@media (max-width: 900px) {
  .grid-3 {
    grid-template-columns: 1fr;
  }
  .grid-2 {
    grid-template-columns: 1fr;
  }
}

/* ── Scroll progress bar (top of viewport) ─────────────── */
.scroll-progress {
  position: fixed;
  top: 0;
  left: 0;
  height: 3px;
  width: 100%;
  transform-origin: 0 50%;
  background: var(--gradient-brand);
  z-index: 1000;
  box-shadow: var(--glow-violet);
}

/* ── Page wrapper (keeps footer at bottom) ─────────────── */
.app-shell {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.app-main {
  flex: 1;
}

/* ── Suspense fallback ─────────────────────────────────── */
.route-loader {
  min-height: 70vh;
  display: grid;
  place-items: center;
  gap: 1rem;
}
.route-loader .spinner {
  width: 46px;
  height: 46px;
  border-radius: 50%;
  border: 3px solid var(--border-soft);
  border-top-color: var(--accent-1);
  animation: spin 0.9s linear infinite;
}
.route-loader p {
  font-family: var(--font-mono);
  color: var(--text-muted);
  font-size: var(--fs-sm);
  letter-spacing: 0.1em;
}

/* ── Generic CTA banner ────────────────────────────────── */
.cta-banner {
  position: relative;
  overflow: hidden;
  border-radius: var(--radius-lg);
  padding: clamp(2.5rem, 6vw, 4.5rem);
  text-align: center;
  background: var(--bg-secondary);
  border: 1px solid var(--border);
}
.cta-banner::before {
  content: '';
  position: absolute;
  inset: -40%;
  background: conic-gradient(
    from 0deg,
    transparent 0deg,
    var(--accent-1) 90deg,
    transparent 180deg,
    var(--accent-2) 270deg,
    transparent 360deg
  );
  opacity: 0.18;
  animation: rotate-slow 12s linear infinite;
}
.cta-banner > * {
  position: relative;
  z-index: 1;
}
.cta-banner h2 {
  font-size: var(--fs-h1);
  max-width: 18ch;
  margin-inline: auto;
}
.cta-banner p {
  color: var(--text-secondary);
  margin-block: 1rem 1.8rem;
  max-width: 52ch;
  margin-inline: auto;
}
.cta-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

/* ── Two-column feature row ────────────────────────────── */
.split {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: clamp(1.5rem, 4vw, 3.5rem);
  align-items: center;
}
@media (max-width: 880px) {
  .split {
    grid-template-columns: 1fr;
  }
}

/* ── Accordion (FAQ) ───────────────────────────────────── */
.accordion-item {
  border: 1px solid var(--border-soft);
  border-radius: var(--radius);
  background: var(--bg-glass);
  margin-bottom: 0.9rem;
  overflow: hidden;
}
.accordion-trigger {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
  text-align: left;
  padding: 1.15rem 1.4rem;
  font-family: var(--font-display);
  font-weight: 600;
  font-size: var(--fs-lg);
  color: var(--text-primary);
}
.accordion-trigger .chev {
  flex-shrink: 0;
  transition: transform var(--dur) var(--ease-out);
  color: var(--accent-1);
}
.accordion-item[data-open='true'] .chev {
  transform: rotate(180deg);
}
.accordion-panel {
  padding: 0 1.4rem 1.3rem;
  color: var(--text-secondary);
}

/* ── Footer ────────────────────────────────────────────── */
.footer {
  border-top: 1px solid var(--border-soft);
  background: var(--bg-secondary);
  padding-block: 3.5rem 2rem;
  margin-top: var(--space-section);
}
.footer-grid {
  display: grid;
  grid-template-columns: 1.6fr repeat(3, 1fr);
  gap: 2.5rem;
}
.footer-brand .logo {
  font-family: var(--font-display);
  font-weight: 800;
  font-size: 1.5rem;
}
.footer-brand p {
  color: var(--text-muted);
  margin-top: 0.8rem;
  max-width: 34ch;
  font-size: var(--fs-sm);
}
.footer-col h4 {
  font-family: var(--font-mono);
  font-size: var(--fs-xs);
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--text-muted);
  margin-bottom: 1rem;
}
.footer-col a {
  display: block;
  color: var(--text-secondary);
  padding: 0.3rem 0;
  font-size: var(--fs-sm);
  transition: color var(--dur-fast) var(--ease-out);
}
.footer-col a:hover {
  color: var(--accent-2);
}
.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
  margin-top: 2.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--border-soft);
  color: var(--text-muted);
  font-size: var(--fs-sm);
}
.footer-socials {
  display: flex;
  gap: 0.6rem;
}
.footer-socials a {
  width: 38px;
  height: 38px;
  display: grid;
  place-items: center;
  border: 1px solid var(--border-soft);
  border-radius: 50%;
  transition: all var(--dur-fast) var(--ease-out);
}
.footer-socials a:hover {
  border-color: var(--accent-1);
  color: var(--accent-1);
  transform: translateY(-3px);
}
@media (max-width: 760px) {
  .footer-grid {
    grid-template-columns: 1fr 1fr;
  }
  .footer-brand {
    grid-column: 1 / -1;
  }
}

/* ── Responsive type fallback ──────────────────────────── */
@media (max-width: 520px) {
  .cta-actions {
    flex-direction: column;
  }
}
CORTINIX_EOF
echo "  • src/styles/pages.css"
cat > "$ROOT/src/styles/pages.css" << 'CORTINIX_EOF'
/* ============================================================
   Cortinix — Page styles
   Hero, Home sections, About, Services, ServiceDetail, Contact.
   ============================================================ */

/* ── HERO ──────────────────────────────────────────────── */
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  overflow: hidden;
  padding-top: var(--nav-h);
}
.hero-overlay {
  position: absolute;
  inset: 0;
  z-index: 1;
  background:
    radial-gradient(70% 60% at 50% 40%, transparent 30%, var(--bg-primary) 92%),
    linear-gradient(180deg, transparent 60%, var(--bg-primary) 100%);
  pointer-events: none;
}
.hero-content {
  position: relative;
  z-index: 2;
  max-width: 60rem;
}
.hero-title {
  font-size: var(--fs-hero);
  margin-block: 1.2rem 1.3rem;
  max-width: 18ch;
}
.hero-title .accent {
  background: var(--gradient-text);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.hero-sub {
  font-size: var(--fs-lg);
  color: var(--text-secondary);
  max-width: 48ch;
  margin-bottom: 2.2rem;
}
.hero-ctas {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}
/* ── Section heading block ─────────────────────────────── */
.section-head {
  max-width: 60rem;
  margin-bottom: 3rem;
}
.section-head.center {
  margin-inline: auto;
  text-align: center;
}
.section-head.center .section-lead {
  margin-inline: auto;
}

/* ── Problem cards ─────────────────────────────────────── */
.problem-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.4rem;
}
.problem-card {
  padding: 2rem;
  background: var(--bg-secondary);
  border: 1px solid var(--border-soft);
  border-radius: var(--radius);
}
.problem-card .p-icon {
  width: 50px;
  height: 50px;
  display: grid;
  place-items: center;
  border-radius: 12px;
  margin-bottom: 1.1rem;
  color: var(--accent-3);
  background: var(--accent-3-soft);
}
.problem-card h3 {
  font-size: var(--fs-h3);
  margin-bottom: 0.5rem;
}
.problem-card p {
  color: var(--text-muted);
  font-size: var(--fs-sm);
}
.problem-card .p-stat {
  font-family: var(--font-display);
  font-weight: 800;
  font-size: 2.4rem;
  color: var(--accent-1);
  display: block;
  margin-top: 1rem;
}
@media (max-width: 900px) {
  .problem-grid {
    grid-template-columns: 1fr;
  }
}

/* ── AI + Human model (tab toggle) ─────────────────────── */
.aihuman {
  background: var(--bg-secondary);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: clamp(1.5rem, 4vw, 3rem);
}
.aihuman-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 2rem;
}
.aihuman-tab {
  padding: 0.55rem 1.1rem;
  border-radius: var(--radius-pill);
  border: 1px solid var(--border-soft);
  color: var(--text-muted);
  font-size: var(--fs-sm);
  font-weight: 500;
  transition: all var(--dur-fast) var(--ease-out);
}
.aihuman-tab.active {
  color: var(--text-primary);
  border-color: var(--border);
  background: var(--accent-1-soft);
}
.aihuman-body {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.4rem;
}
.aihuman-side {
  padding: 1.6rem;
  border-radius: var(--radius);
  border: 1px solid var(--border-soft);
}
.aihuman-side.ai {
  background: var(--accent-2-soft);
  border-color: color-mix(in srgb, var(--accent-2) 30%, transparent);
}
.aihuman-side.human {
  background: var(--accent-1-soft);
  border-color: color-mix(in srgb, var(--accent-1) 30%, transparent);
}
.aihuman-side .label {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-family: var(--font-mono);
  font-size: var(--fs-xs);
  letter-spacing: 0.1em;
  text-transform: uppercase;
  margin-bottom: 0.8rem;
}
.aihuman-side.ai .label {
  color: var(--accent-2);
}
.aihuman-side.human .label {
  color: var(--accent-1);
}
.aihuman-side p {
  color: var(--text-secondary);
}
@media (max-width: 760px) {
  .aihuman-body {
    grid-template-columns: 1fr;
  }
}

/* ── Stats bar ─────────────────────────────────────────── */
.stats-bar {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
  text-align: center;
  border-radius: var(--radius-lg);
  border: 1px solid var(--border);
  background: var(--bg-glass);
  backdrop-filter: blur(12px);
  padding: clamp(1.5rem, 4vw, 2.6rem);
}
.stat .stat-num {
  font-family: var(--font-display);
  font-weight: 800;
  font-size: clamp(2rem, 5vw, 3rem);
  background: var(--gradient-text);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.stat .stat-label {
  display: block;
  color: var(--text-muted);
  font-size: var(--fs-sm);
  margin-top: 0.3rem;
}
@media (max-width: 760px) {
  .stats-bar {
    grid-template-columns: 1fr 1fr;
    gap: 1.6rem;
  }
}

/* ── Services grid + filters ───────────────────────────── */
.filter-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
  margin-bottom: 2.4rem;
}
.filter-chip {
  padding: 0.55rem 1.2rem;
  border-radius: var(--radius-pill);
  border: 1px solid var(--border-soft);
  color: var(--text-muted);
  font-size: var(--fs-sm);
  font-weight: 500;
  transition: all var(--dur-fast) var(--ease-out);
}
.filter-chip:hover {
  color: var(--text-primary);
}
.filter-chip.active {
  color: #fff;
  background: var(--gradient-brand);
  border-color: transparent;
}
.services-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.4rem;
}
@media (max-width: 1000px) {
  .services-grid {
    grid-template-columns: 1fr 1fr;
  }
}
@media (max-width: 680px) {
  .services-grid {
    grid-template-columns: 1fr;
  }
}

/* ── Industries ticker ─────────────────────────────────── */
.ticker-item {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.7rem 1.4rem;
  border-radius: var(--radius-pill);
  border: 1px solid var(--border-soft);
  background: var(--bg-secondary);
  font-family: var(--font-display);
  font-weight: 600;
  white-space: nowrap;
  color: var(--text-secondary);
}
.ticker-item .dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--accent-2);
}

/* ── Process (GSAP pinned horizontal) ──────────────────── */
.process-pin {
  position: relative;
  background: var(--bg-secondary);
  border-block: 1px solid var(--border-soft);
}
.process-track {
  display: flex;
  gap: 2rem;
  padding: 4rem clamp(1.1rem, 4vw, 2.5rem);
  width: max-content;
  align-items: stretch;
}
.process-step {
  width: min(80vw, 420px);
  flex-shrink: 0;
  padding: 2.2rem;
  border-radius: var(--radius-lg);
  background: var(--bg-primary);
  border: 1px solid var(--border-soft);
  display: flex;
  flex-direction: column;
}
.process-step .p-num {
  font-family: var(--font-mono);
  font-size: var(--fs-sm);
  color: var(--accent-2);
  letter-spacing: 0.2em;
}
.process-step h3 {
  font-size: var(--fs-h2);
  margin-block: 0.8rem 0.8rem;
}
.process-step p {
  color: var(--text-muted);
}
.process-step .p-index {
  margin-top: auto;
  font-family: var(--font-display);
  font-weight: 800;
  font-size: 4.5rem;
  line-height: 1;
  color: var(--bg-glass-strong);
  -webkit-text-stroke: 1px var(--border);
}
/* Fallback (no-pin / reduced motion / mobile): horizontal scroll */
.process-fallback .process-track {
  overflow-x: auto;
  width: 100%;
  scroll-snap-type: x mandatory;
}
.process-fallback .process-step {
  scroll-snap-align: start;
}

/* ── Testimonials ──────────────────────────────────────── */
.testi-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.4rem;
}
.testi-card {
  padding: 2rem;
  border-radius: var(--radius);
  background: var(--bg-secondary);
  border: 1px solid var(--border-soft);
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}
.testi-card .quote {
  color: var(--text-secondary);
  font-size: var(--fs-lg);
  line-height: 1.5;
}
.testi-stars {
  display: flex;
  gap: 0.2rem;
  color: var(--accent-2);
}
.testi-author {
  display: flex;
  align-items: center;
  gap: 0.8rem;
  margin-top: auto;
}
.testi-avatar {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  display: grid;
  place-items: center;
  font-family: var(--font-display);
  font-weight: 700;
  color: #fff;
  background: var(--gradient-brand);
}
.testi-author .name {
  font-weight: 600;
}
.testi-author .role {
  font-size: var(--fs-sm);
  color: var(--text-muted);
}
@media (max-width: 900px) {
  .testi-grid {
    grid-template-columns: 1fr;
  }
}

/* ── ABOUT page ────────────────────────────────────────── */
.about-story p {
  color: var(--text-secondary);
  font-size: var(--fs-lg);
  margin-bottom: 1.2rem;
}
.team-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.4rem;
}
.team-card {
  padding: 2rem;
  border-radius: var(--radius);
  background: var(--bg-secondary);
  border: 1px solid var(--border-soft);
}
.team-card .t-icon {
  width: 54px;
  height: 54px;
  display: grid;
  place-items: center;
  border-radius: 13px;
  color: var(--accent-2);
  background: var(--accent-2-soft);
  margin-bottom: 1rem;
}
.team-card h3 {
  font-size: var(--fs-h3);
}
.team-card p {
  color: var(--text-muted);
  font-size: var(--fs-sm);
  margin-top: 0.5rem;
}
@media (max-width: 900px) {
  .team-grid {
    grid-template-columns: 1fr;
  }
}

/* Timeline */
.timeline {
  position: relative;
  max-width: 760px;
  margin-inline: auto;
  padding-left: 2rem;
}
.timeline::before {
  content: '';
  position: absolute;
  left: 7px;
  top: 6px;
  bottom: 6px;
  width: 2px;
  background: linear-gradient(var(--accent-1), var(--accent-2));
}
.timeline-item {
  position: relative;
  padding-bottom: 2.2rem;
}
.timeline-item::before {
  content: '';
  position: absolute;
  left: -2rem;
  top: 4px;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: var(--bg-primary);
  border: 3px solid var(--accent-1);
}
.timeline-item .t-year {
  font-family: var(--font-mono);
  color: var(--accent-2);
  font-size: var(--fs-sm);
}
.timeline-item h3 {
  font-size: var(--fs-h3);
  margin-block: 0.3rem 0.4rem;
}
.timeline-item p {
  color: var(--text-muted);
}

/* Values hexagon-ish grid */
.values-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.2rem;
}
.value-card {
  position: relative;
  padding: 1.8rem;
  border-radius: var(--radius);
  background: var(--bg-secondary);
  border: 1px solid var(--border-soft);
  overflow: hidden;
  transition: transform var(--dur) var(--ease-out), border-color var(--dur) var(--ease-out);
}
.value-card:hover {
  transform: translateY(-5px);
  border-color: var(--border);
}
.value-card .v-num {
  font-family: var(--font-mono);
  color: var(--accent-2);
  font-size: var(--fs-sm);
}
.value-card h3 {
  font-size: var(--fs-h3);
  margin-block: 0.5rem;
}
.value-card .v-reveal {
  color: var(--text-muted);
  font-size: var(--fs-sm);
  max-height: 0;
  opacity: 0;
  overflow: hidden;
  transition: max-height var(--dur-slow) var(--ease-out), opacity var(--dur) var(--ease-out);
}
.value-card:hover .v-reveal {
  max-height: 200px;
  opacity: 1;
  margin-top: 0.5rem;
}
@media (max-width: 900px) {
  .values-grid {
    grid-template-columns: 1fr;
  }
  .value-card .v-reveal {
    max-height: 200px;
    opacity: 1;
    margin-top: 0.5rem;
  }
}

/* Tech parade */
.tech-parade {
  display: flex;
  flex-wrap: wrap;
  gap: 0.7rem;
  justify-content: center;
}
.tech-chip {
  padding: 0.6rem 1.2rem;
  border-radius: var(--radius-pill);
  border: 1px solid var(--border-soft);
  background: var(--bg-secondary);
  font-family: var(--font-mono);
  font-size: var(--fs-sm);
  color: var(--text-secondary);
}

/* ── SERVICES index hero ───────────────────────────────── */
.page-hero {
  padding-top: calc(var(--nav-h) + 4rem);
  padding-bottom: 1rem;
  text-align: center;
}
.page-hero .eyebrow {
  margin-bottom: 1.2rem;
}
.page-hero h1 {
  font-size: var(--fs-h1);
  max-width: 20ch;
  margin-inline: auto;
}
.page-hero p {
  color: var(--text-secondary);
  font-size: var(--fs-lg);
  max-width: 54ch;
  margin: 1.1rem auto 0;
}

/* ── SERVICE DETAIL ────────────────────────────────────── */
.sd-hero {
  padding-top: calc(var(--nav-h) + 4rem);
  position: relative;
  overflow: hidden;
}
.sd-hero-inner {
  display: grid;
  grid-template-columns: 1.3fr 1fr;
  gap: 2.5rem;
  align-items: center;
}
.sd-back {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  color: var(--text-muted);
  font-size: var(--fs-sm);
  margin-bottom: 1.4rem;
  transition: color var(--dur-fast) var(--ease-out);
}
.sd-back:hover {
  color: var(--accent-2);
}
.sd-title {
  font-size: var(--fs-h1);
  margin-block: 0.8rem 0.8rem;
}
.sd-tagline {
  font-size: var(--fs-lg);
  color: var(--text-secondary);
  max-width: 46ch;
  margin-bottom: 1.8rem;
}
.sd-illustration {
  aspect-ratio: 4 / 3;
  border-radius: var(--radius-lg);
  border: 1px solid var(--border);
  background: var(--bg-secondary);
  display: grid;
  place-items: center;
  position: relative;
  overflow: hidden;
}
.sd-illustration::before {
  content: '';
  position: absolute;
  inset: -30%;
  background: conic-gradient(from 0deg, transparent, var(--accent-1), transparent 50%, var(--accent-2), transparent);
  opacity: 0.16;
  animation: rotate-slow 14s linear infinite;
}
.sd-illustration .ill-icon {
  position: relative;
  color: var(--accent-2);
  animation: float 4s ease-in-out infinite;
}
@media (max-width: 880px) {
  .sd-hero-inner {
    grid-template-columns: 1fr;
  }
}

.sd-deliverables {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.4rem;
}
.sd-deliver {
  padding: 1.8rem;
  border-radius: var(--radius);
  background: var(--bg-secondary);
  border: 1px solid var(--border-soft);
}
.sd-deliver .d-icon {
  width: 48px;
  height: 48px;
  display: grid;
  place-items: center;
  border-radius: 12px;
  color: var(--accent-1);
  background: var(--accent-1-soft);
  margin-bottom: 1rem;
}
.sd-deliver h3 {
  font-size: var(--fs-h3);
  margin-bottom: 0.4rem;
}
.sd-deliver p {
  color: var(--text-muted);
  font-size: var(--fs-sm);
}
@media (max-width: 880px) {
  .sd-deliverables {
    grid-template-columns: 1fr;
  }
}

/* ROI */
.roi-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.4rem;
}
.roi-card {
  text-align: center;
  padding: 2rem;
  border-radius: var(--radius);
  border: 1px solid var(--border);
  background: var(--bg-glass);
}
.roi-card .roi-metric {
  font-family: var(--font-display);
  font-weight: 800;
  font-size: clamp(2.2rem, 5vw, 3.2rem);
  background: var(--gradient-text);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.roi-card .roi-label {
  color: var(--text-muted);
  font-size: var(--fs-sm);
  margin-top: 0.4rem;
}
@media (max-width: 760px) {
  .roi-grid {
    grid-template-columns: 1fr;
  }
}

/* Case study */
.case-study {
  border-radius: var(--radius-lg);
  border: 1px solid var(--border);
  background: var(--bg-secondary);
  padding: clamp(1.8rem, 5vw, 3rem);
  position: relative;
}
.case-study .cs-quote {
  font-family: var(--font-display);
  font-size: var(--fs-h3);
  line-height: 1.4;
  color: var(--text-primary);
}
.case-study .cs-client {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 1.2rem;
  color: var(--accent-2);
  font-family: var(--font-mono);
  font-size: var(--fs-sm);
}

/* Tools badges */
.tools-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
}

/* ── CONTACT ───────────────────────────────────────────── */
.contact-split {
  display: grid;
  grid-template-columns: 0.85fr 1.15fr;
  gap: 2.5rem;
  align-items: start;
}
.contact-info {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.info-card {
  display: flex;
  gap: 1rem;
  padding: 1.5rem;
  border-radius: var(--radius);
  background: var(--bg-secondary);
  border: 1px solid var(--border-soft);
  transition: transform var(--dur) var(--ease-out), border-color var(--dur) var(--ease-out);
}
.info-card:hover {
  transform: translateX(5px);
  border-color: var(--border);
}
.info-card .i-icon {
  width: 46px;
  height: 46px;
  flex-shrink: 0;
  display: grid;
  place-items: center;
  border-radius: 12px;
  color: var(--accent-2);
  background: var(--accent-2-soft);
}
.info-card h3 {
  font-size: var(--fs-lg);
}
.info-card p {
  color: var(--text-muted);
  font-size: var(--fs-sm);
}

.contact-form {
  padding: clamp(1.6rem, 4vw, 2.4rem);
  border-radius: var(--radius-lg);
  background: var(--bg-secondary);
  border: 1px solid var(--border);
}
.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}
.field {
  margin-bottom: 1.1rem;
}
.field label {
  display: block;
  font-size: var(--fs-sm);
  font-weight: 500;
  margin-bottom: 0.45rem;
  color: var(--text-secondary);
}
.field label .req {
  color: var(--accent-3);
}
.field input,
.field textarea,
.field select {
  width: 100%;
  padding: 0.8rem 1rem;
  border-radius: var(--radius-sm);
  border: 1px solid var(--border-soft);
  background: var(--bg-primary);
  color: var(--text-primary);
  transition: border-color var(--dur-fast) var(--ease-out), box-shadow var(--dur-fast) var(--ease-out);
}
.field input:focus,
.field textarea:focus,
.field select:focus {
  outline: none;
  border-color: var(--accent-1);
  box-shadow: 0 0 0 3px var(--accent-1-soft);
}
.field textarea {
  resize: vertical;
  min-height: 120px;
}
.field .err {
  color: var(--accent-3);
  font-size: var(--fs-xs);
  margin-top: 0.35rem;
}
.field input[aria-invalid='true'],
.field textarea[aria-invalid='true'] {
  border-color: var(--accent-3);
}

/* Multi-select service chips */
.multi-select {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}
.ms-chip {
  padding: 0.45rem 0.9rem;
  border-radius: var(--radius-pill);
  border: 1px solid var(--border-soft);
  font-size: var(--fs-sm);
  color: var(--text-muted);
  transition: all var(--dur-fast) var(--ease-out);
}
.ms-chip.active {
  color: var(--text-primary);
  background: var(--accent-1-soft);
  border-color: var(--border);
}

/* Budget range slider */
.range-wrap {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.range-wrap input[type='range'] {
  width: 100%;
  accent-color: var(--accent-1);
}
.range-value {
  font-family: var(--font-mono);
  color: var(--accent-2);
  font-size: var(--fs-sm);
}

/* Success state */
.form-success {
  text-align: center;
  padding: 2rem 1rem;
}
.success-check {
  width: 84px;
  height: 84px;
  margin: 0 auto 1.4rem;
  border-radius: 50%;
  display: grid;
  place-items: center;
  color: #fff;
  background: var(--gradient-brand);
  animation: pulse-glow 2s var(--ease-out) infinite;
}
.form-success h2 {
  font-size: var(--fs-h2);
  margin-bottom: 0.6rem;
}
.form-success p {
  color: var(--text-secondary);
  max-width: 38ch;
  margin: 0 auto 1.6rem;
}

@media (max-width: 880px) {
  .contact-split {
    grid-template-columns: 1fr;
  }
  .form-row {
    grid-template-columns: 1fr;
  }
}

/* ── Blog stub ─────────────────────────────────────────── */
.blog-stub {
  min-height: 60vh;
  display: grid;
  place-items: center;
  text-align: center;
}
.blog-stub .eyebrow {
  margin-bottom: 1.2rem;
}
.blog-stub h1 {
  font-size: var(--fs-h1);
  max-width: 16ch;
  margin-bottom: 1rem;
}
.blog-stub p {
  color: var(--text-secondary);
  max-width: 44ch;
  margin-bottom: 2rem;
}

/* ── 404 ───────────────────────────────────────────────── */
.notfound {
  min-height: 70vh;
  display: grid;
  place-items: center;
  text-align: center;
}
.notfound .big {
  font-family: var(--font-display);
  font-weight: 800;
  font-size: clamp(5rem, 18vw, 11rem);
  line-height: 1;
  background: var(--gradient-text);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
CORTINIX_EOF
echo "  • src/styles/variables.css"
cat > "$ROOT/src/styles/variables.css" << 'CORTINIX_EOF'
/* ============================================================
   Cortinix — Design Tokens
   Dark-only theme.
   ============================================================ */

:root,
[data-theme='dark'] {
  /* Surfaces */
  --bg-primary: #080c14; /* deep space navy */
  --bg-secondary: #0d1321; /* card surfaces */
  --bg-tertiary: #11182b; /* raised surfaces */
  --bg-glass: rgba(255, 255, 255, 0.04); /* glassmorphism panels */
  --bg-glass-strong: rgba(255, 255, 255, 0.07);

  /* Accents */
  --accent-1: #6c63ff; /* electric violet — primary CTA */
  --accent-1-soft: rgba(108, 99, 255, 0.16);
  --accent-2: #00d4aa; /* mint teal — AI / tech indicators */
  --accent-2-soft: rgba(0, 212, 170, 0.14);
  --accent-3: #ff6b6b; /* coral — highlights / warnings */
  --accent-3-soft: rgba(255, 107, 107, 0.14);

  /* Text */
  --text-primary: #f0f4ff;
  --text-secondary: #c2cbe0;
  --text-muted: #8892a4;

  /* Lines */
  --border: rgba(108, 99, 255, 0.2);
  --border-soft: rgba(255, 255, 255, 0.08);

  /* Effects */
  --glow-violet: 0 0 40px rgba(108, 99, 255, 0.45);
  --glow-teal: 0 0 40px rgba(0, 212, 170, 0.35);
  --shadow-card: 0 24px 60px -28px rgba(0, 0, 0, 0.8);
  --gradient-brand: linear-gradient(135deg, #6c63ff 0%, #00d4aa 100%);
  --gradient-warm: linear-gradient(135deg, #6c63ff 0%, #ff6b6b 100%);
  --gradient-text: linear-gradient(120deg, #f0f4ff 0%, #c4c0ff 40%, #00d4aa 100%);

  /* Typography */
  --font-display: 'Syne', system-ui, sans-serif;
  --font-body: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, monospace;

  /* Type scale (fluid) */
  --fs-hero: clamp(2.6rem, 6.5vw, 5.5rem);
  --fs-h1: clamp(2.1rem, 4.5vw, 3.6rem);
  --fs-h2: clamp(1.7rem, 3.2vw, 2.6rem);
  --fs-h3: clamp(1.3rem, 2vw, 1.7rem);
  --fs-lg: 1.18rem;
  --fs-base: 1rem;
  --fs-sm: 0.875rem;
  --fs-xs: 0.78rem;

  /* Spacing & layout */
  --maxw: 1240px;
  --maxw-narrow: 880px;
  --radius-sm: 10px;
  --radius: 16px;
  --radius-lg: 24px;
  --radius-pill: 999px;
  --space-section: clamp(4.5rem, 10vw, 9rem);

  /* Motion */
  --ease-out: cubic-bezier(0.22, 1, 0.36, 1);
  --ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);
  --dur-fast: 0.18s;
  --dur: 0.4s;
  --dur-slow: 0.8s;

  /* Misc */
  --nav-h: 76px;
  color-scheme: dark;
}
CORTINIX_EOF
echo "  • src/utils/api.js"
cat > "$ROOT/src/utils/api.js" << 'CORTINIX_EOF'
import axios from 'axios';

/**
 * Centralised axios instance.
 * In development, VITE_API_URL is usually empty and requests hit
 * "/api/..." which the Vite dev server proxies to the Express backend.
 * In production, set VITE_API_URL to your deployed API origin.
 */
const baseURL = import.meta.env.VITE_API_URL || '';

const api = axios.create({
  baseURL,
  headers: { 'Content-Type': 'application/json' },
  timeout: 15000,
});

/**
 * Submit a contact/query form.
 * @param {object} payload { name, email, phone, company, services[], budget, timeline, message }
 * @returns {Promise<{success:boolean, message?:string, id?:string, error?:string}>}
 */
export async function submitQuery(payload) {
  try {
    const { data } = await api.post('/api/queries', payload);
    return data;
  } catch (err) {
    const message =
      err.response?.data?.error ||
      err.response?.data?.errors?.[0]?.msg ||
      err.message ||
      'Something went wrong. Please try again.';
    return { success: false, error: message };
  }
}

export default api;
CORTINIX_EOF
echo "  • src/utils/useScrollAnimation.js"
cat > "$ROOT/src/utils/useScrollAnimation.js" << 'CORTINIX_EOF'
import { useEffect, useRef, useState } from 'react';

/**
 * useScrollAnimation
 * Returns a ref and a boolean that flips to true the first time the
 * element enters the viewport. Pairs with the `.reveal` CSS class.
 *
 * @param {object} options
 * @param {number} options.threshold  0–1, how much must be visible (default 0.15)
 * @param {string} options.rootMargin margin around the root (default '0px 0px -10% 0px')
 * @param {boolean} options.once       stop observing after first reveal (default true)
 */
export default function useScrollAnimation({
  threshold = 0.15,
  rootMargin = '0px 0px -10% 0px',
  once = true,
} = {}) {
  const ref = useRef(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const el = ref.current;
    if (!el) return undefined;

    // Respect reduced-motion: reveal immediately, skip observing.
    const prefersReduced = window.matchMedia(
      '(prefers-reduced-motion: reduce)'
    ).matches;
    if (prefersReduced) {
      setIsVisible(true);
      return undefined;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setIsVisible(true);
            if (once) observer.unobserve(entry.target);
          } else if (!once) {
            setIsVisible(false);
          }
        });
      },
      { threshold, rootMargin }
    );

    observer.observe(el);
    return () => observer.disconnect();
  }, [threshold, rootMargin, once]);

  return [ref, isVisible];
}
CORTINIX_EOF
echo "  • vite.config.js"
cat > "$ROOT/vite.config.js" << 'CORTINIX_EOF'
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    open: true,
    proxy: {
      // Forward API calls to the Express backend during development.
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true,
      },
    },
  },
  build: {
    outDir: 'dist',
    sourcemap: false,
    chunkSizeWarningLimit: 1200,
    rollupOptions: {
      output: {
        manualChunks: {
          react: ['react', 'react-dom', 'react-router-dom'],
          motion: ['framer-motion'],
          gsap: ['gsap'],
          three: ['three'],
        },
      },
    },
  },
});
CORTINIX_EOF
echo ""
echo "✓ Wrote 38 files into ./$ROOT"
echo "Next: cd $ROOT && npm install && cp .env.example .env"
