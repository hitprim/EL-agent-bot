-- ymtech-test: схема базы данных
-- Кодировка: utf8mb4 (поддержка emoji и кириллицы)
-- Engine: InnoDB (транзакционный)

CREATE DATABASE IF NOT EXISTS ymtech_bot
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ymtech_bot;

-- Telegram-пользователи
CREATE TABLE IF NOT EXISTS users (
  id            BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  telegram_id   BIGINT           NOT NULL,  -- from.id из Telegram update
  chat_id       BIGINT           NOT NULL,  -- chat.id, куда слать ответы
  username      VARCHAR(255)     DEFAULT NULL,
  first_name    VARCHAR(255)     DEFAULT NULL,
  created_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uq_telegram_id (telegram_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Привязка агентов ElevenLabs к пользователям
-- Агент создаётся в ElevenLabs вручную или через API,
-- сюда кладём его ID чтобы знать кому он принадлежит
CREATE TABLE IF NOT EXISTS user_agents (
  id                BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  user_id           BIGINT UNSIGNED  NOT NULL,
  elevenlabs_agent_id VARCHAR(255)   NOT NULL,  -- ID агента в системе ElevenLabs
  agent_name        VARCHAR(255)     NOT NULL,  -- локальное имя для отображения в боте
  created_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uq_user_agent (user_id, elevenlabs_agent_id),
  CONSTRAINT fk_user_agents_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Сессия диалога: хранит текущий шаг юзера в боте (state machine)
-- Нужна потому что Telegram stateless - между сообщениями надо помнить контекст
-- Например: юзер выбрал агента, теперь ждём от него новый промпт
CREATE TABLE IF NOT EXISTS user_sessions (
  id            BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  user_id       BIGINT UNSIGNED  NOT NULL,
  state         VARCHAR(64)      NOT NULL DEFAULT 'idle',
  -- Возможные состояния: idle | await_prompt | await_welcome | await_kb
  selected_agent_id VARCHAR(255) DEFAULT NULL,  -- elevenlabs_agent_id текущего выбранного агента
  updated_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uq_user_session (user_id),
  CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
