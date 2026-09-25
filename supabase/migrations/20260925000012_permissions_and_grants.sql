-- ============================================================
-- Migration 012: permissions_and_grants
-- Role assignments at Department, Project, and Document levels,
-- plus the access_requests table for permission escalation workflows.
-- ============================================================

-- Department-level role assignments
CREATE TABLE dept_grants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dept_id UUID NOT NULL REFERENCES departments(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  group_id UUID REFERENCES user_groups(id) ON DELETE CASCADE,
  role permission_role NOT NULL,
  granted_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_dept_grant_target CHECK (
    (user_id IS NOT NULL AND group_id IS NULL) OR
    (user_id IS NULL AND group_id IS NOT NULL)
  ),
  CONSTRAINT chk_dept_grant_valid_role CHECK (role <> 'NONE')
);

CREATE UNIQUE INDEX uq_dept_grants_user ON dept_grants (dept_id, user_id) WHERE user_id IS NOT NULL;
CREATE UNIQUE INDEX uq_dept_grants_group ON dept_grants (dept_id, group_id) WHERE group_id IS NOT NULL;

-- Project-level role assignments
CREATE TABLE project_grants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  group_id UUID REFERENCES user_groups(id) ON DELETE CASCADE,
  role permission_role NOT NULL,
  is_default_for_new_docs BOOLEAN NOT NULL DEFAULT false,
  granted_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_proj_grant_target CHECK (
    (user_id IS NOT NULL AND group_id IS NULL) OR
    (user_id IS NULL AND group_id IS NOT NULL)
  ),
  CONSTRAINT chk_proj_grant_valid_role CHECK (role <> 'NONE')
);

CREATE UNIQUE INDEX uq_project_grants_user ON project_grants (project_id, user_id) WHERE user_id IS NOT NULL;
CREATE UNIQUE INDEX uq_project_grants_group ON project_grants (project_id, group_id) WHERE group_id IS NOT NULL;

-- Document-level explicit role overrides (highest precedence)
CREATE TABLE document_grants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  group_id UUID REFERENCES user_groups(id) ON DELETE CASCADE,
  role permission_role NOT NULL,
  granted_by UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_doc_grant_target CHECK (
    (user_id IS NOT NULL AND group_id IS NULL) OR
    (user_id IS NULL AND group_id IS NOT NULL)
  )
);

CREATE UNIQUE INDEX uq_document_grants_user ON document_grants (document_id, user_id) WHERE user_id IS NOT NULL;
CREATE UNIQUE INDEX uq_document_grants_group ON document_grants (document_id, group_id) WHERE group_id IS NOT NULL;

-- Access escalation requests
CREATE TABLE access_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  requester_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  resource_type access_resource_type NOT NULL,
  resource_id UUID NOT NULL,
  requested_role permission_role NOT NULL,
  message TEXT,
  status access_request_status NOT NULL DEFAULT 'PENDING',
  reviewed_by UUID REFERENCES users(id),
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_access_requests_resource ON access_requests(resource_type, resource_id, status);
CREATE INDEX idx_access_requests_requester ON access_requests(requester_id, status);
