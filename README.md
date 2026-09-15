# University laboratory equipment booking system

Kehinde Irhodia | Student ID 301836304 | MIT 8103

## GitHub repository

https://github.com/elcharitas/Irhodia_Kehinde_301836304/tree/main

The link identifies the submission revision on `main`. The repository contains the five portfolio folders with SQL, JavaScript, explanations, query plans, result tables, and screenshots.

## Contents

1. [Database design](portfolio-1-database-design/): five tables, keys, constraints, an ER diagram, worked normalisation and 16 rejected invalid inserts.
2. [SQL and optimisation](portfolio-2-query-optimisation/): three queries and a measured index comparison using 20,000 separate synthetic performance rows.
3. [Transactions](portfolio-3-transactions-concurrency/): COMMIT, ROLLBACK, READ COMMITTED isolation and a two-session lost-update comparison with row locking.
4. [NoSQL](portfolio-4-nosql/): two synthetic MongoDB event documents, four queries and validator checks.
5. [Distributed design](portfolio-5-distributed-cloud/): a proposed replica-set architecture and discussion; no cloud deployment or failover test is claimed.

[Final summary](Irhodia_Kehinde_301836304_FinalSummary.md) | [Three-page PDF](Irhodia_Kehinde_301836304_FinalSummary.pdf)

## Reproduction

Use PostgreSQL 17 and MongoDB 7 in fresh exercise databases. Follow the README in each portfolio folder. Run the Portfolio 1 schema before its sample data. Portfolio 2 uses a separate performance table. Portfolio 3 adds a temporary exercise counter and requires two database sessions. Portfolio 4 uses mongosh. Deliberately invalid constraint statements are expected to fail; the recorded evidence shows their actual results.

## Scope and limitations

All records are fictional. Active bookings reserve a unit immediately; scheduling future non-overlapping reservations is outside scope. The SQL enforces keys, dates, allowed status values and one active booking per unit. Approval decisions, equipment-service eligibility and synchronising return records with booking status require application logic and are not implemented. MongoDB examples demonstrate document structure and queries, rather than replaying an actual booking lifecycle. The benchmark is a small local experiment, not a production performance guarantee.

## AI use and review

OpenAI Codex generated the case model and execution data through the local portfolio generator. PostgreSQL and MongoDB produced the saved results. Evidence images render those recorded results. References and the AI-use declaration appear in the final summary.
