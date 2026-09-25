-- ============================================================
-- Migration 020: audit_logs
-- Immutable, append-only security and activity audit trail.
-- ============================================================

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  actor_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(100) NOT NULL,
  resource_type audit_resource_type NOT NULL,
  resource_id UUID NOT NULL,
  payload JSONB NOT NULL DEFAULT '{}',
  ip_address INET,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_logs_resource ON audit_logs(org_id, resource_type, resource_id);
CREATE INDEX idx_audit_logs_actor ON audit_logs(org_id, actor_id, created_at DESC);
