-- ============================================================
-- Migration 013: knowledge_graph
-- Semantic relationship vocabulary and directed graph edges (backlinks/outbound links).
-- ============================================================

CREATE TABLE relationship_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  label VARCHAR(100) NOT NULL,
  description TEXT,
  is_system BOOLEAN NOT NULL DEFAULT false,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_rel_types_org_label UNIQUE (org_id, label)
);

CREATE TABLE document_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_doc_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  target_doc_id UUID REFERENCES documents(id) ON DELETE SET NULL,
  link_type_id UUID NOT NULL REFERENCES relationship_types(id) ON DELETE RESTRICT,
  target_doc_title_snapshot VARCHAR(512) NOT NULL,
  is_broken BOOLEAN NOT NULL DEFAULT false,
  created_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_doc_links UNIQUE (source_doc_id, target_doc_id)
);

CREATE INDEX idx_doc_links_target ON document_links(target_doc_id);
CREATE INDEX idx_doc_links_source ON document_links(source_doc_id);
