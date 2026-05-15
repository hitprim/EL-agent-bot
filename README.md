# EL Agent Bot

Telegram-бот для управления голосовыми агентами ElevenLabs.
Сделан на n8n + MySQL, всё крутится в docker.

## Что умеет

- `/start` - показывает твоих агентов кнопками
- `/add agent_xxx` - привязать агента к своему телеграмм-аккаунту
- Выбрал агента → можно поменять промпт / приветствие / базу знаний

Каждый юзер видит только своих агентов.

## Запуск

Нужно:
- docker
- бот в телеграме (через @BotFather получить токен)
- ключ от ElevenLabs (с правами на agents)
- какой-нибудь туннель к localhost для вебхуков (ngrok, localtunnel)

```
cp .env.example .env
```

Дальше в `.env` заполняешь токены, пароли, WEBHOOK_URL (это твой ngrok-адрес).

```
docker-compose up -d
```

n8n поднимется на http://localhost:5678. При первом заходе попросит создать акк.

## Настройка n8n

1. Заходишь в Settings → Credentials, создаёшь два credential:
   - MySQL: host `mysql`, порт `3306`, база `ymtech_bot`, юзер/пароль из `.env`
   - Telegram: вставляешь токен бота

2. Workflows → Import from File → выбираешь `n8n/workflows/main_bot.workflow.json`

3. В нодах указываешь созданные креды (MySQL у всех mysql-нод, Telegram у Telegram Trigger)

4. Включаешь Active сверху справа

## Файлы

- `docker-compose.yml` - mysql + n8n
- `mysql/schema.sql` - таблицы (users, user_agents, user_sessions)
- `mysql/seed.sql` - можно положить тестовые данные
- `n8n/workflows/main_bot.workflow.json` - сам воркфлоу

## По безопасности

Перед каждым изменением агента воркфлоу делает SELECT в user_agents и проверяет что выбранный агент действительно принадлежит этому юзеру. Если нет - бот шлёт "нет доступа" и не вызывает API.
