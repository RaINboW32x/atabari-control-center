-- Şema uygulama başlarken server.js tarafından otomatik oluşturulur ve güncellenir.
-- Manuel çalıştırma zorunlu değildir.

-- V2 Operasyon Merkezi
CREATE TABLE IF NOT EXISTS announcements(id BIGSERIAL PRIMARY KEY,title VARCHAR(140) NOT NULL,content TEXT NOT NULL DEFAULT '',priority VARCHAR(20) NOT NULL DEFAULT 'normal',active BOOLEAN NOT NULL DEFAULT TRUE,created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
CREATE TABLE IF NOT EXISTS sponsors(id BIGSERIAL PRIMARY KEY,brand_name VARCHAR(140) NOT NULL,campaign_name VARCHAR(180) NOT NULL DEFAULT '',logo_url VARCHAR(500) NOT NULL DEFAULT '',start_date DATE,end_date DATE,status VARCHAR(20) NOT NULL DEFAULT 'active',brief TEXT NOT NULL DEFAULT '',created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
CREATE TABLE IF NOT EXISTS sponsor_tasks(id BIGSERIAL PRIMARY KEY,sponsor_id BIGINT NOT NULL REFERENCES sponsors(id) ON DELETE CASCADE,broadcast_id BIGINT REFERENCES broadcasts(id) ON DELETE SET NULL,streamer_id BIGINT REFERENCES streamers(id) ON DELETE SET NULL,task_type VARCHAR(60) NOT NULL,title VARCHAR(180) NOT NULL,due_at TIMESTAMPTZ,status VARCHAR(20) NOT NULL DEFAULT 'pending',proof_url VARCHAR(500) NOT NULL DEFAULT '',note TEXT NOT NULL DEFAULT '',created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
CREATE TABLE IF NOT EXISTS operation_notes(id BIGSERIAL PRIMARY KEY,broadcast_id BIGINT REFERENCES broadcasts(id) ON DELETE CASCADE,user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,note_type VARCHAR(30) NOT NULL DEFAULT 'note',content TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());

ALTER TABLE users ADD COLUMN IF NOT EXISTS email VARCHAR(254);
CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash VARCHAR(64) UNIQUE NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- V3.1
CREATE TABLE IF NOT EXISTS daily_tasks(
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(180) NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  task_date DATE NOT NULL DEFAULT CURRENT_DATE,
  assigned_user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
  assigned_streamer_id BIGINT REFERENCES streamers(id) ON DELETE SET NULL,
  broadcast_id BIGINT REFERENCES broadcasts(id) ON DELETE SET NULL,
  priority VARCHAR(20) NOT NULL DEFAULT 'normal',
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS daily_tasks_date_idx ON daily_tasks(task_date,status);

CREATE TABLE IF NOT EXISTS broadcast_briefings(
  id BIGSERIAL PRIMARY KEY,
  broadcast_id BIGINT UNIQUE NOT NULL REFERENCES broadcasts(id) ON DELETE CASCADE,
  talking_points TEXT NOT NULL DEFAULT '',
  restricted_topics TEXT NOT NULL DEFAULT '',
  sponsor_code VARCHAR(120) NOT NULL DEFAULT '',
  important_links TEXT NOT NULL DEFAULT '',
  special_notes TEXT NOT NULL DEFAULT '',
  updated_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS score_events(
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  streamer_id BIGINT REFERENCES streamers(id) ON DELETE CASCADE,
  broadcast_id BIGINT REFERENCES broadcasts(id) ON DELETE SET NULL,
  points INTEGER NOT NULL,
  reason VARCHAR(220) NOT NULL,
  created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK(user_id IS NOT NULL OR streamer_id IS NOT NULL)
);
CREATE INDEX IF NOT EXISTS score_events_created_idx ON score_events(created_at DESC);


CREATE TABLE IF NOT EXISTS sponsor_reminders(
  id BIGSERIAL PRIMARY KEY,
  sponsor_task_id BIGINT NOT NULL REFERENCES sponsor_tasks(id) ON DELETE CASCADE,
  broadcast_id BIGINT NOT NULL REFERENCES broadcasts(id) ON DELETE CASCADE,
  streamer_id BIGINT NOT NULL REFERENCES streamers(id) ON DELETE CASCADE,
  created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
  timing_mode VARCHAR(30) NOT NULL DEFAULT 'after_start',
  offset_minutes INTEGER NOT NULL DEFAULT 30,
  absolute_at TIMESTAMPTZ,
  message TEXT NOT NULL DEFAULT '',
  promo_code VARCHAR(140) NOT NULL DEFAULT '',
  promo_link VARCHAR(500) NOT NULL DEFAULT '',
  checklist JSONB NOT NULL DEFAULT '[]'::jsonb,
  status VARCHAR(30) NOT NULL DEFAULT 'pending',
  remind_at TIMESTAMPTZ NOT NULL,
  notified_at TIMESTAMPTZ,
  seen_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  snoozed_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS sponsor_reminders_due_idx ON sponsor_reminders(status,remind_at);
