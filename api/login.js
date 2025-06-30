import pool from './database.js';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';

export default async function handler(req, res) {
  console.log('=== VERCEL LOGIN FUNCTION CALLED ===');
  console.log('Method:', req.method);
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);
  console.log('Query:', req.query);

  // Настройка CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // Обработка preflight запросов
  if (req.method === 'OPTIONS') {
    console.log('Handling OPTIONS request');
    res.status(200).end();
    return;
  }

  // Обработка POST запроса для логина
  if (req.method === 'POST') {
    try {
      console.log('Processing POST request');
      let body = req.body;
      if (!body) {
        const buffers = [];
        for await (const chunk of req) {
          buffers.push(chunk);
        }
        body = JSON.parse(Buffer.concat(buffers).toString());
      }
      const { username, password } = body;
      if (!username || !password) {
        return res.status(400).json({ error: 'Username and password are required' });
      }
      const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
      const user = result.rows[0];
      if (!user) {
        return res.status(401).json({ error: 'User not found' });
      }
      const valid = await bcrypt.compare(password, user.password_hash);
      if (!valid) {
        return res.status(401).json({ error: 'Invalid password' });
      }
      const token = jwt.sign({ id: user.id, username: user.username, isAdmin: user.is_admin }, process.env.JWT_SECRET, { expiresIn: '7d' });
      res.status(200).json({ token, user: { id: user.id, username: user.username, email: user.email, isAdmin: user.is_admin } });
    } catch (err) {
      console.error('Login error:', err);
      res.status(500).json({ error: err.message });
    }
  } else {
    // Для других методов
    console.log('Unsupported method:', req.method, 'Headers:', req.headers, 'Body:', req.body, 'Query:', req.query);
    res.status(405).json({ error: 'Метод не поддерживается' });
  }
} 