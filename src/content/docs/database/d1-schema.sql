-- Consolidated schema backup generated: 2026-06-23T06-56-06
PRAGMA foreign_keys=ON;

-- Table: _cf_KV
CREATE TABLE _cf_KV (
        key TEXT PRIMARY KEY,
        value BLOB
      ) WITHOUT ROWID;

-- Table: roles
CREATE TABLE roles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
, updated_at DATETIME, hierarchy_level INTEGER DEFAULT 1, display_name TEXT);

-- Table: sqlite_sequence
CREATE TABLE sqlite_sequence(name,seq);

-- Table: authors
CREATE TABLE authors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  biography TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
, updated_at DATETIME);

-- Table: books
CREATE TABLE books (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  author_id INTEGER REFERENCES authors(id),
  isbn TEXT UNIQUE,
  publication_year INTEGER,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
, subcategory_id INTEGER, base_code TEXT, cover_image TEXT, publication_id INTEGER REFERENCES publications(id) ON DELETE SET NULL);

-- Table: permission_resources
CREATE TABLE permission_resources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  resource_name TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  is_active INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: permission_actions
CREATE TABLE permission_actions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  action_name TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  description TEXT,
  is_active INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: role_permissions
CREATE TABLE role_permissions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role_id INTEGER NOT NULL,
  resource_id INTEGER NOT NULL,
  action_id INTEGER NOT NULL,
  is_granted INTEGER DEFAULT 0,
  created_by INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_by INTEGER,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(role_id, resource_id, action_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (resource_id) REFERENCES permission_resources(id) ON DELETE CASCADE,
  FOREIGN KEY (action_id) REFERENCES permission_actions(id) ON DELETE CASCADE
);

-- Table: user_type_role_mapping
CREATE TABLE user_type_role_mapping (
  user_type TEXT PRIMARY KEY,
  default_role_id INTEGER REFERENCES roles(id)
);

-- Table: role_management_permissions
CREATE TABLE role_management_permissions (
  role_name TEXT PRIMARY KEY,
  can_manage_roles BOOLEAN DEFAULT FALSE,
  can_assign_administrative_roles BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: system_logs
CREATE TABLE system_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TEXT NOT NULL,
    level TEXT NOT NULL,
    message TEXT NOT NULL,
    context TEXT,
    error_details TEXT,
    data TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: rate_limits
CREATE TABLE rate_limits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rate_key TEXT NOT NULL,           -- Unique identifier for rate limiting (IP:UserAgent:Path)
    created_at DATETIME DEFAULT (datetime('now'))
);

-- Table: sections
CREATE TABLE sections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
, code TEXT, location TEXT, capacity INTEGER, is_active INTEGER NOT NULL DEFAULT 1, location_id INTEGER REFERENCES locations(id) ON DELETE SET NULL);

-- Table: journal_articles
CREATE TABLE journal_articles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  journal_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (journal_id) REFERENCES journals(id) ON DELETE CASCADE
);

-- Table: journal_tags
CREATE TABLE journal_tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  article_id INTEGER NOT NULL,
  tag TEXT NOT NULL,
  FOREIGN KEY (article_id) REFERENCES journal_articles(id) ON DELETE CASCADE
);

-- Table: resource_types
CREATE TABLE resource_types (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  section_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
  -- Removed foreign key constraint to avoid dependency issues
);

-- Table: reference_categories
CREATE TABLE reference_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  parent_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
  -- Removed foreign key constraint to avoid dependency issues
);

-- Table: reference_books
CREATE TABLE reference_books (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reference_id TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  subtitle TEXT,
  author_id INTEGER,
  publication_id INTEGER,
  volume INTEGER,
  language TEXT NOT NULL DEFAULT 'English',
  book_status TEXT DEFAULT 'available' CHECK (book_status IN ('available', 'borrowed', 'lost', 'damaged')),
  resource_type_id INTEGER,
  section_id INTEGER,
  category_id INTEGER,
  isbn TEXT,
  publisher TEXT,
  published_year INTEGER,
  edition TEXT,
  pages INTEGER,
  location_details TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
  -- Removed foreign key constraints to avoid dependency issues
);

-- Table: help_content
CREATE TABLE help_content (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    content TEXT NOT NULL,
    category TEXT NOT NULL,
    category_title TEXT NOT NULL,
    category_description TEXT,
    category_icon TEXT,
    category_order INTEGER DEFAULT 0,
    roles TEXT NOT NULL, -- JSON array of roles that can access this content
    difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    tags TEXT, -- JSON array of tags
    estimated_time TEXT,
    video_url TEXT,
    related_topics TEXT, -- JSON array of related topic IDs
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
, view_count INTEGER DEFAULT 0, helpful_votes INTEGER DEFAULT 0, not_helpful_votes INTEGER DEFAULT 0, last_viewed_at DATETIME, priority INTEGER DEFAULT 1, status TEXT DEFAULT 'published');

-- Table: reference_sections
CREATE TABLE reference_sections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: superuser_permissions
CREATE TABLE superuser_permissions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  permission_name TEXT UNIQUE NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  is_active INTEGER DEFAULT 1 CHECK (is_active IN (0, 1)),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: dioceses
CREATE TABLE dioceses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: congregations
CREATE TABLE congregations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: library_users
CREATE TABLE "library_users" ( id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE NOT NULL, password_hash TEXT NOT NULL, first_name TEXT NOT NULL, last_name TEXT NOT NULL, role_id INTEGER REFERENCES roles(id), status TEXT DEFAULT 'pending' CHECK (status IN ('pending','active','inactive','suspended')), phone TEXT, stream TEXT, email_verified BOOLEAN DEFAULT FALSE, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP , last_active_role_id INTEGER REFERENCES roles(id), last_login DATETIME, suspended_source TEXT, suspended_reason TEXT, suspended_at DATETIME, suspended_prev_status TEXT, onboarding_status TEXT NOT NULL DEFAULT 'pending_email_confirmation'
CHECK (onboarding_status IN ('pending_email_confirmation','profile_incomplete','pending_approval','complete')), user_type_id INTEGER, avatar_url TEXT, affiliation_type TEXT, diocese_id INTEGER REFERENCES dioceses(id), congregation_id INTEGER REFERENCES congregations(id), email_verified_at DATETIME, status_changed_at DATETIME, onboarding_status_changed_at DATETIME, has_seen_welcome INTEGER NOT NULL DEFAULT 0 CHECK (has_seen_welcome IN (0, 1)));

-- Table: students
CREATE TABLE "students" ( id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER REFERENCES library_users(id), registration_number TEXT UNIQUE, year_of_study INTEGER, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP );

-- Table: badges
CREATE TABLE badges (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  key TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT,             -- e.g., 'crown', 'book', 'mortarboard'
  color TEXT,            -- hex color like '#ff4d4f'
  level INTEGER DEFAULT 0,
  visibility TEXT NOT NULL DEFAULT 'public' CHECK (visibility IN ('public','private','internal')),
  is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0,1)),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table: user_badges
CREATE TABLE user_badges (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  badge_id INTEGER NOT NULL,
  awarded_by INTEGER,
  awarded_reason TEXT,
  awarded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME,
  is_revoked INTEGER NOT NULL DEFAULT 0 CHECK (is_revoked IN (0,1)),
  revoked_at DATETIME, period_key TEXT, celebrated_at DATETIME,
  UNIQUE(user_id, badge_id),
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE,
  FOREIGN KEY (awarded_by) REFERENCES library_users(id) ON DELETE SET NULL
);

-- Table: role_badges
CREATE TABLE role_badges (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role TEXT NOT NULL,
  badge_id INTEGER NOT NULL,
  UNIQUE(role, badge_id),
  FOREIGN KEY (role) REFERENCES roles(name) ON DELETE CASCADE,
  FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE
);

-- Table: guests
CREATE TABLE guests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER UNIQUE NOT NULL,
  about TEXT,
  city TEXT,
  state TEXT,
  country TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, district TEXT,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: notification_events
CREATE TABLE notification_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'announcement'
    CHECK (category IN (
      'deployment',
      'platform-update',
      'incident',
      'maintenance',
      'announcement',
      'policy',
      'event'
    )),
  severity TEXT NOT NULL DEFAULT 'info'
    CHECK (severity IN ('info', 'notice', 'warning', 'critical')),
  source TEXT NOT NULL DEFAULT 'manual',
  scope TEXT NOT NULL DEFAULT 'global'
    CHECK (scope IN ('global', 'user', 'role', 'permission')),
  status TEXT NOT NULL DEFAULT 'active'
    CHECK (status IN ('draft', 'scheduled', 'active', 'resolved', 'archived')),
  action_url TEXT,
  metadata TEXT,
  tags TEXT,
  version TEXT,
  publish_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME,
  resolved_at DATETIME,
  resolution_note TEXT,
  is_sticky INTEGER DEFAULT 0 CHECK (is_sticky IN (0, 1)),
  release_blog TEXT,
  created_by INTEGER,
  updated_by INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES library_users(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES library_users(id) ON DELETE SET NULL
);

-- Table: notification_event_targets
CREATE TABLE notification_event_targets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  target_type TEXT NOT NULL
    CHECK (target_type IN ('global', 'user', 'role', 'permission')),
  target_value TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES notification_events(id) ON DELETE CASCADE
);

-- Table: notification_event_acknowledgements
CREATE TABLE notification_event_acknowledgements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  acknowledged_at DATETIME,
  dismissed_at DATETIME,
  pinned_at DATETIME,
  metadata TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(event_id, user_id),
  FOREIGN KEY (event_id) REFERENCES notification_events(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: announcements
CREATE TABLE announcements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'info'
    CHECK (type IN ('info', 'success', 'warning', 'error', 'reminder')),
  priority TEXT NOT NULL DEFAULT 'normal'
    CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  target_users TEXT NOT NULL, -- JSON array or type string ('all', 'students', etc.)
  target_user_ids TEXT, -- JSON array of specific user IDs if custom targeting
  student_years TEXT, -- JSON array of year numbers if students-year targeting
  total_recipients INTEGER NOT NULL DEFAULT 0,
  notifications_created INTEGER NOT NULL DEFAULT 0,
  emails_sent INTEGER NOT NULL DEFAULT 0,
  errors_count INTEGER NOT NULL DEFAULT 0,
  error_details TEXT, -- JSON array of error messages
  action_url TEXT,
  metadata TEXT, -- JSON object for additional data
  sent_by INTEGER NOT NULL,
  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sent_by) REFERENCES library_users(id) ON DELETE SET NULL
);

-- Table: user_preferences
CREATE TABLE user_preferences (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  
  -- UI/Display Preferences
  theme_mode TEXT DEFAULT 'dark' CHECK (theme_mode IN ('light', 'dark', 'system')),
  font_size TEXT DEFAULT 'medium' CHECK (font_size IN ('small', 'medium', 'large', 'xlarge')),
  density TEXT DEFAULT 'comfortable' CHECK (density IN ('compact', 'comfortable', 'spacious')),
  sidebar_collapsed BOOLEAN DEFAULT FALSE,
  sidebar_width INTEGER DEFAULT 200,
  
  -- Data Display Preferences
  default_page_size INTEGER DEFAULT 20,
  table_column_visibility TEXT, -- JSON object: { "table_name": { "column": true/false } }
  default_sort_preferences TEXT, -- JSON object: { "table_name": { "field": "asc/desc" } }
  
  -- Accessibility Preferences
  high_contrast BOOLEAN DEFAULT FALSE,
  reduced_motion BOOLEAN DEFAULT FALSE,
  screen_reader_optimized BOOLEAN DEFAULT FALSE,
  
  -- Language/Locale Preferences
  language TEXT DEFAULT 'en',
  date_format TEXT DEFAULT 'MM/DD/YYYY',
  time_format TEXT DEFAULT '12h' CHECK (time_format IN ('12h', '24h')),
  timezone TEXT DEFAULT 'UTC',
  
  -- Dashboard Preferences
  dashboard_layout TEXT, -- JSON: widget positions, visibility
  dashboard_widgets TEXT, -- JSON: enabled/disabled widgets
  
  -- Search Preferences
  default_search_filters TEXT, -- JSON: saved filter presets
  search_history_enabled BOOLEAN DEFAULT TRUE,
  
  -- Metadata
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, academic_year TEXT, semester INTEGER CHECK (semester IS NULL OR (semester >= 1 AND semester <= 7)), table_view_preferences TEXT DEFAULT NULL,
  external_bookmark_links_notice_version INTEGER DEFAULT NULL,
  external_bookmark_links_notice_acknowledged_at DATETIME DEFAULT NULL,
  
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: reservations
CREATE TABLE reservations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  book_id INTEGER NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'ready', 'claimed', 'expired', 'cancelled')),
  position INTEGER, -- Queue position (1 = first in line)
  expires_at DATETIME, -- Reservation expiry (48 hours after becoming ready)
  notified_at DATETIME, -- When user was notified
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Table: citation_history
CREATE TABLE citation_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    source_type TEXT NOT NULL,
    format TEXT NOT NULL,
    source_data TEXT NOT NULL, -- JSON
    citation_text TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: saved_citations
CREATE TABLE saved_citations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    title TEXT NOT NULL,
    source_type TEXT NOT NULL,
    format TEXT NOT NULL,
    source_data TEXT NOT NULL, -- JSON
    citation_text TEXT NOT NULL,
    tags TEXT NOT NULL DEFAULT '[]', -- JSON array
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: plagiarism_checks
CREATE TABLE plagiarism_checks (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    title TEXT NOT NULL DEFAULT 'Untitled Document',
    content TEXT NOT NULL,
    similarity_percentage REAL NOT NULL CHECK (similarity_percentage >= 0 AND similarity_percentage <= 100),
    risk_level TEXT NOT NULL CHECK (risk_level IN ('low', 'medium', 'high', 'critical')),
    matches TEXT NOT NULL, -- JSON array of match objects
    sensitivity TEXT NOT NULL DEFAULT 'standard' CHECK (sensitivity IN ('low', 'standard', 'high', 'strict')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: d1_migrations
CREATE TABLE d1_migrations(
		id         INTEGER PRIMARY KEY AUTOINCREMENT,
		name       TEXT UNIQUE,
		applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Table: permission_audit_log
CREATE TABLE "permission_audit_log" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  changed_by INTEGER,
  role_id INTEGER NOT NULL,
  resource_id INTEGER NOT NULL,
  action_id INTEGER NOT NULL,
  old_value INTEGER,
  new_value INTEGER,
  reason TEXT,
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (changed_by) REFERENCES library_users(id) ON DELETE SET NULL,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (resource_id) REFERENCES permission_resources(id) ON DELETE CASCADE,
  FOREIGN KEY (action_id) REFERENCES permission_actions(id) ON DELETE CASCADE
);

-- Table: bookmarks
CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT,
  url TEXT NOT NULL,
  notes TEXT,
  type TEXT DEFAULT 'external' CHECK (type IN ('internal','external')),
  tags TEXT,
  folder TEXT,
  is_favorite INTEGER DEFAULT 0,
  is_pinned INTEGER DEFAULT 0,
  order_index INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, url),
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: user_tags
CREATE TABLE user_tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  normalized_name TEXT NOT NULL,
  usage_count INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, normalized_name),
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: bookmark_tags
CREATE TABLE bookmark_tags (
  bookmark_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(bookmark_id, tag_id),
  FOREIGN KEY (bookmark_id) REFERENCES bookmarks(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES user_tags(id) ON DELETE CASCADE
);

-- Table: sqlite_stat1
CREATE TABLE sqlite_stat1(tbl,idx,stat);

-- Table: mfa_challenge_tokens
CREATE TABLE mfa_challenge_tokens (
  jti TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  issued_at DATETIME NOT NULL,
  expires_at DATETIME NOT NULL,
  consumed_at DATETIME,
  attempts INTEGER DEFAULT 0,
  locked_until DATETIME,
  last_attempt_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: books_fts
CREATE VIRTUAL TABLE books_fts USING fts5(
  title,
  author_name
);

-- Table: books_fts_data
CREATE TABLE 'books_fts_data'(id INTEGER PRIMARY KEY, block BLOB);

-- Table: books_fts_idx
CREATE TABLE 'books_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;

-- Table: books_fts_content
CREATE TABLE 'books_fts_content'(id INTEGER PRIMARY KEY, c0, c1);

-- Table: books_fts_docsize
CREATE TABLE 'books_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);

-- Table: books_fts_config
CREATE TABLE 'books_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;

-- Table: mfa_backup_codes
CREATE TABLE mfa_backup_codes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  code_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  used_at DATETIME,
  used_from_ip TEXT,
  used_user_agent TEXT,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: mfa_trusted_devices
CREATE TABLE mfa_trusted_devices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  device_id TEXT NOT NULL,
  token_hash TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_used_at DATETIME,
  expires_at DATETIME NOT NULL,
  revoked_at DATETIME,
  ip_address TEXT,
  user_agent TEXT,
  device_info TEXT,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: webauthn_credentials
CREATE TABLE webauthn_credentials (
  id TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  credential_id TEXT NOT NULL,
  public_key TEXT NOT NULL,
  counter INTEGER NOT NULL DEFAULT 0,
  transports TEXT,
  device_name TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_used_at DATETIME,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: webauthn_challenges
CREATE TABLE webauthn_challenges (
  id TEXT PRIMARY KEY,
  user_id INTEGER NOT NULL,
  purpose TEXT NOT NULL,
  challenge TEXT NOT NULL,
  expires_at DATETIME NOT NULL,
  consumed_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: user_mfa_settings
CREATE TABLE "user_mfa_settings" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  mfa_enabled BOOLEAN DEFAULT FALSE,
  mfa_method TEXT DEFAULT 'totp' CHECK (mfa_method IN ('totp', 'sms', 'email')),
  totp_secret TEXT,
  totp_verified BOOLEAN DEFAULT FALSE,
  sms_phone TEXT,
  sms_verified BOOLEAN DEFAULT FALSE,
  email_verified BOOLEAN DEFAULT FALSE,
  backup_codes TEXT,
  backup_codes_used TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: mfa_verification_logs
CREATE TABLE "mfa_verification_logs" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  mfa_method TEXT NOT NULL CHECK (mfa_method IN ('totp', 'sms', 'email', 'backup', 'webauthn')),
  verification_code TEXT,
  success BOOLEAN DEFAULT FALSE,
  ip_address TEXT,
  user_agent TEXT,
  device_info TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: user_sessions
CREATE TABLE "user_sessions" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  session_token_hash TEXT UNIQUE NOT NULL,
  device_fingerprint TEXT,
  ip_address TEXT NOT NULL,
  user_agent TEXT NOT NULL,
  device_info TEXT,
  location_info TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  last_activity DATETIME DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  refresh_expires_at DATETIME,
  ended_at TEXT, remember BOOLEAN DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: email_confirmation_tokens
CREATE TABLE "email_confirmation_tokens" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  token TEXT UNIQUE NOT NULL,
  expires_at DATETIME NOT NULL,
  used_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: password_reset_tokens
CREATE TABLE "password_reset_tokens" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  token TEXT UNIQUE NOT NULL,
  expires_at DATETIME NOT NULL,
  used_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP, attempts INTEGER DEFAULT 0, locked_until DATETIME,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: otp_tokens
CREATE TABLE "otp_tokens" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  otp TEXT NOT NULL,
  purpose TEXT NOT NULL CHECK (
    purpose IN (
      'status_check',
      'password_reset',
      'email_verification',
      'mfa_disable',
      'mfa_email',
      'mfa_email_enroll',
      'webauthn_revoke'
    )
  ),
  expires_at DATETIME NOT NULL,
  used_at DATETIME,
  attempts INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: professors
CREATE TABLE professors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  department TEXT NOT NULL,
  specialization TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: action_logs
CREATE TABLE "action_logs" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  action_type TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id INTEGER,
  old_values TEXT,
  new_values TEXT,
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: migration_runs
CREATE TABLE migration_runs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      migration_name TEXT NOT NULL,
      status TEXT NOT NULL,
      executed_by TEXT,
      executed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      notes TEXT,
      metadata TEXT
    );

-- Table: subcategories
CREATE TABLE subcategories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  section_id INTEGER NOT NULL,
  resource_id INTEGER,
  code INTEGER NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'archived')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE RESTRICT,
  FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE SET NULL
);

-- Table: resource_download_sources
CREATE TABLE resource_download_sources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  resource_id INTEGER NOT NULL,
  source_type TEXT NOT NULL CHECK (source_type IN ('r2', 'mega', 'google_drive', 'external')),
  url TEXT,
  label TEXT NOT NULL,
  priority INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE
);

-- Table: resource_read_sessions
CREATE TABLE resource_read_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  resource_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  current_page INTEGER NOT NULL DEFAULT 0,
  total_pages INTEGER NOT NULL DEFAULT 0,
  reading_time_seconds INTEGER NOT NULL DEFAULT 0,
  last_read_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: resource_access_logs
CREATE TABLE resource_access_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  resource_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  action TEXT NOT NULL CHECK (action IN ('view', 'download')),
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: resources
CREATE TABLE "resources" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  resource_type_id INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'available', 'archived')),

  -- Digital file metadata
  storage_provider TEXT DEFAULT 'r2',
  r2_key TEXT,
  original_filename TEXT,
  mime_type TEXT,
  file_ext TEXT,
  size_bytes INTEGER,

  created_at DATETIME NOT NULL DEFAULT (datetime('now')),
  updated_at DATETIME NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (resource_type_id) REFERENCES resource_types(id) ON DELETE RESTRICT
);

-- Table: publications
CREATE TABLE "publications" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  publication_type TEXT NOT NULL CHECK (publication_type IN ('journal', 'conference', 'book', 'thesis', 'report')),
  url TEXT,
  abstract TEXT,
  keywords TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'archived')),
  email TEXT,
  phone TEXT,
  address TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: user_roles
CREATE TABLE user_roles (
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  assigned_by_user_id INTEGER,
  assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (assigned_by_user_id) REFERENCES library_users(id) ON DELETE SET NULL
);

-- Table: dashboard_configs
CREATE TABLE dashboard_configs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role TEXT NOT NULL UNIQUE, -- 'admin', 'librarian', 'dean', 'superuser', 'user'
  config TEXT NOT NULL, -- JSON serialized DashboardConfig
  is_active INTEGER NOT NULL DEFAULT 1, -- 1 = active, 0 = inactive (use static fallback)
  updated_by INTEGER NOT NULL, -- user_id of the person who made the change
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  
  FOREIGN KEY (updated_by) REFERENCES library_users(id) ON DELETE RESTRICT,
  
  -- Ensure role is valid
  CHECK (role IN ('admin', 'librarian', 'dean', 'superuser', 'user')),
  CHECK (is_active IN (0, 1))
);

-- Table: dashboard_config_audit
CREATE TABLE dashboard_config_audit (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role TEXT NOT NULL,
  config_before TEXT, -- Previous config (NULL for first version)
  config_after TEXT NOT NULL, -- New config
  changed_by INTEGER NOT NULL,
  change_type TEXT NOT NULL, -- 'create', 'update', 'activate', 'deactivate', 'reset'
  change_notes TEXT, -- Optional description of changes
  changed_at TEXT NOT NULL DEFAULT (datetime('now')),
  
  FOREIGN KEY (changed_by) REFERENCES library_users(id) ON DELETE RESTRICT,
  
  CHECK (change_type IN ('create', 'update', 'activate', 'deactivate', 'reset'))
);

-- Table: order_priority_policy_config
CREATE TABLE order_priority_policy_config (
  id INTEGER PRIMARY KEY NOT NULL CHECK (id = 1),
  trust_badge_keys TEXT NOT NULL,
  urgent_badge_keys TEXT NOT NULL,
  demote_if_pending_penalties INTEGER NOT NULL DEFAULT 1 CHECK (demote_if_pending_penalties IN (0, 1)),
  demote_if_overdue_loans INTEGER NOT NULL DEFAULT 1 CHECK (demote_if_overdue_loans IN (0, 1)),
  version INTEGER NOT NULL DEFAULT 1,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_by INTEGER NULL
);

-- Table: book_reviews
CREATE TABLE "book_reviews" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  review_text TEXT,
  title TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  edit_count INTEGER DEFAULT 0,
  max_edits INTEGER DEFAULT 2,
  approved_by INTEGER,
  approved_at DATETIME,
  rejected_by INTEGER,
  rejected_at DATETIME,
  rejection_reason TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES library_users(id),
  FOREIGN KEY (rejected_by) REFERENCES library_users(id),
  UNIQUE(book_id, user_id)
);

-- Table: book_views
CREATE TABLE "book_views" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  view_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  view_count INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: emergency_access
CREATE TABLE "emergency_access" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  requester_id INTEGER NOT NULL,
  target_user_id INTEGER NOT NULL,
  reason TEXT NOT NULL,
  approved_by INTEGER,
  approved_at DATETIME,
  rejected_by INTEGER,
  rejected_at DATETIME,
  rejection_reason TEXT,
  expires_at DATETIME NOT NULL,
  is_active INTEGER DEFAULT 1 CHECK (is_active IN (0, 1)),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'expired', 'revoked')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (requester_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (target_user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES library_users(id) ON DELETE SET NULL,
  FOREIGN KEY (rejected_by) REFERENCES library_users(id) ON DELETE SET NULL
);

-- Table: loans
CREATE TABLE "loans" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER REFERENCES library_users(id),
  book_copy_id INTEGER REFERENCES book_copies(id),
  borrowed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  due_date DATETIME,
  returned_at DATETIME,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'returned', 'overdue')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  renewed_count INTEGER DEFAULT 0,
  order_id INTEGER,
  reservation_id INTEGER,
  renewal_request_status TEXT CHECK (renewal_request_status IN ('pending', 'rejected')), renewal_requested_at DATETIME, renewal_reviewed_at DATETIME, renewal_reviewed_by INTEGER REFERENCES library_users(id),
  FOREIGN KEY (user_id) REFERENCES library_users(id),
  FOREIGN KEY (book_copy_id) REFERENCES book_copies(id)
);

-- Table: notifications
CREATE TABLE "notifications" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error', 'reminder')),
  priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  is_read BOOLEAN DEFAULT FALSE,
  action_url TEXT,
  metadata TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: orders
CREATE TABLE "orders" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_number TEXT NOT NULL UNIQUE,
  user_id INTEGER NOT NULL,
  book_id INTEGER,
  title TEXT NOT NULL,
  author TEXT,
  isbn TEXT,
  order_type TEXT NOT NULL DEFAULT 'request' CHECK (order_type IN ('request')),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'completed', 'cancelled')),
  quantity INTEGER DEFAULT 1,
  estimated_cost DECIMAL(10,2),
  notes TEXT,
  approved_by INTEGER,
  approved_at DATETIME,
  rejected_by INTEGER,
  rejected_at DATETIME,
  rejection_reason TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  priority TEXT NOT NULL DEFAULT 'normal',
  priority_reason TEXT,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE SET NULL,
  FOREIGN KEY (approved_by) REFERENCES library_users(id),
  FOREIGN KEY (rejected_by) REFERENCES library_users(id)
);

-- Table: payments
CREATE TABLE "payments" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  penalty_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  upi_id VARCHAR(100) NOT NULL,
  payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('upi_id', 'upi_barcode')),
  user_email VARCHAR(255) NOT NULL,
  user_phone VARCHAR(20) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
  transaction_id VARCHAR(100),
  receipt_id VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  completed_at DATETIME,
  FOREIGN KEY (penalty_id) REFERENCES penalties(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: penalties
CREATE TABLE "penalties" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  loan_id INTEGER,
  penalty_type TEXT NOT NULL CHECK (penalty_type IN ('overdue', 'damage', 'loss', 'violation')),
  amount DECIMAL(10,2) NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'waived', 'cancelled')),
  due_date DATETIME,
  paid_at DATETIME,
  waived_by INTEGER,
  waived_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE SET NULL,
  FOREIGN KEY (waived_by) REFERENCES library_users(id)
);

-- Table: receipts
CREATE TABLE "receipts" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  payment_id INTEGER NOT NULL,
  penalty_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  user_email VARCHAR(255) NOT NULL,
  upi_id VARCHAR(100) NOT NULL,
  transaction_id VARCHAR(100),
  receipt_number VARCHAR(100) NOT NULL UNIQUE,
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE,
  FOREIGN KEY (penalty_id) REFERENCES penalties(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: superuser_actions
CREATE TABLE "superuser_actions" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  superuser_id INTEGER NOT NULL,
  action_type TEXT NOT NULL,
  target_user_id INTEGER,
  target_table TEXT,
  target_record_id INTEGER,
  action_details TEXT,
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (superuser_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (target_user_id) REFERENCES library_users(id) ON DELETE SET NULL
);

-- Table: trusted_devices
CREATE TABLE "trusted_devices" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  device_name TEXT NOT NULL,
  device_fingerprint TEXT NOT NULL,
  device_type TEXT CHECK (device_type IN ('mobile', 'desktop', 'tablet')),
  browser_info TEXT,
  os_info TEXT,
  ip_address TEXT,
  location_info TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  last_used DATETIME DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: user_notification_preferences
CREATE TABLE "user_notification_preferences" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  order_notifications BOOLEAN DEFAULT TRUE,
  system_notifications BOOLEAN DEFAULT TRUE,
  loan_notifications BOOLEAN DEFAULT TRUE,
  email_notifications BOOLEAN DEFAULT TRUE,
  in_app_notifications BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: wishlist
CREATE TABLE "wishlist" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  book_id INTEGER,
  title TEXT NOT NULL,
  author TEXT,
  isbn TEXT,
  notes TEXT,
  priority INTEGER DEFAULT 1 CHECK (priority >= 1 AND priority <= 5),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'acquired', 'removed')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE SET NULL
);

-- Table: user_notification_state
CREATE TABLE user_notification_state (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  system_notifications_seen_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- Table: journal_sections
CREATE TABLE journal_sections (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  section_no INTEGER NOT NULL UNIQUE CHECK (section_no >= 1 AND section_no <= 25),
  section_label TEXT NOT NULL UNIQUE,
  sort_order INTEGER NOT NULL UNIQUE CHECK (sort_order >= 1 AND sort_order <= 25),
  is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: journals
CREATE TABLE "journals" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  series_id INTEGER,
  section_id INTEGER,
  volume INTEGER,
  index_rate TEXT,
  month TEXT,
  year TEXT,
  cadence TEXT DEFAULT 'annual' CHECK (cadence IN ('annual','biannual','quarterly','monthly','custom')),
  status TEXT DEFAULT 'active' CHECK (status IN ('active','inactive','archived')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (series_id) REFERENCES journals(id) ON DELETE CASCADE,
  FOREIGN KEY (section_id) REFERENCES journal_sections(id) ON DELETE SET NULL
);

-- Table: journal_authors_unmatched
CREATE TABLE journal_authors_unmatched(
  id INT,
  article_id INT,
  author_name TEXT,
  author_id INT
);

-- Table: journal_authors
CREATE TABLE "journal_authors" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  article_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (article_id) REFERENCES journal_articles(id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE,
  UNIQUE(article_id, author_id)
);

-- Table: locations
CREATE TABLE locations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  code TEXT UNIQUE,
  description TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: shelf_codes
CREATE TABLE shelf_codes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL,
  description TEXT,
  section_id INTEGER NOT NULL,
  capacity INTEGER,
  key_tag_id INTEGER REFERENCES key_tags(id),
  book_range_start TEXT,
  book_range_end TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE,
  UNIQUE(section_id, code)
);

-- Table: key_tags
CREATE TABLE key_tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  code TEXT NOT NULL UNIQUE,
  description TEXT,
  bidn TEXT,
  key_type TEXT NOT NULL DEFAULT 'shelf' CHECK (key_type IN ('shelf', 'section', 'master')),
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: book_copies
CREATE TABLE "book_copies" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER REFERENCES books(id),
  copy_number INTEGER,
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'borrowed', 'lost', 'damaged', 'under_maintenance', 'ordered', 'deprecate')),
  location TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME,
  copy_code TEXT,
  section_id INTEGER
);

-- Table: reference_resources
CREATE TABLE "reference_resources" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  resource_type_id INTEGER NOT NULL,
  section_id INTEGER NOT NULL,
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'in_use', 'under_maintenance', 'lost', 'deprecated')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: user_types
CREATE TABLE user_types (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  label TEXT NOT NULL,
  category TEXT NOT NULL,
  default_role_id INTEGER REFERENCES roles(id),
  is_active BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: borrow_limits
CREATE TABLE borrow_limits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_type_id INTEGER NOT NULL REFERENCES user_types(id),
  variant TEXT NOT NULL DEFAULT 'default',
  max_books INTEGER NOT NULL CHECK (max_books > 0),
  loan_period_days INTEGER NOT NULL CHECK (loan_period_days > 0),
  max_renewals INTEGER NOT NULL CHECK (max_renewals >= 0),
  fine_per_day REAL NOT NULL DEFAULT 0 CHECK (fine_per_day >= 0),
  is_active BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_type_id, variant)
);

-- Indexes / Triggers / Views
CREATE INDEX idx_books_author_id ON books(author_id);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_authors_name ON authors(last_name, first_name);
CREATE INDEX idx_system_logs_timestamp ON system_logs(timestamp);
CREATE INDEX idx_system_logs_level ON system_logs(level);
CREATE INDEX idx_system_logs_created_at ON system_logs(created_at);
CREATE INDEX idx_rate_limits_key_time ON rate_limits(rate_key, created_at);
CREATE INDEX idx_rate_limits_created_at ON rate_limits(created_at);
CREATE INDEX idx_roles_name_lower ON roles(LOWER(name));
CREATE INDEX idx_permission_resources_name_lower ON permission_resources(LOWER(resource_name));
CREATE INDEX idx_permission_actions_name_lower ON permission_actions(LOWER(action_name));
CREATE INDEX idx_sections_name ON sections(name);
CREATE INDEX idx_journal_articles_journal_id ON journal_articles(journal_id);
CREATE TRIGGER update_sections_timestamp 
  AFTER UPDATE ON sections
  FOR EACH ROW
BEGIN
  UPDATE sections SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_journal_articles_timestamp 
  AFTER UPDATE ON journal_articles
  FOR EACH ROW
BEGIN
  UPDATE journal_articles SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_resource_types_section_id ON resource_types(section_id);
CREATE INDEX idx_resource_types_name ON resource_types(name);
CREATE INDEX idx_resource_download_sources_resource_id ON resource_download_sources(resource_id);
CREATE INDEX idx_resource_download_sources_active_priority ON resource_download_sources(is_active, priority);
CREATE TRIGGER update_resource_download_sources_timestamp
  AFTER UPDATE ON resource_download_sources
  FOR EACH ROW
BEGIN
  UPDATE resource_download_sources SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE UNIQUE INDEX idx_resource_read_sessions_user_resource ON resource_read_sessions(resource_id, user_id);
CREATE INDEX idx_resource_read_sessions_last_read ON resource_read_sessions(last_read_at);
CREATE INDEX idx_resource_read_sessions_status ON resource_read_sessions(status);
CREATE TRIGGER update_resource_read_sessions_timestamp
  AFTER UPDATE ON resource_read_sessions
  FOR EACH ROW
BEGIN
  UPDATE resource_read_sessions SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_reference_categories_parent_id ON reference_categories(parent_id);
CREATE INDEX idx_reference_categories_name ON reference_categories(name);
CREATE INDEX idx_reference_books_reference_id ON reference_books(reference_id);
CREATE INDEX idx_reference_books_author_id ON reference_books(author_id);
CREATE INDEX idx_reference_books_section_id ON reference_books(section_id);
CREATE INDEX idx_reference_books_resource_type_id ON reference_books(resource_type_id);
CREATE INDEX idx_reference_books_category_id ON reference_books(category_id);
CREATE INDEX idx_reference_books_status ON reference_books(book_status);
CREATE TRIGGER update_resource_types_timestamp 
  AFTER UPDATE ON resource_types
  FOR EACH ROW
BEGIN
  UPDATE resource_types SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_reference_categories_timestamp 
  AFTER UPDATE ON reference_categories
  FOR EACH ROW
BEGIN
  UPDATE reference_categories SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_reference_books_timestamp 
  AFTER UPDATE ON reference_books
  FOR EACH ROW
BEGIN
  UPDATE reference_books SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_help_content_category ON help_content(category);
CREATE INDEX idx_help_content_roles ON help_content(roles);
CREATE INDEX idx_help_content_difficulty ON help_content(difficulty);
CREATE INDEX idx_help_content_created_at ON help_content(created_at);
CREATE TRIGGER update_help_content_updated_at 
    AFTER UPDATE ON help_content
    FOR EACH ROW
    BEGIN
        UPDATE help_content SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;
CREATE INDEX idx_reference_sections_name ON reference_sections(name);
CREATE TRIGGER update_reference_sections_timestamp 
  AFTER UPDATE ON reference_sections
  FOR EACH ROW
BEGIN
  UPDATE reference_sections SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_superuser_permissions_is_active ON superuser_permissions(is_active);
CREATE INDEX idx_superuser_permissions_category ON superuser_permissions(category);
CREATE INDEX idx_badges_is_active ON badges(is_active);
CREATE INDEX idx_badges_visibility ON badges(visibility);
CREATE INDEX idx_badges_level ON badges(level);
CREATE TRIGGER trg_badges_update_timestamp
AFTER UPDATE ON badges
FOR EACH ROW
BEGIN
  UPDATE badges SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX idx_user_badges_awarded_at ON user_badges(awarded_at);
CREATE INDEX idx_user_badges_expires_at ON user_badges(expires_at);
CREATE INDEX idx_user_badges_revoked ON user_badges(is_revoked);
CREATE TRIGGER trg_user_badges_revoke_timestamp
AFTER UPDATE ON user_badges
FOR EACH ROW
WHEN NEW.is_revoked = 1 AND OLD.is_revoked = 0 AND NEW.revoked_at IS NULL
BEGIN
  UPDATE user_badges SET revoked_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_role_badges_role ON role_badges(role);
CREATE INDEX idx_guests_user_id ON guests(user_id);
CREATE UNIQUE INDEX idx_library_users_email_unique ON library_users(email);
CREATE UNIQUE INDEX idx_user_badges_user_badge_period
  ON user_badges(user_id, badge_id, period_key)
  WHERE period_key IS NOT NULL;
CREATE INDEX idx_notification_events_category ON notification_events(category);
CREATE INDEX idx_notification_events_scope ON notification_events(scope);
CREATE INDEX idx_notification_events_status ON notification_events(status);
CREATE INDEX idx_notification_events_publish_at ON notification_events(publish_at DESC);
CREATE INDEX idx_notification_event_targets_event_id
  ON notification_event_targets(event_id);
CREATE INDEX idx_notification_event_targets_type_value
  ON notification_event_targets(target_type, target_value);
CREATE INDEX idx_notification_event_ack_event_id
  ON notification_event_acknowledgements(event_id);
CREATE INDEX idx_notification_event_ack_user_id
  ON notification_event_acknowledgements(user_id);
CREATE INDEX idx_announcements_sent_by ON announcements(sent_by);
CREATE INDEX idx_announcements_sent_at ON announcements(sent_at DESC);
CREATE INDEX idx_announcements_type ON announcements(type);
CREATE INDEX idx_announcements_priority ON announcements(priority);
CREATE TRIGGER update_announcements_timestamp 
  AFTER UPDATE ON announcements
  FOR EACH ROW
BEGIN
  UPDATE announcements SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);
CREATE TRIGGER update_user_preferences_timestamp 
  AFTER UPDATE ON user_preferences
  FOR EACH ROW
BEGIN
  UPDATE user_preferences SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_reservations_user_id ON reservations(user_id);
CREATE INDEX idx_reservations_book_id ON reservations(book_id);
CREATE INDEX idx_reservations_status ON reservations(status);
CREATE INDEX idx_reservations_position ON reservations(book_id, position);
CREATE INDEX idx_reservations_expires_at ON reservations(expires_at);
CREATE INDEX idx_reservations_user_book_status ON reservations(user_id, book_id, status);
CREATE UNIQUE INDEX idx_reservations_user_book_active 
ON reservations(user_id, book_id) 
WHERE status IN ('pending', 'ready');
CREATE TRIGGER update_reservations_timestamp 
AFTER UPDATE ON reservations
FOR EACH ROW
BEGIN
  UPDATE reservations SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_user_preferences_academic_year ON user_preferences(academic_year);
CREATE INDEX idx_user_preferences_semester ON user_preferences(semester);
CREATE INDEX idx_citation_history_user_id ON citation_history(user_id);
CREATE INDEX idx_citation_history_created_at ON citation_history(created_at DESC);
CREATE INDEX idx_citation_history_format ON citation_history(format);
CREATE INDEX idx_citation_history_source_type ON citation_history(source_type);
CREATE INDEX idx_saved_citations_user_id ON saved_citations(user_id);
CREATE INDEX idx_saved_citations_created_at ON saved_citations(created_at DESC);
CREATE INDEX idx_saved_citations_format ON saved_citations(format);
CREATE INDEX idx_saved_citations_source_type ON saved_citations(source_type);
CREATE INDEX idx_plagiarism_checks_user_id ON plagiarism_checks(user_id);
CREATE INDEX idx_plagiarism_checks_created_at ON plagiarism_checks(created_at DESC);
CREATE INDEX idx_plagiarism_checks_risk_level ON plagiarism_checks(risk_level);
CREATE INDEX idx_permission_audit_log_created_at
  ON permission_audit_log (created_at DESC);
CREATE INDEX idx_bookmarks_user_id ON bookmarks(user_id);
CREATE INDEX idx_bookmarks_url ON bookmarks(url);
CREATE INDEX idx_bookmarks_fav_pin ON bookmarks(user_id, is_pinned, is_favorite);
CREATE INDEX idx_user_tags_user_id ON user_tags(user_id);
CREATE INDEX idx_user_tags_normalized ON user_tags(user_id, normalized_name);
CREATE INDEX idx_bookmark_tags_bookmark_id ON bookmark_tags(bookmark_id);
CREATE INDEX idx_bookmark_tags_tag_id ON bookmark_tags(tag_id);
CREATE TRIGGER trg_bookmark_tags_insert AFTER INSERT ON bookmark_tags
BEGIN
  UPDATE user_tags
    SET usage_count = usage_count + 1,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.tag_id;
END;
CREATE TRIGGER trg_bookmark_tags_delete AFTER DELETE ON bookmark_tags
BEGIN
  UPDATE user_tags
    SET usage_count = CASE WHEN usage_count > 0 THEN usage_count - 1 ELSE 0 END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = OLD.tag_id;
END;
CREATE INDEX idx_library_users_lower_email ON library_users(LOWER(email));
CREATE INDEX idx_students_user_id ON students(user_id);
CREATE UNIQUE INDEX idx_students_user_id_unique ON students(user_id);
CREATE INDEX idx_bookmarks_user_id_url ON bookmarks(user_id, url);
CREATE INDEX idx_bookmarks_user_search ON bookmarks(user_id, title, url, notes);
CREATE INDEX idx_bookmarks_user_type ON bookmarks(user_id, type);
CREATE INDEX idx_bookmarks_user_favorite ON bookmarks(user_id, is_favorite);
CREATE INDEX idx_bookmarks_user_pinned ON bookmarks(user_id, is_pinned);
CREATE INDEX idx_bookmarks_user_folder ON bookmarks(user_id, folder);
CREATE INDEX idx_bookmarks_updated_at ON bookmarks(updated_at DESC);
CREATE INDEX idx_user_tags_user_normalized ON user_tags(user_id, normalized_name);
CREATE INDEX idx_bookmark_tags_bookmark ON bookmark_tags(bookmark_id);
CREATE INDEX idx_bookmark_tags_tag ON bookmark_tags(tag_id);
CREATE INDEX idx_bookmark_tags_join ON bookmark_tags(bookmark_id, tag_id);
CREATE INDEX idx_user_tags_usage ON user_tags(user_id, usage_count DESC);
CREATE INDEX idx_mfa_challenge_tokens_user_id ON mfa_challenge_tokens(user_id);
CREATE INDEX idx_mfa_challenge_tokens_expires_at ON mfa_challenge_tokens(expires_at);
CREATE UNIQUE INDEX idx_mfa_backup_codes_user_hash
ON mfa_backup_codes(user_id, code_hash);
CREATE INDEX idx_mfa_backup_codes_user_unused
ON mfa_backup_codes(user_id, used_at);
CREATE UNIQUE INDEX idx_mfa_trusted_devices_user_device
ON mfa_trusted_devices(user_id, device_id);
CREATE INDEX idx_mfa_trusted_devices_user_expires
ON mfa_trusted_devices(user_id, expires_at);
CREATE UNIQUE INDEX idx_webauthn_credentials_credential_id
ON webauthn_credentials(credential_id);
CREATE INDEX idx_webauthn_credentials_user
ON webauthn_credentials(user_id);
CREATE INDEX idx_webauthn_challenges_user_purpose
ON webauthn_challenges(user_id, purpose);
CREATE INDEX idx_webauthn_challenges_expires
ON webauthn_challenges(expires_at);
CREATE INDEX idx_user_mfa_settings_user_id ON user_mfa_settings(user_id);
CREATE INDEX idx_mfa_verification_logs_user_created ON mfa_verification_logs(user_id, created_at);
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_session_token_hash ON user_sessions(session_token_hash);
CREATE INDEX idx_user_sessions_is_active ON user_sessions(is_active);
CREATE INDEX idx_user_sessions_expires_at ON user_sessions(expires_at);
CREATE INDEX idx_email_confirmation_tokens_token ON email_confirmation_tokens(token);
CREATE INDEX idx_email_confirmation_tokens_expires_at ON email_confirmation_tokens(expires_at);
CREATE INDEX idx_email_confirmation_tokens_user_id ON email_confirmation_tokens(user_id);
CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens(token);
CREATE INDEX idx_password_reset_tokens_expires_at ON password_reset_tokens(expires_at);
CREATE INDEX idx_password_reset_tokens_user_id ON password_reset_tokens(user_id);
CREATE INDEX idx_user_sessions_remember ON user_sessions(remember);
CREATE INDEX idx_otp_tokens_email_purpose ON otp_tokens(email, purpose);
CREATE INDEX idx_otp_tokens_expires_at ON otp_tokens(expires_at);
CREATE INDEX idx_password_reset_tokens_locked_until ON password_reset_tokens(locked_until);
CREATE INDEX idx_professors_user_id ON professors(user_id);
CREATE INDEX idx_professors_department ON professors(department);
CREATE INDEX idx_professors_specialization ON professors(specialization);
CREATE INDEX idx_action_logs_user_id_created_at ON action_logs(user_id, created_at);
CREATE INDEX idx_migration_runs_migration_name
    ON migration_runs (migration_name, executed_at DESC)
  ;
CREATE UNIQUE INDEX idx_sections_code_unique
  ON sections(code)
  WHERE code IS NOT NULL;
CREATE UNIQUE INDEX idx_subcategories_section_code_unique
  ON subcategories(section_id, code);
CREATE UNIQUE INDEX idx_subcategories_section_name_unique
  ON subcategories(section_id, name);
CREATE INDEX idx_subcategories_section_id
  ON subcategories(section_id);
CREATE INDEX idx_subcategories_resource_id
  ON subcategories(resource_id);
CREATE INDEX idx_books_subcategory_id
  ON books(subcategory_id);
CREATE UNIQUE INDEX idx_books_base_code_unique
  ON books(base_code)
  WHERE base_code IS NOT NULL;
CREATE INDEX idx_resource_access_logs_resource_id_created_at
  ON resource_access_logs(resource_id, created_at);
CREATE INDEX idx_resource_access_logs_user_id_created_at
  ON resource_access_logs(user_id, created_at);
CREATE INDEX idx_resources_resource_type_id ON resources(resource_type_id);
CREATE INDEX idx_resources_status ON resources(status);
CREATE INDEX idx_resources_name ON resources(name);
CREATE INDEX idx_resources_created_at ON resources(created_at);
CREATE INDEX idx_resources_r2_key ON resources(r2_key);
CREATE TRIGGER trigger_resources_update_timestamp
AFTER UPDATE ON resources
FOR EACH ROW
BEGIN
  UPDATE resources SET updated_at = datetime('now') WHERE id = NEW.id;
END;
CREATE INDEX idx_publications_title ON publications(title);
CREATE INDEX idx_publications_email ON publications(email);
CREATE TRIGGER books_ai AFTER INSERT ON books BEGIN
  INSERT INTO books_fts(rowid, title, author_name)
  SELECT b.id, b.title, a.first_name || ' ' || a.last_name
  FROM books b
  LEFT JOIN authors a ON b.author_id = a.id
  WHERE b.id = NEW.id;
END;
CREATE TRIGGER books_ad AFTER DELETE ON books BEGIN
  DELETE FROM books_fts WHERE rowid = OLD.id;
END;
CREATE TRIGGER books_au AFTER UPDATE ON books BEGIN
  DELETE FROM books_fts WHERE rowid = OLD.id;

  INSERT INTO books_fts(rowid, title, author_name)
  SELECT b.id, b.title, a.first_name || ' ' || a.last_name
  FROM books b
  LEFT JOIN authors a ON b.author_id = a.id
  WHERE b.id = NEW.id;
END;
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);
CREATE INDEX idx_system_logs_level_created_at 
ON system_logs(level, created_at);
CREATE INDEX idx_dashboard_configs_role ON dashboard_configs(role);
CREATE INDEX idx_dashboard_configs_active ON dashboard_configs(role, is_active);
CREATE INDEX idx_dashboard_config_audit_role ON dashboard_config_audit(role);
CREATE INDEX idx_dashboard_config_audit_changed_by ON dashboard_config_audit(changed_by);
CREATE INDEX idx_dashboard_config_audit_changed_at ON dashboard_config_audit(changed_at DESC);
CREATE TRIGGER trg_dashboard_configs_audit_insert
AFTER INSERT ON dashboard_configs
FOR EACH ROW
BEGIN
  INSERT INTO dashboard_config_audit (role, config_before, config_after, changed_by, change_type)
  VALUES (NEW.role, NULL, NEW.config, NEW.updated_by, 'create');
END;
CREATE TRIGGER trg_dashboard_configs_audit_update
AFTER UPDATE ON dashboard_configs
FOR EACH ROW
BEGIN
  INSERT INTO dashboard_config_audit (role, config_before, config_after, changed_by, change_type)
  VALUES (
    NEW.role, 
    OLD.config, 
    NEW.config, 
    NEW.updated_by,
    CASE 
      WHEN OLD.is_active = 1 AND NEW.is_active = 0 THEN 'deactivate'
      WHEN OLD.is_active = 0 AND NEW.is_active = 1 THEN 'activate'
      ELSE 'update'
    END
  );
END;
CREATE INDEX idx_user_notification_state_user_id ON user_notification_state(user_id);
CREATE INDEX idx_journals_series_id ON journals(series_id);
CREATE INDEX idx_journals_section_id ON journals(section_id);
CREATE INDEX idx_journals_status ON journals(status);
CREATE INDEX idx_journals_created_at ON journals(created_at);
CREATE INDEX idx_journal_authors_article_id ON journal_authors(article_id);
CREATE INDEX idx_journal_authors_author_id ON journal_authors(author_id);
CREATE INDEX idx_loans_renewal_request_status ON loans(renewal_request_status);
CREATE INDEX idx_loans_renewal_reviewed_by ON loans(renewal_reviewed_by);
CREATE INDEX idx_loans_reservation_id ON loans(reservation_id);
CREATE UNIQUE INDEX idx_loans_reservation_id_unique ON loans(reservation_id) WHERE reservation_id IS NOT NULL;
CREATE UNIQUE INDEX idx_reservations_active_position ON reservations(book_id, position) WHERE status IN ('pending', 'ready');
CREATE INDEX idx_locations_is_active ON locations(is_active);
CREATE INDEX idx_locations_code ON locations(code);
CREATE INDEX idx_shelf_codes_section_id ON shelf_codes(section_id);
CREATE INDEX idx_shelf_codes_is_active ON shelf_codes(is_active);
CREATE UNIQUE INDEX idx_shelf_codes_key_tag_id ON shelf_codes(key_tag_id);
CREATE INDEX idx_shelf_codes_book_range ON shelf_codes(book_range_start, book_range_end);
CREATE INDEX idx_key_tags_is_active ON key_tags(is_active);
CREATE INDEX idx_key_tags_code ON key_tags(code);
CREATE INDEX idx_key_tags_key_type ON key_tags(key_type);
CREATE INDEX idx_key_tags_bidn ON key_tags(bidn);
CREATE INDEX idx_book_copies_book_id ON book_copies(book_id);
CREATE INDEX idx_book_copies_book_id_status ON book_copies(book_id, status);
CREATE UNIQUE INDEX idx_book_copies_copy_code_unique
  ON book_copies(copy_code)
  WHERE copy_code IS NOT NULL;
CREATE INDEX idx_book_copies_section_id ON book_copies(section_id);
CREATE INDEX idx_book_copies_status ON book_copies(status);
CREATE TRIGGER update_book_copies_timestamp
  AFTER UPDATE ON book_copies
  FOR EACH ROW
BEGIN
  UPDATE book_copies SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE VIEW books_with_authors AS
SELECT
  b.*,
  a.first_name as author_first_name,
  a.last_name as author_last_name,
  COUNT(bc.id) as total_copies,
  COUNT(CASE WHEN bc.status = 'available' THEN 1 END) as available_copies
FROM books b
LEFT JOIN authors a ON b.author_id = a.id
LEFT JOIN book_copies bc ON b.id = bc.book_id
GROUP BY b.id, a.id;
CREATE VIEW active_loans AS
SELECT
  l.*,
  b.title as book_title,
  a.first_name as author_first_name,
  a.last_name as author_last_name,
  u.first_name as user_first_name,
  u.last_name as user_last_name,
  u.email as user_email,
  bc.copy_number
FROM loans l
JOIN book_copies bc ON l.book_copy_id = bc.id
JOIN books b ON bc.book_id = b.id
JOIN authors a ON b.author_id = a.id
JOIN library_users u ON l.user_id = u.id
WHERE l.status = 'active';
CREATE VIEW overdue_books AS
SELECT
  l.*,
  b.title as book_title,
  a.first_name as author_first_name,
  a.last_name as author_last_name,
  u.first_name as user_first_name,
  u.last_name as user_last_name,
  u.email as user_email,
  bc.copy_number,
  JULIANDAY(CURRENT_TIMESTAMP) - JULIANDAY(l.due_date) as days_overdue
FROM loans l
JOIN book_copies bc ON l.book_copy_id = bc.id
JOIN books b ON bc.book_id = b.id
JOIN authors a ON b.author_id = a.id
JOIN library_users u ON l.user_id = u.id
WHERE l.status = 'active' AND l.due_date < CURRENT_TIMESTAMP;
CREATE INDEX idx_sections_location_id ON sections(location_id);
CREATE INDEX idx_reference_resources_name ON reference_resources(name);
CREATE INDEX idx_reference_resources_resource_type_id ON reference_resources(resource_type_id);
CREATE INDEX idx_reference_resources_section_id ON reference_resources(section_id);
CREATE INDEX idx_reference_resources_status ON reference_resources(status);
CREATE INDEX idx_reference_resources_section_status ON reference_resources(section_id, status);
CREATE TRIGGER update_reference_resources_timestamp
  AFTER UPDATE ON reference_resources
  FOR EACH ROW
BEGIN
  UPDATE reference_resources SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_library_users_user_type_id ON library_users(user_type_id);
CREATE INDEX idx_user_types_category ON user_types(category);
CREATE INDEX idx_user_types_is_active ON user_types(is_active);
CREATE INDEX idx_borrow_limits_user_type_id ON borrow_limits(user_type_id);
CREATE INDEX idx_borrow_limits_variant ON borrow_limits(variant);
CREATE INDEX idx_borrow_limits_is_active ON borrow_limits(is_active);
