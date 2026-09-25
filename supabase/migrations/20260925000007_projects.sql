-- ============================================================
-- Migration 007: projects
-- Knowledge spaces. Can be dept-bound or standalone.
-- dept_id IS NULL = standalone/cross-functional project,
-- which inherits no department-level baseline permissions.
-- ============================================================

CREATE TABLE projects (
  id                    UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id                UUID            NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  dept_id               UUID            REFERENCES departments(id) ON DELETE SET NULL,
  -- NULL = standalone project (no department parent)
  name                  VARCHAR(255)    NOT NULL,
  slug                  VARCHAR(100)    NOT NULL,
  description           TEXT,
  publishing_mode       publishing_mode NOT NULL DEFAULT 'REVIEW_REQUIRED',
  is_public_within_org  BOOLEAN         NOT NULL DEFAULT FALSE,
  -- TRUE = all org members get VIEWER baseline unless overridden by a NONE document_grant
  is_archived           BOOLEAN         NOT NULL DEFAULT FALSE,
  github_repo_url       TEXT,           -- Loosely linked repo; formal connection is in github_connections
  created_by            UUID            NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  created_at            TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
  deleted_at            TIMESTAMPTZ,    -- Soft delete

  UNIQUE (org_id, slug)
);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON projects
  FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

CREATE INDEX idx_projects_org ON projects(org_id);
CREATE INDEX idx_projects_dept ON projects(dept_id) WHERE dept_id IS NOT NULL;
