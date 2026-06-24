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
