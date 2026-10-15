// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("lab_booking_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("lab_booking_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "request_submitted",
                    "booking_approved"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "return_record"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "return_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the two example events and show their IDs.
  printjson(await db.getCollection("lab_booking_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "booking_approved",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "return_record",
                    "key": {
                        "return_id": 7
                    },
                    "field": "condition_note",
                    "value": "Inspection complete; clean"
                },
                {
                    "entity": "equipment_unit",
                    "key": {
                        "unit_id": 3
                    },
                    "field": "condition_note",
                    "value": "Inspection complete; clean"
                }
            ],
            "examples": {
                "unit_snapshot": "illustrative unit_snapshot",
                "return_details": "illustrative return_details",
                "cancellation_reason": "illustrative cancellation_reason"
            }
        }
    }
]));
  await db.getCollection("lab_booking_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("lab_booking_events").find({"eventType":"request_submitted"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("lab_booking_events").find({"source.key.return_id":7}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("lab_booking_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("lab_booking_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("lab_booking_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("lab_booking_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("lab_booking_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
