# MIT 8103 laboratory equipment booking exercise — ER diagram

```mermaid
erDiagram
    direction LR
    lab_member {
        bigint member_id PK
        text member_label
        date joined_on
    }
    equipment {
        bigint equipment_id PK
        text equipment_name
        text category
    }
    equipment_unit {
        bigint unit_id PK
        bigint equipment_id FK
        text asset_tag UK
        text service_state
        text condition_note
    }
    booking_request {
        bigint booking_id PK
        bigint member_id FK
        bigint unit_id FK
        timestamptz requested_start
        timestamptz requested_end
        text status
        timestamptz created_at
    }
    return_record {
        bigint return_id PK
        bigint booking_id FK,UK
        timestamptz returned_at
        text condition_note
    }
    equipment ||--o{ equipment_unit : "equipment_id"
    lab_member ||--o{ booking_request : "member_id"
    equipment_unit ||--o{ booking_request : "unit_id"
    booking_request ||--o| return_record : "booking_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Irhodia_Kehinde_301836304_ERDiagram.png)
