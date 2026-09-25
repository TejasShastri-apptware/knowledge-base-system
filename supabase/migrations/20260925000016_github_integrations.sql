-- ============================================================
-- Migration 016: github_integrations
-- Registered GitHub repo connections and live document embeds.
-- ============================================================

CREATE TABLE github_connections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  repo_owner VARCHAR(255) NOT NULL,
  repo_name VARCHAR(255) NOT NULL,
  access_token_encrypted TEXT NOT NULL,
  webhook_secret_encrypted TEXT,
  docs_path VARCHAR(512) NOT NULL DEFAULT '/docs',
  sync_direction sync_direction NOT NULL DEFAULT 'BIDIRECTIONAL',
  last_sync_at TIMESTAMPTZ,
  created_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT uq_github_connections UNIQUE (org_id, repo_owner, repo_name)
);

CREATE TRIGGER trg_github_connections_updated_at
  BEFORE UPDATE ON github_connections
  FOR EACH ROW
  EXECUTE FUNCTION trigger_set_updated_at();

CREATE TABLE document_github_embeds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  embed_type embed_type NOT NULL,
  repo_owner VARCHAR(255) NOT NULL,
  repo_name VARCHAR(255) NOT NULL,
  resource_number INTEGER,
  file_path VARCHAR(1024),
  line_start INTEGER,
  line_end INTEGER,
  git_ref VARCHAR(255),
  cached_status VARCHAR(50),
  cached_title VARCHAR(512),
  last_synced_at TIMESTAMPTZ,
  created_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_gh_embeds_doc ON document_github_embeds(document_id);
