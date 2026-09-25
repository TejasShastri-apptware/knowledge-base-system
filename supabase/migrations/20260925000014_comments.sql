-- ============================================================
-- Migration 014: comments
-- Inline and document-level comment threads and nested replies.
-- ============================================================

CREATE TABLE comment_threads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES users(id),
  anchor_type anchor_type NOT NULL,
  selected_text_snapshot TEXT,
  anchor_block_id VARCHAR(64),
  is_anchor_broken BOOLEAN NOT NULL DEFAULT false,
  status thread_status NOT NULL DEFAULT 'OPEN',
  resolved_by UUID REFERENCES users(id),
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_comment_threads_doc_status ON comment_threads(document_id, status);

CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES comment_threads(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

CREATE TRIGGER trg_comments_updated_at
  BEFORE UPDATE ON comments
  FOR EACH ROW
  EXECUTE FUNCTION trigger_set_updated_at();

CREATE INDEX idx_comments_thread ON comments(thread_id, created_at ASC);
