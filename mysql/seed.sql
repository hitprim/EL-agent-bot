-- seed.sql - тестовые данные
-- Запускать ПОСЛЕ schema.sql на чистой базе
-- Замени значения на реальные перед тестированием

USE ymtech_bot;

-- Тестовый пользователь
-- telegram_id и chat_id - это твой реальный Telegram ID
-- Узнать можно написав @userinfobot в Telegram
INSERT INTO users (telegram_id, chat_id, username, first_name)
VALUES (123456789, 123456789, 'your_username', 'Your Name');

-- Привязка тестового агента к пользователю
-- elevenlabs_agent_id - реальный ID агента из ElevenLabs
INSERT INTO user_agents (user_id, elevenlabs_agent_id, agent_name)
VALUES (
  (SELECT id FROM users WHERE telegram_id = 123456789),
  'agent_4901kreg9b5dfy6rfd00y9gknmvf',
  'My Agent'
);

-- Сессия создаётся автоматически ботом при первом /start
-- Но можно инициализировать вручную для тестов:
INSERT IGNORE INTO user_sessions (user_id, state)
VALUES (
  (SELECT id FROM users WHERE telegram_id = 123456789),
  'idle'
);
