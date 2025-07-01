# Инструкция по настройке приложения

## 1. Настройка Supabase

### Создание проекта
1. Зайдите на [Supabase](https://supabase.com)
2. Создайте новый проект
3. Скопируйте URL и Anon Key из настроек проекта

### Настройка переменных окружения
1. Откройте файл `.env` в корне проекта
2. Замените значения на ваши:
   ```
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your_anon_key_here
   ```

### Создание таблицы users
1. В Supabase Dashboard перейдите в **SQL Editor**
2. Выполните скрипт из файла `fix-users-table.sql`

### Создание администратора
1. Перейдите в **Authentication** → **Users**
2. Создайте пользователя:
   - Email: `admin@example.com`
   - Password: `admin123`
3. Скопируйте ID пользователя
4. В **SQL Editor** выполните:
   ```sql
   INSERT INTO users (id, email, is_admin, created_at) 
   VALUES ('USER_ID_HERE', 'admin@example.com', true, NOW());
   ```

## 2. Запуск приложения

```bash
npm install
npm run dev
```

## 3. Вход в систему

- Email: `admin@example.com`
- Password: `admin123`

## 4. Возможные проблемы

### Ошибка 400 при входе
- Проверьте правильность URL и ключа Supabase
- Убедитесь, что регистрация включена в настройках Supabase

### Ошибка "invalid input syntax for type integer"
- Выполните скрипт из `fix-users-table.sql`
- Убедитесь, что таблица `users` имеет правильную структуру

### Ошибки Dropbox
- Dropbox функциональность временно отключена
- Для включения настройте Dropbox App и обновите код

## 5. Структура проекта

- `src/composables/useAuth.js` - аутентификация
- `src/composables/useUsers.js` - управление пользователями
- `src/composables/useDropbox.js` - интеграция с Dropbox
- `src/components/AdminPanel.vue` - админ панель
- `src/components/UserAuth.vue` - страница входа
- `src/components/MainApp.vue` - главное приложение 