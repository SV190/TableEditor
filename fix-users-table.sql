-- Проверяем текущую структуру таблицы users
-- Если таблица существует с неправильным типом id, удаляем её
DROP TABLE IF EXISTS users;

-- Создаем таблицу users с правильной структурой
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    is_admin BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создаем индексы для оптимизации
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_is_admin ON users(is_admin);

-- Включаем RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Создаем политики для RLS
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