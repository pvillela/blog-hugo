---
title: Simple and Resilient Architecture for Secure Signing of JWT Tokens
draft: false
date: 2021-04-04
---

This article describes an architecture for the signing of JWT tokens and how the solution fares when certain parts are compromised.



## Elements

These are the core concepts and components of the solution:

- Signature key -- a randomly generated string or byte array of appropriate length.

- Signature key validity periodicity -- a defined sequence of time periods during which a signature key is valid.  Examples:

  - One hour starting at the top of the hour.
  - 15 minutes starting at minutes 7, 22, 37, 52, etc.

- Current signature key -- the signature key generated for the current key validity period.

- Valid signature keys -- at any point in time, messages signed with any of the following keys will be accepted:

  - Previous valid key -- the valid signature key for the previous key validity period.
  - Current valid key -- the valid signature key for the current key validity period.  Messages signed during the current validity period must be signed with this key.
  - Next valid key -- the valid signature key for the next key validity period.

  By having 3 valid keys, the signature checking mechanism can tolerate short latency and clock synchronisation differences.

- Signature key generation service -- a clustered service that generates signature keys with a predetermined life duration as described above.  The instances in this cluster share a database, ideally 100% in-memory, that can only be accessed by them.  This service returns the 3 valid signature keys in effect at the time it is called.

- Signing service -- a service that signs messages using the current valid key obtained periodically from the signature key generation service.  Such a service may do other things and may also perform signature verification (see below).

- Signature verification service -- a service that verifies signed messages using the 3 valid keys obtained periodically from the signature key generation service.  Such a service may do other things and may also perform signature signing (see above).

- Authentication database

  - username -- string that uniquely identifies the user
  - salt -- a random salt value for the user
  - password_hash -- the hash of the concatenation of the user's salt and user's password
  - hash_creation_time -- the date/time when the hash was created



## Authentication process

The authentication process proceeds roughly as follows:

1. User submits username and password.
2. The user's salt and password_hash are retrieved.
3. The hash of the salt concatenated with the password is compared with the password_hash value.
4. If 3 above returns true:
   - Create a JWT token for the user
   - Sign the token with the current valid key
   - Return the token
5. Otherwise, the authentication attempt fails.



## Hash refresh process

This process refreshes each user's salt and password_hash when it gets sufficiently old:

- Defines a hash_fresh_duration parameter
- When the user authenticates with the correct password and the hash_creation_time  + hash_fresh_duration is greater than the current time then the authentication succeeds normally
- When the user authenticates with the correct password and the hash_creation_time  + hash_fresh_duration is less than the current time but hash_creation_time + 2 x hash_fresh_duration is greater than the current time, then the authentication succeeds and a new salt and password_hash are generated.  Notice that the generation can only happen when the user authenticates, as the password is required but it is not stored.
- When the user authenticates with the correct password and the hash_creation_time  + 2 x hash_fresh_duration is less than the current time, then the user is prompted to supply additional authentication information such as a one-time code texted to the user's phone.  Upon entry of the correct additional authentication information, the authentication succeeds and a new salt and password_hash are generated.

*Note: This process can be simplified, albeit with less security, by simply regenerating the salt and password_hash when the user authenticates with the correct password and hash_creation_time + hash_fresh_duration is less than the current time.*



## Compromise scenarios

We will consider the following scenarios and the respective responses and consequences in each case.

**User authentication database/service is compromised**

- If the compromise is known -- Response:
  - Shut down the authentication and signature verification services; notify users.
  - Reestablish the authentication database/service and signature verification services in an uncompromised environment.
  - Flag the user accounts to force users to reset passwords.

- If the compromise is not known -- This is hopefully a less-likely scenario in organisations with strong security monitoring.  There is no response in this case.  
  - In case the compromise is read-only -- Without knowing the passwords themselves, the attacker would, for a given user account, still have to create a password whose salted hash matches the one in the authentication database.  This could possibly be done by brute force.
  - In case the compromise allows the attacker to change the authentication database contents -- The attacker would have free reign to use the system until the compromise becomes known.

**Current valid signature key is compromised but signature key generation service is not**

- If the compromise is known -- Response: reset the signature key generation service and bounce all signing and signature verification services; notify users.
- if the compromise is not known -- This is hopefully a less-likely scenario in organisations with strong security monitoring.  There is no response in this case.  The attacker will be able to access accounts with known usernames, but only until the signature key expires.

**Signature key generation service is compromised**

- If the compromise is known -- Response:
  - Shut down the key generation service and all signing and signature verification services; notify users.
  - Reestablish the key generation service in an uncompromised environment.
  - Restart all signing and signature verification services.
- if the compromise is not known -- This is hopefully a less-likely scenario in organisations with strong security monitoring.  There is no response in this case.  The attacker will be able to access accounts with known usernames until the breach becomes known.