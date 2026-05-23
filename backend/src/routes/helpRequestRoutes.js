import express from 'express';
import { createHelpRequest, getHelpRequests } from '../controllers/helpRequestController.js';
import { authMiddleware, requireRole } from '../middleware/authMiddleware.js';

const router = express.Router();

// Apply auth middleware to protect help request routes
router.use(authMiddleware);

// POST: Any authenticated user can create an emergency help request
router.post('/', createHelpRequest);

// GET: Only admin or responder roles can retrieve the history of help requests
router.get('/', requireRole(['admin', 'responder']), getHelpRequests);

export default router;
