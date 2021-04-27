---
title: The Essence of Blockchain Technology for IT Practitioners
date: 2021-04-24
lastmod: 2021-04-27
---

# The Essence of Blockchain Technology for IT Practitioners

This brief article describes the essence of Blockchain technology in terms that many IT professionals are familiar with.  The references at the end elaborate on the core concepts touched-upon here.

## Capabilities

A **blockchain** or **distributed ledger** is essentially a replicated database with the following capabilities.  These capabilities are largely common to both public (permissionless) and private (permissioned) blockchains:

<br>

1. **An irrefutable and tamper-proof database log -- the ledger** 
    - *Irrefutable* means that, once a transaction is accepted and there is consensus that it is valid see below), it cannot be refuted (synonyms: denied, repudiated).
    - *Tamper-proof* means that, once a transaction is accepted and there is consensus that it is valid see below), it cannot be deleted, or modified.
    - This doesn't preclude, however, another valid transaction  from reversing or adjusting the original transaction -- but the original transaction will always be preserved in the log.
2. **The ledger is replicated, with eventual consistency through consensus**
    - There is a replication process and a [consensus](https://en.wikipedia.org/wiki/Consensus_(computer_science)) process to ensure [eventual consistency](https://en.wikipedia.org/wiki/Eventual_consistency) of all ledger replicas and automatically resolve replication conflicts.
    - Different *participants* can have their own (one or more) replicas.  ***Participants*** are entities that can participate in the replication and consensus processes.
4. **Transaction validation rules** that govern what entries can be added to the ledger
5. **Views that support efficient queries** (e.g., using indices rather than forcing traversal of the log)
6. **Rules that govern participants' and users' access to the data**, including but not limited to:
    - Viewing of data.
    - Addition of entries to the ledger.
    - Creation of ledger replicas.
    - Participation in the replica consensus process.
7. **Rules that govern approval to grant access for participants and users**
   - Approval processes to grant aforementioned data access rights to participants and users.
   - Approval processes to grant approval rights to participants and users (i.e., so that a participant or user can participate in the approval process for other participants or users).
8. **APIs to provide controlled access to the above capabilities**



## Comments

The term *[blockchain](https://en.wikipedia.org/wiki/Blockchain)* comes from the technique used to implement [Bitcoin](https://en.wikipedia.org/wiki/Bitcoin)'s ledger.  A similar technique or some variant of it is used in the implementation of the ledgers for most blockchain products.

Capabilities 1, 2, and 3 above are the most fundamental and are truly the essence of blockchain technology.  The consensus process and transaction validation rules vary greatly across blockchain products.  Some blockchain products (e.g., [Hyperledger Indy](https://www.hyperledger.org/use/hyperledger-indy)) have multiple ledgers, each supporting different transaction types.

Capability 4 is present to some extent in all blockchain products, but can vary greatly.  For example, this capability is fairly limited in the case of the [Bitcoin](https://en.wikipedia.org/wiki/Bitcoin) blockchain.

Capabilities 5 and 6 are the key differentiators between private and public blockchains.  They can vary greatly across blockchain products.  In the case of public blockchains, anyone can join and access the data, no approval is required.  Some blockchain products (e.g., [Hyperledger Indy](https://www.hyperledger.org/use/hyperledger-indy)) have some aspects that are public and others that are permissioned.

Capability 7 is present in all blockchains but varies greatly by product.



## References

[Blockchain basics: Glossary and use cases](https://developer.ibm.com/technologies/blockchain/tutorials/cl-blockchain-basics-glossary-bluemix-trs/)

[Blockchain Technology Overview](https://www.nist.gov/publications/blockchain-technology-overview)

