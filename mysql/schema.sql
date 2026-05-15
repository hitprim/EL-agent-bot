CREATE DATABASE IF NOT EXISTS ymtech_bot
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ymtech_bot;

CREATE TABLE IF NOT EXISTS users (
  id            BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  telegram_id   BIGINT           NOT NULL,
  chat_id       BIGINT           NOT NULL,
  username      VARCHAR(255)     DEFAULT NULL,
  first_name    VARCHAR(255)     DEFAULT NULL,
  created_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uq_telegram_id (telegram_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_agents (
  id                  BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  user_id             BIGINT UNSIGNED  NOT NULL,
  elevenlabs_agent_id VARCHAR(255)     NOT NULL,
  agent_name          VARCHAR(255)     NOT NULL,
  created_at          TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uq_user_agent (user_id, elevenlabs_agent_id),
  CONSTRAINT fk_user_agents_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- состояния: idle / await_prompt / await_welcome / await_kb
CREATE TABLE IF NOT EXISTS user_sessions (
  id                BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  user_id           BIGINT UNSIGNED  NOT NULL,
  state             VARCHAR(64)      NOT NULL DEFAULT 'idle',
  selected_agent_id VARCHAR(255)     DEFAULT NULL,
  updated_at        TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uq_user_session (user_id),
  CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
