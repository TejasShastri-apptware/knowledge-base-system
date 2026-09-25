-- ============================================================
-- Migration 011: documents — add deferred FK constraint
-- Resolves the circular dependency between documents and document_versions.
-- Now that document_versions exists, we can safely attach current_version_id FK.
-- ============================================================

ALTER TABLE documents
  ADD CONSTRAINT fk_documents_current_version
  FOREIGN KEY (current_version_id)
  REFERENCES document_versions(id)
  ON DELETE SET NULL;
