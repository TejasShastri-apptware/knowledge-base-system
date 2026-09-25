-- ============================================================
-- Migration 002: organizations
-- Root multi-tenant entity. Every row in the system belongs
-- to exactly one organization.
-- ============================================================

CREATE TABLE organizations (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  name                VARCHAR(255)  NOT NULL,
  slug                VARCHAR(100)  NOT NULL UNIQUE,  -- URL-safe identifier (e.g. "acme-corp")
  default_member_role default_member_role NOT NULL DEFAULT 'NONE',
  -- NONE = private by default. All authenticated org members start with no access
  -- unless explicitly granted. Set to VIEWER for open/wiki-style orgs.
  settings            JSONB         NOT NULL DEFAULT '{}',
  -- Extensible org-level config (e.g. session_timeout_minutes, enforce_2fa, etc.)
  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON organizations
  FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();
