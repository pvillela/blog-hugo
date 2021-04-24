---
title: Notes on Blockchain
date: 2021-04-24
lastmod: 
---

# Notes on Blockchain

A blockchain is essentially a replicated database that consists of:

- A ledger
  - The ledger is a database log that is irrefutable and tamper-proof
  - The ledger is replicated and different participants have their own replicas
- Rules that govern what entries can be added to the ledger
- A replication process and a consensus process to ensure eventual consistency of all ledger replicas and automatically resolve replication conflicts
- Views that maintain indices and support efficient queries (rather than force traversal of the log)
- Rules that govern users' or potential users' access to the data, including but not limited to:
  - Viewing of data
  - Addition of entries to the ledger
  - Creation of ledger replicas
  - Participation in the replica consensus process
- Rules that govern the approval process to grant data access rights and access approval rights to users
- APIs to provide controlled access to the above capabilities

