-- ============================================================
-- Migration 017: assets
-- Uploaded files and attachments associated with documents.
-- ============================================================

CREATE TABLE document_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  original_filename VARCHAR(512) NOT NULL,
  storage_key TEXT NOT NULL UNIQUE,
  mime_type VARCHAR(127) NOT NULL,
  size_bytes BIGINT NOT NULL,
  is_orphaned BOOLEAN NOT NULL DEFAULT false,
  uploaded_by UUID NOT NULL REFERENCES users(id),
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_doc_assets_doc ON document_assets(document_id);
CREATE INDEX idx_doc_assets_org_orphaned ON document_assets(org_id, is_orphaned);
