-- ============================================================
-- Migration 001: Extensions & ENUM Types
-- All custom ENUM types used across the schema are defined here
-- so that subsequent migrations can reference them freely.
-- ============================================================

-- Enable pgcrypto for gen_random_uuid() and pg_trgm for search
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ============================================================
-- ENUM: Platform-level user role
-- Governs what a user can administer (not document-level access)
-- ============================================================
CREATE TYPE platform_role AS ENUM (
  'SYSTEM_ADMIN',   -- Full org administration
  'DEPT_HEAD',      -- Manages a department and its projects
  'PROJECT_LEAD',   -- Manages a specific project
  'EDITOR',         -- Can create and edit documents
  'REVIEWER',       -- Designated sign-off authority
  'COMMENTER',      -- Can read and comment only
  'VIEWER',         -- Read-only access
  'GUEST'           -- Temporary/external access
);

-- ============================================================
-- ENUM: Document lifecycle status
-- ============================================================
CREATE TYPE document_status AS ENUM (
  'DRAFT',
  'IN_REVIEW',
  'CHANGES_REQUESTED',
  'PUBLISHED',
  'DEPRECATED',
  'ARCHIVED'
);

-- ============================================================
-- ENUM: Project publishing mode
-- ============================================================
CREATE TYPE publishing_mode AS ENUM (
  'DIRECT',           -- Authors can publish immediately
  'REVIEW_REQUIRED'   -- Must pass sign-off chain before publishing
);

-- ============================================================
-- ENUM: Permission role (used in all grant tables)
-- NONE is an explicit deny — only valid in document_grants
-- ============================================================
CREATE TYPE permission_role AS ENUM (
  'NONE',       -- Explicit deny override
  'VIEWER',
  'COMMENTER',
  'EDITOR',
  'REVIEWER',
  'OWNER'
);

-- ============================================================
-- ENUM: Org-level default member role
-- Subset of permission_role (NONE = private by default)
-- ============================================================
CREATE TYPE default_member_role AS ENUM (
  'NONE',
  'VIEWER',
  'COMMENTER',
  'EDITOR'
);

-- ============================================================
-- ENUM: Comment anchor type
-- ============================================================
CREATE TYPE anchor_type AS ENUM (
  'INLINE',          -- Anchored to a specific text block
  'DOCUMENT_LEVEL'   -- General feedback on the whole document
);

-- ============================================================
-- ENUM: Comment thread lifecycle status
-- ============================================================
CREATE TYPE thread_status AS ENUM (
  'OPEN',
  'RESOLVED'
);

-- ============================================================
-- ENUM: Review request lifecycle status
-- ============================================================
CREATE TYPE review_request_status AS ENUM (
  'PENDING',
  'APPROVED',
  'CHANGES_REQUESTED',
  'CANCELLED'
);

-- ============================================================
-- ENUM: Individual reviewer assignment status
-- ============================================================
CREATE TYPE review_assignment_status AS ENUM (
  'PENDING',
  'APPROVED',
  'CHANGES_REQUESTED'
);

-- ============================================================
-- ENUM: Blueprint visibility scope
-- ============================================================
CREATE TYPE blueprint_scope AS ENUM (
  'PROJECT',
  'DEPARTMENT',
  'ORGANIZATION'
);

-- ============================================================
-- ENUM: Blueprint approval status
-- ============================================================
CREATE TYPE approval_status AS ENUM (
  'PENDING',
  'APPROVED',
  'REJECTED'
);

-- ============================================================
-- ENUM: GitHub integration sync direction
-- ============================================================
CREATE TYPE sync_direction AS ENUM (
  'KBS_TO_GH',
  'GH_TO_KBS',
  'BIDIRECTIONAL'
);

-- ============================================================
-- ENUM: GitHub embed card type
-- ============================================================
CREATE TYPE embed_type AS ENUM (
  'PR_CARD',
  'ISSUE_CARD',
  'CODE_SNIPPET',
  'ISSUE_BOARD'
);

-- ============================================================
-- ENUM: Access request target resource type
-- ============================================================
CREATE TYPE access_resource_type AS ENUM (
  'PROJECT',
  'DOCUMENT'
);

-- ============================================================
-- ENUM: Access request lifecycle status
-- ============================================================
CREATE TYPE access_request_status AS ENUM (
  'PENDING',
  'APPROVED',
  'DENIED'
);

-- ============================================================
-- ENUM: Notification event type
-- ============================================================
CREATE TYPE notification_type AS ENUM (
  'MENTION',
  'COMMENT_REPLY',
  'REVIEW_ASSIGNED',
  'REVIEW_RESOLVED',
  'ACCESS_GRANTED',
  'ACCESS_REQUESTED',
  'ACCESS_REVOKED',
  'PR_MERGED_PROMPT',
  'DOWNSTREAM_IMPACT_ALERT',
  'BLUEPRINT_APPROVAL_REQUESTED',
  'DOC_DEPRECATED'
);

-- ============================================================
-- ENUM: User pin resource type
-- ============================================================
CREATE TYPE pin_resource_type AS ENUM (
  'DOCUMENT',
  'PROJECT'
);

-- ============================================================
-- ENUM: Audit log subject resource type
-- ============================================================
CREATE TYPE audit_resource_type AS ENUM (
  'DOCUMENT',
  'DOCUMENT_VERSION',
  'PROJECT',
  'DEPARTMENT',
  'PERMISSION',
  'GROUP',
  'USER',
  'BLUEPRINT',
  'REVIEW_REQUEST'
);

-- ============================================================
-- Utility: auto-update updated_at on any table that has it
-- Usage: CREATE TRIGGER set_updated_at BEFORE UPDATE ON <table>
--        FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();
-- ============================================================
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
