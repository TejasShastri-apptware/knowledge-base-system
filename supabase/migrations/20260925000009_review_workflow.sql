-- ============================================================
-- Migration 009: review_requests & review_assignments
-- Created BEFORE document_versions because document_versions
-- holds a back-reference to review_requests (the approval that
-- triggered a publish). Creating review_requests first breaks
-- that dependency chain cleanly.
-- ============================================================

CREATE TABLE review_requests (
  id                          UUID                  PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id                 UUID                  NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  submitted_by                UUID                  NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  submitted_version_snapshot  TEXT                  NOT NULL,
  -- Full markdown content of the draft at submission time.
  -- Stored directly (not by FK) so reviewers always see exactly what was submitted,
  -- even if the author edits the live draft during the review cycle.
  status                      review_request_status NOT NULL DEFAULT 'PENDING',
  created_at                  TIMESTAMPTZ           NOT NULL DEFAULT NOW(),
  resolved_at                 TIMESTAMPTZ
  -- Resolution rules (enforced at application layer):
  -- ALL assignments APPROVED   → status = APPROVED → document may be published
  -- ANY assignment CHANGES_REQUESTED → status = CHANGES_REQUESTED → doc status = CHANGES_REQUESTED
  -- Author must address feedback and create a new review_requests row to re-submit
);

CREATE INDEX idx_review_requests_doc ON review_requests(document_id);

-- ============================================================
-- review_assignments
-- One row per reviewer per review request.
-- ============================================================

CREATE TABLE review_assignments (
  id                  UUID                      PRIMARY KEY DEFAULT gen_random_uuid(),
  review_request_id   UUID                      NOT NULL REFERENCES review_requests(id) ON DELETE CASCADE,
  reviewer_id         UUID                      NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  status              review_assignment_status  NOT NULL DEFAULT 'PENDING',
  feedback            TEXT,
  -- Required (enforced at app layer) when status = CHANGES_REQUESTED
  reviewed_at         TIMESTAMPTZ,

  UNIQUE (review_request_id, reviewer_id)
);

CREATE INDEX idx_review_assignments_reviewer ON review_assignments(reviewer_id);
