# Настройка администратора

## ⚠️ Важно: Включите регистрацию в Supabase

Перед созданием администратора убедитесь, что регистрация включена:

1. Зайдите в [Supabase Dashboard](https://supabase.com/dashboard)
2. Выберите ваш проект
3. Перейдите в **Authentication** → **Settings**
4. Включите опцию **"Enable signups"** (поставьте галочку)
5. Сохраните настройки

## Способ 1: Через HTML файл (рекомендуется)

1. Откройте файл `create-admin.html` в браузере
2. Заполните поля:
   - **Supabase URL**: URL вашего проекта Supabase (например: `https://your-project.supabase.co`)
   - **Supabase Anon Key**: Анонимный ключ из настроек проекта
   - **Email администратора**: `admin@example.com` (или любой другой)
   - **Пароль администратора**: `admin123` (или любой другой, минимум 6 символов)
3. Нажмите "Создать администратора"
4. После успешного создания используйте эти данные для входа в систему

## Способ 2: Через Supabase Dashboard (если регистрация отключена)

Если вы не хотите включать регистрацию, создайте администратора вручную:

1. Зайдите в [Supabase Dashboard](https://supabase.com/dashboard)
2. Выберите ваш проект
3. Перейдите в раздел **"Authentication"** → **"Users"**
4. Нажмите **"Add user"**
5. Заполните:
   - **Email**: `admin@example.com`
   - **Password**: `admin123`
6. Нажмите **"Create user"**
7. Скопируйте **ID пользователя** (он понадобится для следующего шага)
8. Перейдите в **"Table Editor"**
9. Найдите таблицу `users` (если её нет, создайте через SQL Editor)
10. Добавьте запись:
    ```sql
    INSERT INTO users (id, email, is_admin, created_at) 
    VALUES ('USER_ID_FROM_AUTH', 'admin@example.com', true, NOW());
    ```
    (Замените `USER_ID_FROM_AUTH` на ID пользователя, который вы скопировали)

## Способ 3: Через SQL Editor (исправление структуры таблицы)

Если у вас возникла ошибка "invalid input syntax for type integer", это означает, что таблица `users` имеет неправильную структуру.

### Шаг 1: Исправление структуры таблицы

1. В Supabase Dashboard перейдите в **"SQL Editor"**
2. Выполните следующий скрипт для пересоздания таблицы:

```sql
-- Удаляем старую таблицу (если она существует)
DROP TABLE IF EXISTS users;

-- Создаем таблицу users с правильной структурой
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    is_admin BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создаем индексы
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_is_admin ON users(is_admin);
```

### Шаг 2: Создание пользователя

После исправления структуры таблицы:

1. Перейдите в **"Authentication"** → **"Users"**
2. Создайте пользователя с email `admin@example.com` и паролем `admin123`
3. Скопируйте ID пользователя
4. В **"SQL Editor"** выполните:

```sql
INSERT INTO users (id, email, is_admin, created_at) 
VALUES ('USER_ID_HERE', 'admin@example.com', true, NOW());
```

(Замените `USER_ID_HERE` на реальный ID пользователя)

## Вход в систему

После создания администратора используйте:
- **Email**: `admin@example.com`
- **Пароль**: `admin123`

## Примечания

- Убедитесь, что в вашем проекте Supabase включена аутентификация по email/password
- Пароль должен содержать минимум 6 символов
- После создания администратора вы сможете создавать других пользователей через админ-панель
- Рекомендуется сменить пароль администратора после первого входа 