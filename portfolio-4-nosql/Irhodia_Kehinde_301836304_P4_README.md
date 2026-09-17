# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection lab_booking_events for request_submitted and booking_approved events. These are fictional event examples based on lab_member, equipment, equipment_unit, booking_request, return_record.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related equipment_unit details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "request_submitted",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "return_record",
        "key": {
            "return_id": 7
        },
        "snapshot": {
            "return_id": 7,
            "booking_id": 4,
            "returned_at": "2026-02-01T10:00:00Z",
            "condition_note": "Inspection complete; clean"
        }
    },
    "embedded": {
        "equipment_unit": [
            {
                "key": {
                    "unit_id": 3
                },
                "snapshot": {
                    "unit_id": 3,
                    "equipment_id": 2,
                    "asset_tag": "SYN-001",
                    "service_state": "available",
                    "condition_note": "Inspection complete; clean"
                },
                "via": [
                    "return_record.booking_id → booking_request.unit_id → equipment_unit"
                ]
            }
        ]
    },
    "references": {
        "lab_member": [
            {
                "key": {
                    "member_id": 1
                },
                "via": [
                    "return_record.booking_id → booking_request.member_id → lab_member"
                ]
            }
        ],
        "equipment": [
            {
                "key": {
                    "equipment_id": 2
                },
                "via": [
                    "return_record.booking_id → booking_request.unit_id → equipment_unit.equipment_id → equipment"
                ]
            }
        ],
        "booking_request": [
            {
                "key": {
                    "booking_id": 4
                },
                "via": [
                    "return_record.booking_id → booking_request"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("lab_booking_events").find({"eventType":"request_submitted"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "request_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "return_id": 7
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("lab_booking_events").find({"source.key.return_id":7}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "request_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "return_id": 7
    }
  },
  {
    "_id": "event_000002",
    "eventType": "booking_approved",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "return_id": 7
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("lab_booking_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "request_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "return_id": 7
    }
  },
  {
    "_id": "event_000002",
    "eventType": "booking_approved",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "return_id": 7
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("lab_booking_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| booking_approved | 1 |
| request_submitted | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Irhodia_Kehinde_301836304_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Irhodia_Kehinde_301836304_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)


## Interpretation of the sample events

The event labels and 2030 timestamps are controlled synthetic examples. Both documents use a saved return-record snapshot to demonstrate linked and embedded data. They are not a chronological replay of a real request and approval process.
