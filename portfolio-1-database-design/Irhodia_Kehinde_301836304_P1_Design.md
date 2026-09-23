# MIT 8103 laboratory equipment booking exercise — database design

My case study records lab_member, equipment, equipment_unit, booking_request, return_record.

## Users

- Laboratory members request equipment units.
- Laboratory technicians approve requests and record returns.

## Main operations

- Register members, equipment categories and individual units.
- Submit requests and approve eligible units.
- Record returns and update unit condition.
- Retain booking history and report equipment usage.

## Entities

| Entity | Information stored |
| --- | --- |
| lab_member | Store synthetic laboratory membership records. |
| equipment | Describe equipment categories shared by physical units. |
| equipment_unit | Identify physical units and record service availability and condition. |
| booking_request | Preserve requests and their current lifecycle status. |
| return_record | Preserve the return observation for a booking. |

## lab_member

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| member_id | BIGINT | PK | Yes |
| member_label | TEXT |  | Yes |
| joined_on | DATE |  | Yes |


## equipment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| equipment_id | BIGINT | PK | Yes |
| equipment_name | TEXT |  | Yes |
| category | TEXT |  | Yes |


## equipment_unit

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| unit_id | BIGINT | PK | Yes |
| equipment_id | BIGINT | FK | Yes |
| asset_tag | TEXT | Unique | Yes |
| service_state | TEXT |  | Yes |
| condition_note | TEXT |  | Yes |
- equipment_id → equipment.equipment_id
- Unique key: (asset_tag).

## booking_request

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| booking_id | BIGINT | PK | Yes |
| member_id | BIGINT | FK | Yes |
| unit_id | BIGINT | FK | Yes |
| requested_start | TIMESTAMPTZ |  | Yes |
| requested_end | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- member_id → lab_member.member_id
- unit_id → equipment_unit.unit_id

## return_record

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| return_id | BIGINT | PK | Yes |
| booking_id | BIGINT | FK, Unique | Yes |
| returned_at | TIMESTAMPTZ |  | Yes |
| condition_note | TEXT |  | Yes |
- booking_id → booking_request.booking_id
- Unique key: (booking_id).

## Relationships and business rules

- requested_end must be strictly later than requested_start.
- status must be pending, approved, checked_out, returned or cancelled.
- Enforce uniqueness of unit_id only among rows whose status is approved or checked_out. Pending and historical requests do not participate in this partial unique constraint.
- service_state must be available, maintenance or retired.
- Each physical unit must have a distinct asset_tag.
- A booking may have at most one return record.
- Every return record must reference an existing booking; deletion of a referenced booking is restricted.

## Assumptions

- Each entity has one globally unique, single-column identifier. Identifiers are generated independently of student identities.
- Each request concerns one unit. Pending requests may coexist, but approved and checked_out requests are active and exclusively reserve that unit until returned or cancelled.
- Requested dates express intended use only. Future non-overlapping reservations are outside scope; an active booking reserves its unit immediately.
- Booking status is pending, approved, checked_out, returned or cancelled. Historical bookings are retained; referenced members, equipment and units are not deleted.
- Unit service_state is available, maintenance or retired. condition_note records physical condition. Effective availability requires service_state available and no active booking.
- A return record stores the observed return condition. Effective availability is derived; the unit condition_note is the latest recorded inspection summary.
- Normalisation example: start with a flattened equipment_unit record containing unit_id, asset_tag, equipment_id, equipment_name and category. Dependencies are unit_id determining asset_tag and equipment_id, and equipment_id determining equipment_name and category. Separate equipment from equipment_unit to remove the transitive dependency and obtain 3NF; equipment_unit is the example root and has one ancestor role.
- Separate benchmark plan: generate 20000 synthetic booking_request rows with varied requested_start dates. Compare the same selective date-range filter before and after adding the proposed B-tree index, holding data and parameters constant. Record execution plans and repeated measurement methodology; no benchmark is executed here.
- All sample records and MongoDB event payloads must be generated from fictional equipment and member labels, with no real student names or IDs.

