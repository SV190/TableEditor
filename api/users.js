import pool from './database.js';
import bcrypt from 'bcryptjs';

export default async function handler(req, res) {
  if (req.method === 'GET') {
    try {
      const { rows } = await pool.query('SELECT id, username, email, is_admin, is_blocked, created_at FROM users ORDER BY created_at DESC');
      res.status(200).json(rows);
    } catch (err) {
      console.error('Error fetching users:', err);
      res.status(500).json({ error: err.message });
    }
  } else if (req.method === 'POST') {
    try {
      const { username, email, password, isAdmin } = req.body || {};
      if (!username || !password) {
        return res.status(400).json({ error: 'Username and password are required' });
      }
      const passwordHash = await bcrypt.hash(password, 10);
      const result = await pool.query(
        'INSERT INTO users (username, email, password_hash, is_admin) VALUES ($1, $2, $3, $4) RETURNING id',
        [username, email, passwordHash, isAdmin ? true : false]
      );
      res.status(201).json({ id: result.rows[0].id });
    } catch (err) {
      console.error('Error creating user:', err);
      res.status(500).json({ error: err.message });
    }
  } else {
    res.status(405).json({ error: 'Метод не поддерживается' });
  }
} 