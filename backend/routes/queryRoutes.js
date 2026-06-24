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
  realm: 'NexusWorks Admin',
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
