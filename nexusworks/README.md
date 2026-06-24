# NexusWorks

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
nexusworks/
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
tar -czf nexusworks.tar.gz nexusworks/
```
