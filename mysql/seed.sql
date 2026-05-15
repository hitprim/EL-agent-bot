-- тестовые данные, подставить свои telegram_id и agent_id

USE ymtech_bot;

INSERT INTO users (telegram_id, chat_id, username, first_name)
VALUES (123456789, 123456789, 'your_username', 'Your Name');

INSERT INTO user_agents (user_id, elevenlabs_agent_id, agent_name)
VALUES (
  (SELECT id FROM users WHERE telegram_id = 123456789),
  'agent_xxxxxxxxxxxxxxxx',
  'My Agent'
);

INSERT IGNORE INTO user_sessions (user_id, state)
VALUES (
  (SELECT id FROM users WHERE telegram_id = 123456789),
  'idle'
);
