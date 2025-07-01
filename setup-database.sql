-- Создание таблицы пользователей
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    is_admin BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создание индексов для оптимизации
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON users(is_admin);

-- Создание функции для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Создание триггера для автоматического обновления updated_at
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Включение RLS (Row Level Security) для таблицы users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Создание политик для RLS
-- Пользователи могут видеть только свои данные
CREATE POLICY "Users can view own data" ON users
    FOR SELECT USING (auth.uid() = id);

-- Администраторы могут видеть все данные
CREATE POLICY "Admins can view all data" ON users
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- Пользователи могут обновлять только свои данные
CREATE POLICY "Users can update own data" ON users
    FOR UPDATE USING (auth.uid() = id);

-- Администраторы могут обновлять все данные
CREATE POLICY "Admins can update all data" ON users
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- Администраторы могут вставлять данные
CREATE POLICY "Admins can insert data" ON users
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- Администраторы могут удалять данные
CREATE POLICY "Admins can delete data" ON users
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND is_admin = true
        )
    );

-- Комментарий: После выполнения этого скрипта создайте пользователя через Supabase Dashboard
-- и затем выполните следующий запрос, заменив USER_ID на реальный ID пользователя:

-- INSERT INTO users (id, email, is_admin, created_at) 
-- VALUES ('USER_ID_HERE', 'admin@example.com', true, NOW()); 