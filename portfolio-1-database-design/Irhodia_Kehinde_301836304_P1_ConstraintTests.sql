-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. duplicate member. Expected: pk_lab_member, SQLSTATE 23505.
INSERT INTO portfolio."lab_member" ("member_id", "member_label", "joined_on")
VALUES (1, 'Fictional Member Beta', '2026-01-02');

-- 2. duplicate equipment. Expected: pk_equipment, SQLSTATE 23505.
INSERT INTO portfolio."equipment" ("equipment_id", "equipment_name", "category")
VALUES (2, 'Demo Balance', 'Measurement');

-- 3. duplicate unit. Expected: pk_equipment_unit, SQLSTATE 23505.
INSERT INTO portfolio."equipment_unit" ("unit_id", "equipment_id", "asset_tag", "service_state", "condition_note")
VALUES (3, 2, 'SYN-102', 'available', 'Clean');

-- 4. duplicate booking. Expected: pk_booking_request, SQLSTATE 23505.
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at")
VALUES (4, 1, 3, '2026-03-01T09:00:00Z', '2026-03-01T10:00:00Z', 'pending', '2026-02-28T08:00:00Z');

-- 5. duplicate return. Expected: pk_return_record, SQLSTATE 23505.
INSERT INTO portfolio."return_record" ("return_id", "booking_id", "returned_at", "condition_note")
VALUES (7, 5, '2026-02-02T10:00:00Z', 'Clean');

-- 6. duplicate asset tag. Expected: uq_equipment_unit_0, SQLSTATE 23505.
INSERT INTO portfolio."equipment_unit" ("unit_id", "equipment_id", "asset_tag", "service_state", "condition_note")
VALUES (101, 2, 'SYN-001', 'available', 'Clean');

-- 7. duplicate booking return. Expected: uq_return_record_0, SQLSTATE 23505.
INSERT INTO portfolio."return_record" ("return_id", "booking_id", "returned_at", "condition_note")
VALUES (102, 4, '2026-02-01T11:00:00Z', 'Clean');

-- 8. missing equipment. Expected: fk_equipment_unit_0, SQLSTATE 23503.
INSERT INTO portfolio."equipment_unit" ("unit_id", "equipment_id", "asset_tag", "service_state", "condition_note")
VALUES (103, 901, 'SYN-103', 'available', 'Clean');

-- 9. missing member. Expected: fk_booking_request_0, SQLSTATE 23503.
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at")
VALUES (104, 902, 3, '2026-03-01T09:00:00Z', '2026-03-01T10:00:00Z', 'pending', '2026-02-28T08:00:00Z');

-- 10. missing unit. Expected: fk_booking_request_1, SQLSTATE 23503.
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at")
VALUES (105, 1, 903, '2026-03-01T09:00:00Z', '2026-03-01T10:00:00Z', 'pending', '2026-02-28T08:00:00Z');

-- 11. missing booking. Expected: fk_return_record_0, SQLSTATE 23503.
INSERT INTO portfolio."return_record" ("return_id", "booking_id", "returned_at", "condition_note")
VALUES (106, 904, '2026-03-01T10:00:00Z', 'Clean');

-- 12. invalid dates. Expected: valid_booking_dates, SQLSTATE 23514.
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at")
VALUES (107, 1, 3, '2026-03-01T09:00:00Z', '2026-03-01T09:00:00Z', 'pending', '2026-02-28T08:00:00Z');

-- 13. invalid status. Expected: valid_booking_status, SQLSTATE 23514.
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at")
VALUES (108, 1, 3, '2026-03-01T09:00:00Z', '2026-03-01T10:00:00Z', 'unknown', '2026-02-28T08:00:00Z');

-- 14. invalid service state. Expected: valid_service_state, SQLSTATE 23514.
INSERT INTO portfolio."equipment_unit" ("unit_id", "equipment_id", "asset_tag", "service_state", "condition_note")
VALUES (109, 2, 'SYN-109', 'unknown', 'Clean');

-- 15. conflicting active booking. Expected: one_active_booking, SQLSTATE 23505.
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at")
VALUES (110, 1, 3, '2026-03-01T09:00:00Z', '2026-03-01T10:00:00Z', 'checked_out', '2026-02-28T08:00:00Z');

-- 16. null member label. Expected: member_label, SQLSTATE 23502.
INSERT INTO portfolio."lab_member" ("member_id", "member_label", "joined_on")
VALUES (111, NULL, '2026-01-02');
