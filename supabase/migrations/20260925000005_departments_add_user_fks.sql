-- ============================================================
-- Migration 005: departments — add deferred FK constraints
-- Resolves the circular dependency between departments and users.
-- Now that users exists, we can safely add the foreign keys
-- for head_user_id and created_by on departments.
-- ============================================================

ALTER TABLE departments
  ADD CONSTRAINT fk_departments_head_user
    FOREIGN KEY (head_user_id)
    REFERENCES users(id)
    ON DELETE SET NULL;

ALTER TABLE departments
  ADD CONSTRAINT fk_departments_created_by
    FOREIGN KEY (created_by)
    REFERENCES users(id)
    ON DELETE RESTRICT;
