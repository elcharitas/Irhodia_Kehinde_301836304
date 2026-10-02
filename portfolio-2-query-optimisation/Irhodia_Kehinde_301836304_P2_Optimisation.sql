-- A separate performance table using the case's booking_request.requested_start type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."booking_request" AS
SELECT "requested_start", 0::bigint AS "lab_row_id" FROM portfolio."booking_request" WITH NO DATA;
INSERT INTO query_lab."booking_request" ("requested_start", "lab_row_id")
SELECT (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (g % 1000) * INTERVAL '1 second'), g FROM generate_series(1, 20000) AS g;
ANALYZE query_lab."booking_request";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."booking_request" USING btree ("requested_start");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "requested_start"
FROM query_lab."booking_request"
WHERE "requested_start" = (TIMESTAMPTZ '2030-01-01T00:00:00Z' + (42 % 1000) * INTERVAL '1 second')
ORDER BY "lab_row_id";
