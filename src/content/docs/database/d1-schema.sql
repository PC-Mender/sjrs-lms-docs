-- Consolidated schema backup generated: 2025-11-11T12-17-44
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
);

-- Table: book_copies
CREATE TABLE book_copies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER REFERENCES books(id),
  copy_number INTEGER,
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'borrowed', 'lost', 'damaged')),
  location TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
, updated_at DATETIME);

-- Table: loans
CREATE TABLE loans (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER REFERENCES "library_users_migration_temp2"(id),
  book_copy_id INTEGER REFERENCES book_copies(id),
  borrowed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  due_date DATETIME,
  returned_at DATETIME,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'returned', 'overdue')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
, updated_at DATETIME);

-- Table: books_fts
CREATE VIRTUAL TABLE books_fts USING fts5(
  title,
  author_name,
  content='books',
  content_rowid='id'
);

-- Table: books_fts_data
CREATE TABLE 'books_fts_data'(id INTEGER PRIMARY KEY, block BLOB);

-- Table: books_fts_idx
CREATE TABLE 'books_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;

-- Table: books_fts_docsize
CREATE TABLE 'books_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);

-- Table: books_fts_config
CREATE TABLE 'books_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;

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

-- Table: permission_audit_log
CREATE TABLE permission_audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  changed_by INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  resource_id INTEGER NOT NULL,
  action_id INTEGER NOT NULL,
  old_value INTEGER,
  new_value INTEGER,
  reason TEXT,
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (changed_by) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (resource_id) REFERENCES permission_resources(id) ON DELETE CASCADE,
  FOREIGN KEY (action_id) REFERENCES permission_actions(id) ON DELETE CASCADE
);

-- Table: email_confirmation_tokens
CREATE TABLE email_confirmation_tokens (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, token TEXT UNIQUE NOT NULL, expires_at DATETIME NOT NULL, used_at DATETIME, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE);

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

-- Table: password_reset_tokens
CREATE TABLE password_reset_tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  token TEXT UNIQUE NOT NULL,
  expires_at DATETIME NOT NULL,
  used_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: action_logs
CREATE TABLE action_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        action_type TEXT NOT NULL,
        table_name TEXT NOT NULL,
        record_id INTEGER,
        old_values TEXT,
        new_values TEXT,
        ip_address TEXT,
        user_agent TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
      );

-- Table: user_sessions
CREATE TABLE user_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        session_token TEXT UNIQUE NOT NULL,
        ip_address TEXT NOT NULL,
        user_agent TEXT NOT NULL,
        device_info TEXT,
        location_info TEXT,
        is_active BOOLEAN DEFAULT TRUE,
        last_activity DATETIME DEFAULT CURRENT_TIMESTAMP,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        expires_at DATETIME NOT NULL, ended_at TEXT,
        FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
      );

-- Table: user_mfa_settings
CREATE TABLE user_mfa_settings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  mfa_enabled BOOLEAN DEFAULT FALSE,
  mfa_method TEXT DEFAULT 'totp' CHECK (mfa_method IN ('totp', 'sms', 'email')),
  totp_secret TEXT, -- Base32 encoded secret for TOTP
  totp_verified BOOLEAN DEFAULT FALSE,
  sms_phone TEXT,
  sms_verified BOOLEAN DEFAULT FALSE,
  email_verified BOOLEAN DEFAULT FALSE,
  backup_codes TEXT, -- JSON array of hashed backup codes
  backup_codes_used TEXT, -- JSON array of used backup codes
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: mfa_verification_logs
CREATE TABLE mfa_verification_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  mfa_method TEXT NOT NULL CHECK (mfa_method IN ('totp', 'sms', 'email', 'backup')),
  verification_code TEXT,
  success BOOLEAN DEFAULT FALSE,
  ip_address TEXT,
  user_agent TEXT,
  device_info TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: trusted_devices
CREATE TABLE trusted_devices (
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
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: book_reviews
CREATE TABLE book_reviews (
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
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES "library_users_migration_temp2"(id),
  FOREIGN KEY (rejected_by) REFERENCES "library_users_migration_temp2"(id),
  UNIQUE(book_id, user_id)
);

-- Table: payments
CREATE TABLE payments (
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
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: receipts
CREATE TABLE receipts (
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
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: notifications
CREATE TABLE notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error', 'reminder')),
  priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  is_read BOOLEAN DEFAULT FALSE,
  action_url TEXT, -- URL to navigate to when notification is clicked
  metadata TEXT, -- JSON string for additional data
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: user_notification_preferences
CREATE TABLE user_notification_preferences (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL UNIQUE,
  order_notifications BOOLEAN DEFAULT TRUE,
  system_notifications BOOLEAN DEFAULT TRUE,
  loan_notifications BOOLEAN DEFAULT TRUE,
  email_notifications BOOLEAN DEFAULT TRUE,
  in_app_notifications BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
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
);

-- Table: journals
CREATE TABLE journals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  section_id INTEGER,
  index_rate TEXT,
  month TEXT,
  year TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active','inactive','archived')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE SET NULL
);

-- Table: journal_articles
CREATE TABLE journal_articles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  journal_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  content TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (journal_id) REFERENCES journals(id) ON DELETE CASCADE
);

-- Table: journal_authors
CREATE TABLE journal_authors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  article_id INTEGER NOT NULL,
  author_name TEXT NOT NULL,
  FOREIGN KEY (article_id) REFERENCES journal_articles(id) ON DELETE CASCADE
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

-- Table: book_views
CREATE TABLE book_views (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  view_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE
);

-- Table: borrow_limits
CREATE TABLE "borrow_limits" (
  user_type VARCHAR(20) PRIMARY KEY
    CHECK (user_type IN ('Student_1','Student_2','Student_3','Student_4','Professor','Guest')),
  max_books INTEGER NOT NULL CHECK (max_books > 0),
  loan_period_days INTEGER NOT NULL CHECK (loan_period_days > 0),
  max_renewals INTEGER NOT NULL CHECK (max_renewals >= 0),
  fine_per_day DECIMAL(10,2) NOT NULL CHECK (fine_per_day >= 0),
  is_active BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
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

-- Table: reference_resources
CREATE TABLE reference_resources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  resource_type_id INTEGER NOT NULL,
  section_id INTEGER NOT NULL,
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'in_use', 'under_maintenance', 'lost', 'deprecated')),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (resource_type_id) REFERENCES resource_types(id) ON DELETE RESTRICT,
  FOREIGN KEY (section_id) REFERENCES reference_sections(id) ON DELETE RESTRICT
);

-- Table: resources
CREATE TABLE resources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    resource_type_id INTEGER NOT NULL,
    section_id INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'in_use', 'under_maintenance', 'lost', 'deprecated')),
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now')),
    
    -- Foreign key constraints
    FOREIGN KEY (resource_type_id) REFERENCES resource_types(id) ON DELETE RESTRICT,
    FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE RESTRICT
);

-- Table: orders
CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  book_id INTEGER,
  title TEXT NOT NULL,
  author TEXT,
  isbn TEXT,
  order_type TEXT NOT NULL CHECK (order_type IN ('purchase', 'acquisition', 'request')),
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
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE SET NULL,
  FOREIGN KEY (approved_by) REFERENCES "library_users_migration_temp2"(id),
  FOREIGN KEY (rejected_by) REFERENCES "library_users_migration_temp2"(id)
);

-- Table: publications
CREATE TABLE publications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  author_id INTEGER,
  publication_type TEXT NOT NULL CHECK (publication_type IN ('journal', 'conference', 'book', 'thesis', 'report')),
  url TEXT,
  abstract TEXT,
  keywords TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'archived')),
  email TEXT,
  phone TEXT,
  address TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE SET NULL
);

-- Table: wishlist
CREATE TABLE wishlist (
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
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE SET NULL
);

-- Table: penalties
CREATE TABLE penalties (
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
  FOREIGN KEY (user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE SET NULL,
  FOREIGN KEY (waived_by) REFERENCES "library_users_migration_temp2"(id)
);

-- Table: superuser_actions
CREATE TABLE superuser_actions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  superuser_id INTEGER NOT NULL,
  action_type TEXT NOT NULL,
  target_user_id INTEGER,
  target_table TEXT,
  target_record_id INTEGER,
  action_details TEXT, -- JSON string with detailed information
  ip_address TEXT,
  user_agent TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (superuser_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (target_user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE SET NULL
);

-- Table: emergency_access
CREATE TABLE emergency_access (
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
  FOREIGN KEY (requester_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (target_user_id) REFERENCES "library_users_migration_temp2"(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES "library_users_migration_temp2"(id) ON DELETE SET NULL,
  FOREIGN KEY (rejected_by) REFERENCES "library_users_migration_temp2"(id) ON DELETE SET NULL
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

-- Table: library_users
CREATE TABLE "library_users" ( id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE NOT NULL, password_hash TEXT NOT NULL, first_name TEXT NOT NULL, last_name TEXT NOT NULL, user_type TEXT NOT NULL CHECK (user_type IN ('Student','Professor','Guest')), role_id INTEGER REFERENCES roles(id), status TEXT DEFAULT 'pending' CHECK (status IN ('pending','active','inactive','suspended')), phone TEXT, stream TEXT, email_verified BOOLEAN DEFAULT FALSE, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP );

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
  revoked_at DATETIME, period_key TEXT,
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

-- Table: otp_tokens
CREATE TABLE otp_tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  otp TEXT NOT NULL,
  purpose TEXT NOT NULL CHECK (purpose IN ('status_check', 'password_reset', 'email_verification')),
  expires_at DATETIME NOT NULL,
  used_at DATETIME,
  attempts INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
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
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
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

-- Indexes / Triggers / Views
CREATE INDEX idx_books_author_id ON books(author_id);
CREATE INDEX idx_books_status ON books(status);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_genre ON books(genre);
CREATE INDEX idx_book_copies_book_id ON book_copies(book_id);
CREATE INDEX idx_book_copies_status ON book_copies(status);
CREATE INDEX idx_loans_user_id ON loans(user_id);
CREATE INDEX idx_loans_book_copy_id ON loans(book_copy_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_loans_due_date ON loans(due_date);
CREATE INDEX idx_loans_borrowed_at ON loans(borrowed_at);
CREATE INDEX idx_authors_name ON authors(last_name, first_name);
CREATE TRIGGER update_books_timestamp 
  AFTER UPDATE ON books
  FOR EACH ROW
BEGIN
  UPDATE books SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
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
JOIN "library_users_migration_temp2" u ON l.user_id = u.id
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
JOIN "library_users_migration_temp2" u ON l.user_id = u.id
WHERE l.status = 'active' AND l.due_date < CURRENT_TIMESTAMP;
CREATE TRIGGER books_ai AFTER INSERT ON books BEGIN
  INSERT INTO books_fts(rowid, title, author_name) 
  SELECT b.id, b.title, a.first_name || ' ' || a.last_name
  FROM books b
  LEFT JOIN authors a ON b.author_id = a.id
  WHERE b.id = NEW.id;
END;
CREATE TRIGGER books_ad AFTER DELETE ON books BEGIN
  INSERT INTO books_fts(books_fts, rowid, title, author_name) VALUES('delete', OLD.id, OLD.title, '');
END;
CREATE TRIGGER books_au AFTER UPDATE ON books BEGIN
  INSERT INTO books_fts(books_fts, rowid, title, author_name) VALUES('delete', OLD.id, OLD.title, '');
  INSERT INTO books_fts(rowid, title, author_name) 
  SELECT b.id, b.title, a.first_name || ' ' || a.last_name
  FROM books b
  LEFT JOIN authors a ON b.author_id = a.id
  WHERE b.id = NEW.id;
END;
CREATE INDEX idx_email_confirmation_tokens_token ON email_confirmation_tokens(token);
CREATE INDEX idx_email_confirmation_tokens_user_id ON email_confirmation_tokens(user_id);
CREATE INDEX idx_email_confirmation_tokens_expires_at ON email_confirmation_tokens(expires_at);
CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens(token);
CREATE INDEX idx_password_reset_tokens_user_id ON password_reset_tokens(user_id);
CREATE INDEX idx_password_reset_tokens_expires_at ON password_reset_tokens(expires_at);
CREATE INDEX idx_action_logs_user_id ON action_logs(user_id);
CREATE INDEX idx_action_logs_action_type ON action_logs(action_type);
CREATE INDEX idx_action_logs_table_name ON action_logs(table_name);
CREATE INDEX idx_action_logs_created_at ON action_logs(created_at);
CREATE TRIGGER update_authors_timestamp 
        AFTER UPDATE ON authors
        FOR EACH ROW
      BEGIN
        UPDATE authors SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
      END;
CREATE TRIGGER update_book_copies_timestamp 
        AFTER UPDATE ON book_copies
        FOR EACH ROW
      BEGIN
        UPDATE book_copies SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
      END;
CREATE TRIGGER update_loans_timestamp 
        AFTER UPDATE ON loans
        FOR EACH ROW
      BEGIN
        UPDATE loans SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
      END;
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_session_token ON user_sessions(session_token);
CREATE INDEX idx_user_sessions_is_active ON user_sessions(is_active);
CREATE INDEX idx_user_sessions_expires_at ON user_sessions(expires_at);
CREATE INDEX idx_user_mfa_settings_user_id ON user_mfa_settings(user_id);
CREATE INDEX idx_mfa_verification_logs_user_id ON mfa_verification_logs(user_id);
CREATE INDEX idx_mfa_verification_logs_created_at ON mfa_verification_logs(created_at);
CREATE INDEX idx_trusted_devices_user_id ON trusted_devices(user_id);
CREATE INDEX idx_trusted_devices_device_fingerprint ON trusted_devices(device_fingerprint);
CREATE INDEX idx_book_reviews_book_id ON book_reviews(book_id);
CREATE INDEX idx_book_reviews_user_id ON book_reviews(user_id);
CREATE INDEX idx_book_reviews_status ON book_reviews(status);
CREATE INDEX idx_book_reviews_created_at ON book_reviews(created_at);
CREATE INDEX idx_book_reviews_rating ON book_reviews(rating);
CREATE TRIGGER update_book_reviews_timestamp 
  AFTER UPDATE ON book_reviews
  FOR EACH ROW
BEGIN
  UPDATE book_reviews SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_payments_penalty_id ON payments(penalty_id);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_created_at ON payments(created_at);
-- SECURITY: Unique index on transaction_id to prevent reuse (race condition protection)
CREATE UNIQUE INDEX IF NOT EXISTS idx_payments_transaction_id_unique 
ON payments(transaction_id) 
WHERE transaction_id IS NOT NULL;
CREATE TRIGGER update_payments_updated_at
  AFTER UPDATE ON payments
  FOR EACH ROW
BEGIN
  UPDATE payments SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_receipts_payment_id ON receipts(payment_id);
CREATE INDEX idx_receipts_penalty_id ON receipts(penalty_id);
CREATE INDEX idx_receipts_user_id ON receipts(user_id);
CREATE INDEX idx_receipts_receipt_number ON receipts(receipt_number);
CREATE INDEX idx_receipts_created_at ON receipts(created_at);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_priority ON notifications(priority);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE TRIGGER update_notifications_timestamp 
  AFTER UPDATE ON notifications
  FOR EACH ROW
BEGIN
  UPDATE notifications SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_user_notification_preferences_user_id ON user_notification_preferences(user_id);
CREATE TRIGGER update_user_notification_preferences_timestamp 
  AFTER UPDATE ON user_notification_preferences
  FOR EACH ROW
BEGIN
  UPDATE user_notification_preferences SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_system_logs_timestamp ON system_logs(timestamp);
CREATE INDEX idx_system_logs_level ON system_logs(level);
CREATE INDEX idx_system_logs_created_at ON system_logs(created_at);
CREATE INDEX idx_rate_limits_key_time ON rate_limits(rate_key, created_at);
CREATE INDEX idx_rate_limits_created_at ON rate_limits(created_at);
CREATE INDEX idx_roles_name_lower ON roles(LOWER(name));
CREATE INDEX idx_permission_resources_name_lower ON permission_resources(LOWER(resource_name));
CREATE INDEX idx_permission_actions_name_lower ON permission_actions(LOWER(action_name));
CREATE INDEX idx_sections_name ON sections(name);
CREATE INDEX idx_journals_section_id ON journals(section_id);
CREATE INDEX idx_journals_status ON journals(status);
CREATE INDEX idx_journal_articles_journal_id ON journal_articles(journal_id);
CREATE TRIGGER update_sections_timestamp 
  AFTER UPDATE ON sections
  FOR EACH ROW
BEGIN
  UPDATE sections SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_journals_timestamp 
  AFTER UPDATE ON journals
  FOR EACH ROW
BEGIN
  UPDATE journals SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_journal_articles_timestamp 
  AFTER UPDATE ON journal_articles
  FOR EACH ROW
BEGIN
  UPDATE journal_articles SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_loans_user_id_status ON loans(user_id, status);
CREATE INDEX idx_book_copies_book_id_status ON book_copies(book_id, status);
CREATE INDEX idx_resource_types_section_id ON resource_types(section_id);
CREATE INDEX idx_resource_types_name ON resource_types(name);
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
CREATE INDEX idx_book_views_book_id ON book_views(book_id);
CREATE INDEX idx_book_views_user_id ON book_views(user_id);
CREATE INDEX idx_book_views_view_date ON book_views(view_date);
CREATE INDEX idx_book_views_created_at ON book_views(created_at);
CREATE TRIGGER update_book_views_timestamp 
  AFTER UPDATE ON book_views
  FOR EACH ROW
BEGIN
  UPDATE book_views SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_borrow_limits_user_type ON borrow_limits(user_type);
CREATE INDEX idx_borrow_limits_is_active ON borrow_limits(is_active);
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
CREATE INDEX idx_reference_resources_name ON reference_resources(name);
CREATE INDEX idx_reference_resources_resource_type_id ON reference_resources(resource_type_id);
CREATE INDEX idx_reference_resources_section_id ON reference_resources(section_id);
CREATE INDEX idx_reference_resources_status ON reference_resources(status);
CREATE INDEX idx_reference_resources_section_status ON reference_resources(section_id, status);
CREATE TRIGGER update_reference_sections_timestamp 
  AFTER UPDATE ON reference_sections
  FOR EACH ROW
BEGIN
  UPDATE reference_sections SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_reference_resources_timestamp 
  AFTER UPDATE ON reference_resources
  FOR EACH ROW
BEGIN
  UPDATE reference_resources SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_resources_resource_type_id ON resources(resource_type_id);
CREATE INDEX idx_resources_section_id ON resources(section_id);
CREATE INDEX idx_resources_status ON resources(status);
CREATE INDEX idx_resources_name ON resources(name);
CREATE INDEX idx_resources_created_at ON resources(created_at);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_book_id ON orders(book_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_order_type ON orders(order_type);
CREATE INDEX idx_publications_author_id ON publications(author_id);
CREATE INDEX idx_publications_publication_type ON publications(publication_type);
CREATE INDEX idx_publications_status ON publications(status);
CREATE INDEX idx_wishlist_user_id ON wishlist(user_id);
CREATE INDEX idx_wishlist_book_id ON wishlist(book_id);
CREATE INDEX idx_wishlist_status ON wishlist(status);
CREATE INDEX idx_penalties_user_id ON penalties(user_id);
CREATE INDEX idx_penalties_loan_id ON penalties(loan_id);
CREATE INDEX idx_penalties_status ON penalties(status);
CREATE INDEX idx_penalties_penalty_type ON penalties(penalty_type);
CREATE TRIGGER trigger_resources_update_timestamp
    AFTER UPDATE ON resources
    FOR EACH ROW
BEGIN
    UPDATE resources SET updated_at = datetime('now') WHERE id = NEW.id;
END;
CREATE TRIGGER update_orders_timestamp 
  AFTER UPDATE ON orders
  FOR EACH ROW
BEGIN
  UPDATE orders SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_publications_timestamp 
  AFTER UPDATE ON publications
  FOR EACH ROW
BEGIN
  UPDATE publications SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_wishlist_timestamp 
  AFTER UPDATE ON wishlist
  FOR EACH ROW
BEGIN
  UPDATE wishlist SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE TRIGGER update_penalties_timestamp 
  AFTER UPDATE ON penalties
  FOR EACH ROW
BEGIN
  UPDATE penalties SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
CREATE INDEX idx_superuser_actions_superuser_id ON superuser_actions(superuser_id);
CREATE INDEX idx_superuser_actions_target_user_id ON superuser_actions(target_user_id);
CREATE INDEX idx_superuser_actions_action_type ON superuser_actions(action_type);
CREATE INDEX idx_superuser_actions_created_at ON superuser_actions(created_at DESC);
CREATE INDEX idx_emergency_access_requester_id ON emergency_access(requester_id);
CREATE INDEX idx_emergency_access_target_user_id ON emergency_access(target_user_id);
CREATE INDEX idx_emergency_access_status ON emergency_access(status);
CREATE INDEX idx_emergency_access_is_active ON emergency_access(is_active);
CREATE INDEX idx_emergency_access_expires_at ON emergency_access(expires_at);
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
CREATE INDEX idx_otp_tokens_email_purpose ON otp_tokens(email, purpose);
CREATE INDEX idx_otp_tokens_expires_at ON otp_tokens(expires_at);
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
