---
title: Secure Signing of JWT Tokens
draft: true
---

This article describes how JWT tokens can be securely signed in the presence of attacks on user authentication information and temporary compromising of signature keys.



## Elements

Let's define the core concepts and components of the solution:

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

- Authentication database -- contains, for each user:

  - username -- string that uniquely identifies the user
  - salt -- a random salt value for the user
  - password_hash -- the hash of the concatenation of the user's salt and user's password

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

## Attack scenarios

We will consider the following attack scenarios and how to respond in each case:

- **User salt and password_hash are compromised** -- 
- **Current valid signature key is compromised** -- 

