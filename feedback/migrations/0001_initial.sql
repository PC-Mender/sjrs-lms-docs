CREATE TABLE IF NOT EXISTS docs_feedback_votes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  page_path TEXT NOT NULL,
  page_title TEXT NOT NULL,
  vote TEXT NOT NULL CHECK (vote IN ('up', 'down')),
  comment TEXT,
  visitor_hash TEXT NOT NULL,
  ip_hash TEXT NOT NULL,
  user_agent_hash TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (page_path, visitor_hash)
);

CREATE INDEX IF NOT EXISTS idx_docs_feedback_votes_page_path
  ON docs_feedback_votes(page_path);

CREATE INDEX IF NOT EXISTS idx_docs_feedback_votes_updated_at
  ON docs_feedback_votes(updated_at);

CREATE TABLE IF NOT EXISTS docs_feedback_summary (
  page_path TEXT PRIMARY KEY,
  up_count INTEGER NOT NULL DEFAULT 0,
  down_count INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS docs_feedback_rate_limits (
  rate_key TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_docs_feedback_rate_limits_key_time
  ON docs_feedback_rate_limits(rate_key, created_at);

CREATE TRIGGER IF NOT EXISTS trg_docs_feedback_votes_updated_at
AFTER UPDATE ON docs_feedback_votes
FOR EACH ROW
BEGIN
  UPDATE docs_feedback_votes
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;
