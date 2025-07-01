# Быстрое исправление ошибки "invalid input syntax for type integer"

## Проблема
Ошибка возникает, когда таблица `users` имеет поле `id` типа `integer` вместо `UUID`.

## Решение (5 минут)

### 1. Откройте Supabase Dashboard
- Зайдите на https://supabase.com/dashboard
- Выберите ваш проект

### 2. Исправьте структуру таблицы
- Перейдите в **"SQL Editor"**
- Выполните этот код:

```sql
-- Удаляем старую таблицу
DROP TABLE IF EXISTS users;

-- Создаем новую таблицу с правильной структурой
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    is_admin BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3. Создайте администратора
- Перейдите в **"Authentication"** → **"Users"**
- Нажмите **"Add user"**
- Email: `admin@example.com`
- Password: `admin123`
- Нажмите **"Create user"**

### 4. Добавьте права администратора
- Скопируйте ID пользователя из списка
- В **"SQL Editor"** выполните:

```sql
INSERT INTO users (id, email, is_admin, created_at) 
VALUES ('ВСТАВЬТЕ_ID_ПОЛЬЗОВАТЕЛЯ', 'admin@example.com', true, NOW());
```

### 5. Готово!
Теперь можете войти с:
- Email: `admin@example.com`
- Password: `admin123` 