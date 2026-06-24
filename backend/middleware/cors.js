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
