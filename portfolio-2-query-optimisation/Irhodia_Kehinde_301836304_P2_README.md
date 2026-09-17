# MIT 8103 laboratory equipment booking exercise — SQL queries

## 1. Show related lab_member, booking_request, equipment_unit, equipment, return_record records (up to 20).

```sql
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
```

| lab_member_member_id | lab_member_member_label | booking_request_booking_id | booking_request_requested_start | equipment_unit_unit_id | equipment_unit_asset_tag | equipment_equipment_id | equipment_equipment_name | return_record_return_id | return_record_returned_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Fictional Member Alpha | 4 | 2026-02-01T09:00:00+00:00 | 3 | SYN-001 | 2 | Demo Microscope | 7 | 2026-02-01T10:00:00+00:00 |

## 2. Find equipment records where equipment_name matches "Demo Microscope" (up to 20).

```sql
SELECT * FROM portfolio."equipment"
WHERE "equipment_name" IS NOT DISTINCT FROM 'Demo Microscope'
ORDER BY "equipment_id"
LIMIT 20;
```

| equipment_id | equipment_name | category |
| --- | --- | --- |
| 2 | Demo Microscope | Optics |

## 3. Count booking_request records for each member_id (up to 20 groups).

```sql
SELECT "member_id", count(*) AS record_count
FROM portfolio."booking_request"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;
```

| member_id | record_count |
| --- | --- |
| 1 | 3 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.928 | 0.979, 0.928, 0.915 | Sort → Seq Scan | 112 |
| After index | 0.111 | 0.108, 0.111, 0.116 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.928 ms to 0.111 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.961..0.963 rows=20 loops=1)
  Seq Scan on booking_request (actual time=0.012..0.94 rows=20 loops=1)
Planning Time: 0.254 ms
Execution Time: 0.979 ms
```

### Before index, run 2

```text
Sort (actual time=0.907..0.908 rows=20 loops=1)
  Seq Scan on booking_request (actual time=0.01..0.887 rows=20 loops=1)
Planning Time: 0.202 ms
Execution Time: 0.928 ms
```

### Before index, run 3

```text
Sort (actual time=0.899..0.9 rows=20 loops=1)
  Seq Scan on booking_request (actual time=0.01..0.875 rows=20 loops=1)
Planning Time: 0.206 ms
Execution Time: 0.915 ms
```

### After index, run 1

```text
Sort (actual time=0.075..0.077 rows=20 loops=1)
  Bitmap Heap Scan on booking_request (actual time=0.016..0.055 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.009..0.009 rows=20 loops=1)
Planning Time: 0.347 ms
Execution Time: 0.108 ms
```

### After index, run 2

```text
Sort (actual time=0.075..0.076 rows=20 loops=1)
  Bitmap Heap Scan on booking_request (actual time=0.016..0.054 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.009..0.009 rows=20 loops=1)
Planning Time: 0.329 ms
Execution Time: 0.111 ms
```

### After index, run 3

```text
Sort (actual time=0.074..0.075 rows=20 loops=1)
  Bitmap Heap Scan on booking_request (actual time=0.015..0.052 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.009..0.009 rows=20 loops=1)
Planning Time: 0.319 ms
Execution Time: 0.116 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Irhodia_Kehinde_301836304_P2_Queries.sql, then Irhodia_Kehinde_301836304_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Irhodia_Kehinde_301836304_P2_QueryResults.png) · [Index comparison](screenshots/Irhodia_Kehinde_301836304_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

