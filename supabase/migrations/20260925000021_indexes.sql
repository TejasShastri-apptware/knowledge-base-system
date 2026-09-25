-- ============================================================
-- Migration 021: indexes
-- Full-text search, composite performance indexes, and query optimizations.
-- ============================================================

-- Documents sidebar tree & status queries
CREATE INDEX IF NOT EXISTS idx_documents_tree ON documents(project_id, parent_doc_id, position);
CREATE INDEX IF NOT EXISTS idx_documents_org_status ON documents(org_id, status);

-- Full text search index on published versions & titles
CREATE INDEX IF NOT EXISTS idx_doc_versions_fts ON document_versions USING GIN (to_tsvector('english', title_snapshot || ' ' || content));
CREATE INDEX IF NOT EXISTS idx_documents_title_trgm ON documents USING GIN (title gin_trgm_ops);

-- User authentication lookups
CREATE INDEX IF NOT EXISTS idx_users_org_email ON users(org_id, email);
