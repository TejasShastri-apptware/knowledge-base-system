-- ============================================================
-- Migration 004: users & refresh_tokens
-- Platform user accounts with custom JWT authentication.
-- refresh_tokens is co-located here as it directly depends on users.
-- ============================================================

CREATE TABLE users (
  id              UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id          UUID          NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  email           VARCHAR(320)  NOT NULL UNIQUE,
  password_hash   TEXT          NOT NULL,          -- bcrypt hash
  display_name    VARCHAR(255)  NOT NULL,
  avatar_url      TEXT,
  platform_role   platform_role NOT NULL DEFAULT 'VIEWER',
  dept_id         UUID          REFERENCES departments(id) ON DELETE SET NULL,
  -- NULL = user belongs to no specific department (org-level user)
  is_active       BOOLEAN       NOT NULL DEFAULT TRUE,
  -- Deactivated users resolve to NONE in permission checks regardless of grants
  last_login_at   TIMESTAMPTZ,
  created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- ============================================================
-- refresh_tokens
-- Supports JWT rotation. token_hash stores SHA-256 of raw token.
-- Revoked or expired tokens are rejected at the API layer.
-- ============================================================

CREATE TABLE refresh_tokens (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID          NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash    TEXT          NOT NULL UNIQUE,  -- SHA-256 of raw refresh token
  expires_at    TIMESTAMPTZ   NOT NULL,
  revoked_at    TIMESTAMPTZ,                    -- NULL = token is still valid
  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Fast lookup when validating incoming tokens
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
