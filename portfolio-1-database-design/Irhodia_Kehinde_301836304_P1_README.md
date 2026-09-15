# Portfolio 1 — Database Design and Modelling

I organised the data into lab_member, equipment, equipment_unit, booking_request, return_record. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| lab_member | 1 |
| equipment | 1 |
| equipment_unit | 1 |
| booking_request | 3 |
| return_record | 1 |

The 16 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Irhodia_Kehinde_301836304_P1_Design.md)
- [ER diagram](Irhodia_Kehinde_301836304_P1_ERDiagram.md)
- [Normalisation](Irhodia_Kehinde_301836304_P1_Normalisation.md)
- [Schema](Irhodia_Kehinde_301836304_P1_Schema.sql)
- [Sample data](Irhodia_Kehinde_301836304_P1_SampleData.sql)
- [Constraint tests](Irhodia_Kehinde_301836304_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Irhodia_Kehinde_301836304_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)


## Prototype scope

The partial unique index prevents two active bookings for one unit. Approval decisions, checking a unit is in service, and synchronising a return record with booking status require application workflow. These cross-table operations are not implemented by this schema. Future reservation scheduling is outside scope.
