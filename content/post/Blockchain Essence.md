---
title: The Essence of Blockchain Technology for IT Practitioners
date: 2021-04-24
lastmod: 
---

# The Essence of Blockchain Technology for IT Practitioners

This brief article describes the essence of Blockchain technology in terms that many IT professionals are familiar with.

A blockchain is essentially a replicated database that consists of the following capabilities.  These capabilities are largely common to both public and permissioned (private) blockchains:

- A ledger
  - The ledger is a database log that is irrefutable and tamper-proof.  This means that, once a transaction is accepted and there is consensus that it is valid see below), it cannot be refuted (synonyms: denied, repudiated), deleted, or modified.  That doesn't preclude, however, another valid transaction  from reversing or adjusting the original transaction -- but the original transaction will always be preserved in the log.
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

