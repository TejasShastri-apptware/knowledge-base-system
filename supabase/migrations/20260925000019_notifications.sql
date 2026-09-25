-- ============================================================
-- Migration 019: notifications
-- User inbox notifications and event dispatch queue.
-- ============================================================

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  org_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  type notification_type NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  deep_link_url VARCHAR(1024),
  is_read BOOLEAN NOT NULL DEFAULT false,
  source_type VARCHAR(100),
  source_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_user_inbox ON notifications(user_id, is_read, created_at DESC);
