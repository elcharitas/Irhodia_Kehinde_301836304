-- MIT 8103 laboratory equipment booking exercise: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."lab_member" (
  "member_id" bigint NOT NULL,
  "member_label" text NOT NULL,
  "joined_on" date NOT NULL,
  CONSTRAINT "pk_lab_member" PRIMARY KEY ("member_id")
);
CREATE TABLE portfolio."equipment" (
  "equipment_id" bigint NOT NULL,
  "equipment_name" text NOT NULL,
  "category" text NOT NULL,
  CONSTRAINT "pk_equipment" PRIMARY KEY ("equipment_id")
);
CREATE TABLE portfolio."equipment_unit" (
  "unit_id" bigint NOT NULL,
  "equipment_id" bigint NOT NULL,
  "asset_tag" text NOT NULL,
  "service_state" text NOT NULL,
  "condition_note" text NOT NULL,
  CONSTRAINT "pk_equipment_unit" PRIMARY KEY ("unit_id"),
  CONSTRAINT "uq_equipment_unit_0" UNIQUE ("asset_tag")
);
CREATE TABLE portfolio."booking_request" (
  "booking_id" bigint NOT NULL,
  "member_id" bigint NOT NULL,
  "unit_id" bigint NOT NULL,
  "requested_start" timestamptz NOT NULL,
  "requested_end" timestamptz NOT NULL,
  "status" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_booking_request" PRIMARY KEY ("booking_id")
);
CREATE TABLE portfolio."return_record" (
  "return_id" bigint NOT NULL,
  "booking_id" bigint NOT NULL,
  "returned_at" timestamptz NOT NULL,
  "condition_note" text NOT NULL,
  CONSTRAINT "pk_return_record" PRIMARY KEY ("return_id"),
  CONSTRAINT "uq_return_record_0" UNIQUE ("booking_id")
);
ALTER TABLE portfolio."equipment_unit" ADD CONSTRAINT "fk_equipment_unit_0" FOREIGN KEY ("equipment_id") REFERENCES portfolio."equipment" ("equipment_id");
ALTER TABLE portfolio."booking_request" ADD CONSTRAINT "fk_booking_request_0" FOREIGN KEY ("member_id") REFERENCES portfolio."lab_member" ("member_id");
ALTER TABLE portfolio."booking_request" ADD CONSTRAINT "fk_booking_request_1" FOREIGN KEY ("unit_id") REFERENCES portfolio."equipment_unit" ("unit_id");
ALTER TABLE portfolio."return_record" ADD CONSTRAINT "fk_return_record_0" FOREIGN KEY ("booking_id") REFERENCES portfolio."booking_request" ("booking_id");
ALTER TABLE portfolio."booking_request" ADD CONSTRAINT "valid_booking_dates" CHECK ("requested_end" > "requested_start");
ALTER TABLE portfolio."booking_request" ADD CONSTRAINT "valid_booking_status" CHECK (("status" = 'pending') OR ("status" = 'approved') OR ("status" = 'checked_out') OR ("status" = 'returned') OR ("status" = 'cancelled'));
CREATE UNIQUE INDEX "one_active_booking" ON portfolio."booking_request" ("unit_id") WHERE (("status" = 'approved') OR ("status" = 'checked_out'));
ALTER TABLE portfolio."equipment_unit" ADD CONSTRAINT "valid_service_state" CHECK (("service_state" = 'available') OR ("service_state" = 'maintenance') OR ("service_state" = 'retired'));
COMMIT;
