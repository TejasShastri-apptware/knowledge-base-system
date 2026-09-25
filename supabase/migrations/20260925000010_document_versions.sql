-- ============================================================
-- Migration 010: document_versions
-- Immutable milestone snapshots of published document content.
-- Content in this table is frozen at publication time and NEVER modified.
-- ============================================================

CREATE TABLE document_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  version_number INTEGER NOT NULL,
  title_snapshot VARCHAR(512) NOT NULL,
  content TEXT NOT NULL,
  change_summary TEXT,
  published_by UUID NOT NULL REFERENCES users(id),
  review_request_id UUID REFERENCES review_requests(id),
  published_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_doc_version UNIQUE (document_id, version_number)
);

CREATE INDEX idx_doc_versions_doc_num ON document_versions(document_id, version_number DESC);
