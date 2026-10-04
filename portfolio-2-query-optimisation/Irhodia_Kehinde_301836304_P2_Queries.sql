-- Show related lab_member, booking_request, equipment_unit, equipment, return_record records (up to 20).
SELECT t0."member_id" AS "lab_member_member_id",
       t0."member_label" AS "lab_member_member_label",
       t1."booking_id" AS "booking_request_booking_id",
       t1."requested_start" AS "booking_request_requested_start",
       t3."unit_id" AS "equipment_unit_unit_id",
       t3."asset_tag" AS "equipment_unit_asset_tag",
       t4."equipment_id" AS "equipment_equipment_id",
       t4."equipment_name" AS "equipment_equipment_name",
       t2."return_id" AS "return_record_return_id",
       t2."returned_at" AS "return_record_returned_at"
FROM portfolio."lab_member" t0
JOIN portfolio."booking_request" t1 ON t1."member_id" = t0."member_id"
JOIN portfolio."return_record" t2 ON t2."booking_id" = t1."booking_id"
JOIN portfolio."equipment_unit" t3 ON t1."unit_id" = t3."unit_id"
JOIN portfolio."equipment" t4 ON t3."equipment_id" = t4."equipment_id"
ORDER BY t0."member_id", t1."booking_id", t3."unit_id", t4."equipment_id", t2."return_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."member_id" AS "lab_member_member_id",
       t0."member_label" AS "lab_member_member_label",
       t1."booking_id" AS "booking_request_booking_id",
       t1."requested_start" AS "booking_request_requested_start",
       t3."unit_id" AS "equipment_unit_unit_id",
       t3."asset_tag" AS "equipment_unit_asset_tag",
       t4."equipment_id" AS "equipment_equipment_id",
       t4."equipment_name" AS "equipment_equipment_name",
       t2."return_id" AS "return_record_return_id",
       t2."returned_at" AS "return_record_returned_at"
FROM portfolio."lab_member" t0
JOIN portfolio."booking_request" t1 ON t1."member_id" = t0."member_id"
JOIN portfolio."return_record" t2 ON t2."booking_id" = t1."booking_id"
JOIN portfolio."equipment_unit" t3 ON t1."unit_id" = t3."unit_id"
JOIN portfolio."equipment" t4 ON t3."equipment_id" = t4."equipment_id"
ORDER BY t0."member_id", t1."booking_id", t3."unit_id", t4."equipment_id", t2."return_id"
LIMIT 20;

-- Find equipment records where equipment_name matches "Demo Microscope" (up to 20).
SELECT * FROM portfolio."equipment"
WHERE "equipment_name" IS NOT DISTINCT FROM 'Demo Microscope'
ORDER BY "equipment_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."equipment"
WHERE "equipment_name" IS NOT DISTINCT FROM 'Demo Microscope'
ORDER BY "equipment_id"
LIMIT 20;

-- Count booking_request records for each member_id (up to 20 groups).
SELECT "member_id", count(*) AS record_count
FROM portfolio."booking_request"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "member_id", count(*) AS record_count
FROM portfolio."booking_request"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;
