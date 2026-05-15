# EL Agent Bot

Telegram-бот для управления голосовыми агентами ElevenLabs.
Сделан на n8n + MySQL, всё крутится в docker.

## Что умеет

- `/start` - показывает агентов кнопками
- `/add agent_xxx` - привязать агента к своему телеграмм аккаунту
- Выбрал агента - можно поменять промпт/приветствие/базу знаний

Каждый юзер видит только своих агентов.

## Запуск

Нужно:
- docker
- бот в телеграме (токен)
- ключ от ElevenLabs
- какой-нибудь туннель к localhost для вебхуков (использовался ngrok)

```
cp .env.example .env
```

Дальше в `.env` заполнить токены, пароли, WEBHOOK_URL.

```
docker-compose up -d
```

n8n поднимется на http://localhost:5678

## Настройка n8n

1. Заходим в Settings - Credentials, создаем два credential:
   - MySQL: host `mysql`, порт `3306`, база `ymtech_bot`, юзер/пароль из `.env`
   - Telegram: вставить токен бота

2. Импортируем `n8n/workflows/main_bot.workflow.json`

3. В нодах указываем созданные креды (MySQL у всех mysql-нод, Telegram у Telegram Trigger, обчно ставит автоматически)

4. Прогоняем и нажимаем "Public"

## Файлы

- `docker-compose.yml` - mysql + n8n
- `mysql/schema.sql` - таблицы (users, user_agents, user_sessions)
- `mysql/seed.sql` - можно положить тестовые данные
- `n8n/workflows/main_bot.workflow.json` - сам воркфлоу

## По безопасности

Перед каждым изменением агента воркфлоу делает SELECT в user_agents и проверяет что выбранный агент действительно принадлежит этому юзеру. Если нет - бот шлёт "нет доступа" и не вызывает API.
