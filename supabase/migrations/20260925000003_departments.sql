-- ============================================================
-- Migration 003: departments
-- Organizational divisions within a tenant.
--
-- CIRCULAR DEPENDENCY NOTE:
-- departments.head_user_id → users.id
-- users.dept_id            → departments.id
--
-- Resolution: departments is created HERE without the
-- head_user_id FK constraint. After users is created in
-- migration 004, migration 005 ALTERs this table to add it.
-- ============================================================

CREATE TABLE departments (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id        UUID          NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name          VARCHAR(255)  NOT NULL,
  slug          VARCHAR(100)  NOT NULL,
  description   TEXT,
  -- head_user_id FK is added in migration 005 after users table exists
  head_user_id  UUID,
  created_by    UUID          NOT NULL,  -- FK → users added in migration 005
  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  deleted_at    TIMESTAMPTZ,             -- Soft delete. NULL = active

  UNIQUE (org_id, slug)
);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON departments
  FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();
