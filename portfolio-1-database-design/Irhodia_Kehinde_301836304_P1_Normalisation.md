# MIT 8103 laboratory equipment booking exercise — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| equipment_id | equipment_unit records (list) |
| --- | --- |
| 2 | [3] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| equipment_unit.unit_id | equipment_unit.equipment_id | equipment_unit.asset_tag | equipment.equipment_id | equipment.equipment_name |
| --- | --- | --- | --- | --- |
| 3 | 2 | SYN-001 | 2 | Demo Microscope |

Key: unit_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## equipment_unit_example

| equipment_unit.unit_id | equipment_unit.equipment_id | equipment_unit.asset_tag | equipment.equipment_id | equipment.equipment_name |
| --- | --- | --- | --- | --- |
| 3 | 2 | SYN-001 | 2 | Demo Microscope |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## lab_member

| member_id | member_label | joined_on |
| --- | --- | --- |
| 1 | Fictional Member Alpha | 2026-01-01 |

## equipment

| equipment_id | equipment_name | category |
| --- | --- | --- |
| 2 | Demo Microscope | Optics |

## equipment_unit

| unit_id | equipment_id | asset_tag | service_state | condition_note |
| --- | --- | --- | --- | --- |
| 3 | 2 | SYN-001 | available | Inspection complete; clean |

## booking_request

| booking_id | member_id | unit_id | requested_start | requested_end | status | created_at |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 1 | 3 | 2026-02-01T09:00:00+00:00 | 2026-02-01T10:00:00+00:00 | returned | 2026-01-31T08:00:00+00:00 |
| 5 | 1 | 3 | 2026-02-02T09:00:00+00:00 | 2026-02-02T10:00:00+00:00 | approved | 2026-02-01T12:00:00+00:00 |
| 6 | 1 | 3 | 2026-02-03T09:00:00+00:00 | 2026-02-03T10:00:00+00:00 | pending | 2026-02-01T13:00:00+00:00 |

## return_record

| return_id | booking_id | returned_at | condition_note |
| --- | --- | --- | --- |
| 7 | 4 | 2026-02-01T10:00:00+00:00 | Inspection complete; clean |

## Dependencies

- lab_member: (member_id) → member_label, joined_on
- equipment: (equipment_id) → equipment_name, category
- equipment_unit: (unit_id) → equipment_id, asset_tag, service_state, condition_note
- booking_request: (booking_id) → member_id, unit_id, requested_start, requested_end, status, created_at
- return_record: (return_id) → booking_id, returned_at, condition_note

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
