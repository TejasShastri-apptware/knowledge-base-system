-- ============================================================
-- Migration 015: blueprints
-- Reusable document templates governed at org/dept/project scope.
-- ============================================================

CREATE TABLE blueprints (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  template_content TEXT NOT NULL,
  scope blueprint_scope NOT NULL,
  scope_dept_id UUID REFERENCES departments(id) ON DELETE CASCADE,
  scope_project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  created_by UUID NOT NULL REFERENCES users(id),
  approval_status approval_status NOT NULL DEFAULT 'PENDING',
  approved_by UUID REFERENCES users(id),
  approved_at TIMESTAMPTZ,
  rejection_reason TEXT,
  is_archived BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER trg_blueprints_updated_at
  BEFORE UPDATE ON blueprints
  FOR EACH ROW
  EXECUTE FUNCTION trigger_set_updated_at();

CREATE INDEX idx_blueprints_scope ON blueprints(org_id, scope, approval_status);
