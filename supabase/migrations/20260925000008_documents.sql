-- ============================================================
-- Migration 008: documents
-- Core knowledge document entity. Holds metadata and live
-- draft state only. Published content lives in document_versions.
--
-- CIRCULAR DEPENDENCY NOTE:
-- documents.current_version_id → document_versions.id
-- document_versions.document_id → documents.id
--
-- Resolution: documents is created HERE without the
-- current_version_id FK constraint. After document_versions is
-- created in migration 010, migration 011 ALTERs this table
-- to add the FK.
-- ============================================================

CREATE TABLE documents (
  id                  UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id              UUID            NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  -- org_id denormalized here for fast org-scoped queries without joining projects
  project_id          UUID            NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  parent_doc_id       UUID            REFERENCES documents(id) ON DELETE CASCADE,
  -- Self-referential. NULL = root-level doc in a project.
  -- ON DELETE CASCADE: deleting a parent deletes all children (also trashed in document_trash)
  title               VARCHAR(512)    NOT NULL,
  status              document_status NOT NULL DEFAULT 'DRAFT',
  draft_content       TEXT,
  -- Raw markdown with embedded block IDs ({#blk_uuid}).
  -- Block IDs are stripped by the API before sending to clients.
  -- NULL for brand-new empty documents.
  current_version_id  UUID,
  -- FK → document_versions(id) added in migration 011.
  -- NULL until the document is published for the first time.
  position            DOUBLE PRECISION NOT NULL DEFAULT 1.0,
  -- Fractional index for sidebar ordering within the same parent scope.
  -- Inserting between 2.0 and 3.0 → 2.5. Background job re-normalizes when fragmented.
  is_runbook          BOOLEAN         NOT NULL DEFAULT FALSE,
  is_template_source  BOOLEAN         NOT NULL DEFAULT FALSE,
  -- TRUE if this document has been promoted as the source for a Blueprint.
  created_by          UUID            NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  last_modified_by    UUID            NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON documents
  FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();

-- Sidebar tree fetch: all documents in a project ordered by position within each parent
CREATE INDEX idx_documents_tree ON documents(project_id, parent_doc_id, position);

-- Dashboard queries filtered by status
CREATE INDEX idx_documents_org_status ON documents(org_id, status);
