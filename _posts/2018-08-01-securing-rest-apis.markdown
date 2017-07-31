---
layout: post
title: Securing REST APIs
date: '2017-08-01T11:31:00.000-08:00'
author: Hemant Kumar
tags: restapi, security, cryptography, authentication
categories: kodekitab
comments: true
modified_time: '2017-08-01T11:31:00.000-08:00'
---

RESTful services are stateless therefore each request needs to be authenticated individually. State here means the state of the resource, not session state. There maybe good reasons to build a stateful API but that is going against REST principles. It is important to realize that managing sessions is complex and difficult to do securely. Leaving stateful services aside, what options do we have to authenticate RESTful services? This post looks into Basic Authentication, MAC (Message Authentication Code), Digital Signatures and OAuth as a means to secure REST APIs.

When looking at any security aspect, often a lot of terms get thrown around, which can be distracting and sometimes overwhelming. Therefore, before looking at the nitty-gritty of securing RESTful APIs it is worth getting some security jargon out of the way.

*Oversimplification Disclaimer - I have tried to explain the security basics in a general context, which might result in missing some of the technical nuances. Most of these terms are also applicable in a more wider security context.*

* **Authentication** - Validation of the sender's identity so that receiver knows who they are talking to; e.g. client sends credentials (either in plaintext or encrypted) to the server that validates them.

* **Authorization** - Verification that the sender has access to a certain resource. Happens post authentication.

* **Integrity** - Ensuring message contents of a request haven't changed in transit.

* **Non-repudiation** - Ensuring that the sender cannot deny having sent the message; e.g. your bank cannot deny having sent you a bank statement if it has a valid stamp of the bank on it.

* **Confidentiality** - No one can see the message contents in transit from sender to receiver.

In order to achieve secure communication, be it client to service or service to service, there are fundamentally two problems to solve:

1. Ensure that the message can only be read by the intended recipient.
2. Ensure that the message is from a known sender and it has not been modified in transit.

The first problem can be solved using encryption. Encryption is used to achieve **confidentiality** and  means only those with the corresponding secret key can read the message. However encryption alone does not guarantee **integrity**. The second problem can be solved using cryptography which often uses combination of encryption and [hashing](https://en.wikipedia.org/wiki/Cryptographic_hash_function) to achieve **integrity** and **authentication** in addition to **confidentiality**.

## Symmetric (Private key cryptography)
You share the same secret key between sender and receiver to encrypt and decrypt the message. You can trust the message was **authentic** (from a known sender), **confidential** and **integral** but **non-repudiation** cannot be guaranteed. Because the secret key could be shared amongst several participants, there is no identity attached to the key. The risk of the shared key falling in the wrong hands is also higher because the secret key needs to be shared amongst all participants. Other options include face-to-face meeting or use of a trusted courier but these can often be impractical.

## Asymmetric (Public key cryptography)
Different key is used between sender and receiver to encrypt and decrypt the message, which gets us around the shared key issue in symmetric key cryptography. In order to solve the first secure communication problem mentioned above, when encrypting, you use the **receiver's public key** to write (encrypt) the message and the receiver uses **their private key** to read (decrypt) the message. This establishes **confidentiality** of the message.

![end-to-end-encryption.png](../assets/end-to-end-encryption.png "End to End Encryption")

In order to solve the 2nd secure communication problem mentioned above, you use a [digital signature](https://en.wikipedia.org/wiki/Digital_signature). Digitally signing data is equivalent to a physical signature that can only be produced by the signing authority and verified by anyone who has visibility of the signing authority's signature. It is a means of attaching identity to a key. Signing uses public key encryption where the sender uses **their private key** to write message's signature, and the receiver uses the **sender's public key** to check if it's really from the sender. A valid signature establishes **authenticity** (message sent by a known sender), **integrity** (message wasn't tampered with) and **non-repudiation** (message sent by the sender cannot be denied).


# Approaches to securing RESTful APIs
Now that we have got the security semantics covered, we can look at the different techniques to secure RESTful APIs. It is worth noting that following techniques cover different aspects of security. Opting for a particular technique may depend on specific security requirements of your application. For example basic authentication without HTTPS can provide authenticity but no integrity or confidentiality.

## Basic Authentication
The most simple way to authenticate senders is to use HTTP basic authentication. Sender's credentials (username and password) are base64 encoded and sent across in an HTTP header.

```
GET / HTTP/1.1
Host: api.example.com
Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

There are a few issues with HTTP Basic Authentication:

* Credentials are sent over the wire and even though they are encoded, they are not encrypted and can easily be converted to plaintext.
* Credentials are sent repeatedly, for each request. (Larger attack window)
* The password is cached by the browser, at a minimum for the length of the window / process. (Can be silently reused by any other request to the server, e.g. CSRF).
* The password may be stored permanently in the browser, if the user requests. (Same as previous point, in addition might be stolen by another user on a shared machine).

Using HTTPS only solves the first issue. Even then, the credentials are only protected until SSL/TLS termination, any internal network routing, logging, etc. can expose the plaintext credentials. Does HTTPS protect the credentials in transit? Yes. Is that enough? Usually, No. Basic Authentication with HTTPS provides you **confidentiality** only for a window during which  SSL/TLS is on. In an enterprise, more often than not SSL/TLS termination occurs much before the request reaches your API server.

## MAC (Message  Authentication Code)
Basic Auth over HTTP exposes credentials in transit and does not guarantee integrity of the message. MAC on the other hand is used to send hashed version of credentials and the message. It can be used to **authenticate** a message and verify its **integrity**. MAC is symmetric, i.e. it uses the same key to produce a MAC value for a message and to verify the MAC value for the message.

![MAC.jpg](../assets/MAC.jpg "MAC")

For accessing a protected resource

```
/users/username/account
```

HMAC (Hash-based message authentication) an implementation of MAC involves calculation of a digest

```
digest = base64encode(hmac("sha256", "secret", "GET+/users/username/account"))
```

The digest then is sent over as an HTTP header:

```
GET /users/username/account HTTP/1.1
Host: api.example.com
Authentication: hmac username:[digest]
```

### Prevent digest (hash) reuse

Hashing the same message repeatedly results in the same digest. There's nothing stopping the digest falling into the wrong hands and being used to make valid requests. Therefore it is important to introduce some randomness to the hash generation to prevent a [replay attack](https://en.wikipedia.org/wiki/Replay_attack). This is done by adding more data (**timestamp** and **nonce**) to the digest computation.

```
digest = base64encode(hmac("sha256", "secret", "GET+/users/username/account+28jul201712:59:24+123456"))
```
The additional data (timestamp and nonce) is sent to the receiver for reconstructing the hash.

```
GET /users/username/account HTTP/1.1
Host: example.org
Authentication: hmac username:123456:[digest]
Date: 28 jul 2017 12:59:24
```
The nonce is a number we only use once and is regenerated on each subsequent request. The receiver needs to store the nonce ( probably for a particular duration) in order to discard a message with a nonce that has been previously used.

If the timestamp is not within a certain range (say 10 minutes) of the receiver's time, then the receiver can discard the message as it is probably a replay of an earlier message. It is worth noting time-limited authentications can be problematic if the sender and receiver's time is not synchronized.


## Message signing using Digital Signature
Digital signatures use asymmetric public key cryptography to
establish **authenticity** (message sent by a known sender), **integrity** (message wasn't tampered with) and **non-repudiation** (message sent by the sender cannot be denied).

When signing, the sender uses **their private key** to write message's signature, and the receiver uses the **sender's public key** to check if it's really from the sender. A **timestamp** and **nonce** is used to generate the signature. This helps to prevent replay attacks. The signature  prevents repurposing the request for something else entirely.

![message-signing.jpg](../assets/message-signing.jpg "Message Signing")

A service (when acting as a **receiver**) has a list of **public keys** for all other services that want to talk to it and provides its **public key** (when acting as a **sender**) to other services that it wants to talk to.

## OAuth2
OAuth2 is an open specification to allow secure authorization in a simple and standard method from web, mobile and desktop applications. It works for mobile, web and desktop clients.

Federated security allows for clean separation between the service and the associated authentication and authorization mechanism. Outsourcing authentication to a service that the user trusts, such as a social identity provider - facebook to cure password headaches across multiple applications.

OpenID Connect - REST identity layer on top of OAuth2. OAuth is for authorization but lot of applications require to know the users identity too. OpenID Connect adds identity to OAuth2.
