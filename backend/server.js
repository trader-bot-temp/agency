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
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/nexusworks';

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
      console.log(`✓ NexusWorks API running on http://localhost:${PORT}`);
    });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('✗ Failed to start server:', err.message);
    process.exit(1);
  }
}

start();

export default app;
