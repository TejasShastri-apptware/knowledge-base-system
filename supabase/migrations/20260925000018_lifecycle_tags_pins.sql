-- ============================================================
-- Migration 018: lifecycle_tags_pins
-- Trash bin, taxonomy tags, document tags, and user pinned shortcuts.
-- ============================================================

-- Trash bin (soft delete recovery)
CREATE TABLE document_trash (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  original_project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  original_parent_doc_id UUID REFERENCES documents(id) ON DELETE SET NULL,
  original_position DOUBLE PRECISION NOT NULL,
  deleted_by UUID NOT NULL REFERENCES users(id),
  deleted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  permanent_purge_at TIMESTAMPTZ NOT NULL DEFAULT (now() + INTERVAL '30 days'),
  restored_by UUID REFERENCES users(id),
  restored_at TIMESTAMPTZ
);

CREATE INDEX idx_trash_purge ON document_trash(org_id, permanent_purge_at) WHERE restored_at IS NULL;

-- Organization tags taxonomy
CREATE TABLE tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  label VARCHAR(100) NOT NULL,
  color VARCHAR(7),
  created_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_tags_org_label UNIQUE (org_id, label)
);

-- Document tags junction table
CREATE TABLE document_tags (
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  tagged_by UUID NOT NULL REFERENCES users(id),
  tagged_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (document_id, tag_id)
);

-- User pinned shortcuts
CREATE TABLE user_pins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  resource_type pin_resource_type NOT NULL,
  resource_id UUID NOT NULL,
  pinned_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_user_pins UNIQUE (user_id, resource_type, resource_id)
);

CREATE INDEX idx_user_pins_user ON user_pins(user_id);
