# YMTech Bot

Telegram-бот для управления голосовыми агентами ElevenLabs.
n8n + MySQL, запуск через docker-compose.

## Что умеет

- `/start` — показать список твоих агентов кнопками
- `/add agent_xxx` — привязать агента к своему Telegram-аккаунту
- Выбрав агента из списка можно изменить:
  - системный промпт
  - приветственное сообщение
  - базу знаний

Каждый юзер видит и редактирует только своих агентов.

## Запуск

Нужны:
- Docker + Docker Compose
- Telegram Bot Token (через @BotFather)
- ElevenLabs API key с правами ElevenAgents Write
- HTTPS-туннель к localhost:5678 для вебхуков Telegram (ngrok или подобное)

```bash
cp .env.example .env
# заполнить .env
docker-compose up -d
```

n8n откроется на http://localhost:5678. При первом запуске создаст админ-аккаунт.

Дальше:

1. Settings → Credentials:
   - **MySQL** (тип MySQL): host `mysql`, port `3306`, database `ymtech_bot`, user `bot_user`, пароль из `.env`
   - **Telegram** (тип Telegram API): Bot Token из `.env`
2. Workflows → Import from File → выбрать `n8n/workflows/main_bot.workflow.json`
3. В импортированном воркфлоу привязать credentials к нодам (MySQL ко всем mysql-нодам, Telegram к Telegram Trigger)
4. Активировать воркфлоу (toggle Active)

## Структура

```
ymtech-test/
├── docker-compose.yml
├── .env.example
├── n8n/workflows/main_bot.workflow.json
├── mysql/schema.sql       — структура БД (3 таблицы)
└── mysql/seed.sql         — тестовые данные
```

## БД

- `users` — Telegram-пользователи
- `user_agents` — связка user → ElevenLabs agent
- `user_sessions` — текущий state диалога для каждого юзера (idle / await_prompt / await_welcome / await_kb)

Перед каждым PATCH к ElevenLabs воркфлоу проверяет в `user_agents` что выбранный агент принадлежит юзеру.
