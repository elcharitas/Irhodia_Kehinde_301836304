-- Fictional sample records for MIT 8103 laboratory equipment booking exercise.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."lab_member" ("member_id", "member_label", "joined_on") VALUES (1, 'Fictional Member Alpha', '2026-01-01');
INSERT INTO portfolio."equipment" ("equipment_id", "equipment_name", "category") VALUES (2, 'Demo Microscope', 'Optics');
INSERT INTO portfolio."equipment_unit" ("unit_id", "equipment_id", "asset_tag", "service_state", "condition_note") VALUES (3, 2, 'SYN-001', 'available', 'Inspection complete; clean');
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at") VALUES (4, 1, 3, '2026-02-01T09:00:00Z', '2026-02-01T10:00:00Z', 'returned', '2026-01-31T08:00:00Z');
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at") VALUES (5, 1, 3, '2026-02-02T09:00:00Z', '2026-02-02T10:00:00Z', 'approved', '2026-02-01T12:00:00Z');
INSERT INTO portfolio."booking_request" ("booking_id", "member_id", "unit_id", "requested_start", "requested_end", "status", "created_at") VALUES (6, 1, 3, '2026-02-03T09:00:00Z', '2026-02-03T10:00:00Z', 'pending', '2026-02-01T13:00:00Z');
INSERT INTO portfolio."return_record" ("return_id", "booking_id", "returned_at", "condition_note") VALUES (7, 4, '2026-02-01T10:00:00Z', 'Inspection complete; clean');
COMMIT;
