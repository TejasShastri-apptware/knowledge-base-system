-- ============================================================
-- Migration 006: user_groups & user_group_members
-- Flat, org-scoped named groups. Any org member can be added
-- to any group regardless of their department.
-- ============================================================

CREATE TABLE user_groups (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id        UUID          NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name          VARCHAR(255)  NOT NULL,
  description   TEXT,
  created_by    UUID          NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  UNIQUE (org_id, name)
);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON user_groups
  FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- ============================================================
-- user_group_members
-- Junction table for group membership.
-- Members can come from any department within the org.
-- ============================================================

CREATE TABLE user_group_members (
  id          UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id    UUID          NOT NULL REFERENCES user_groups(id) ON DELETE CASCADE,
  user_id     UUID          NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  added_by    UUID          NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  added_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  UNIQUE (group_id, user_id)
);

CREATE INDEX idx_group_members_user ON user_group_members(user_id);
