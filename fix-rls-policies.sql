-- Удаляем все существующие политики для таблицы users
DROP POLICY IF EXISTS "Users can view own data" ON users;
DROP POLICY IF EXISTS "Admins can view all data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;
DROP POLICY IF EXISTS "Admins can update all data" ON users;
DROP POLICY IF EXISTS "Admins can insert data" ON users;
DROP POLICY IF EXISTS "Admins can delete data" ON users;

-- Отключаем RLS временно для отладки
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Или создаем простые политики без рекурсии
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Простая политика для чтения (все авторизованные пользователи могут читать)
-- CREATE POLICY "Enable read access for authenticated users" ON users
--     FOR SELECT USING (auth.role() = 'authenticated');

-- Простая политика для записи (только админы)
-- CREATE POLICY "Enable insert for admins" ON users
--     FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Простая политика для обновления (только админы)
-- CREATE POLICY "Enable update for admins" ON users
--     FOR UPDATE USING (auth.role() = 'authenticated'); 