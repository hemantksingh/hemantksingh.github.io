---
layout: post
title: Securing REST APIs
date: '2017-08-10T11:31:00.000-08:00'
author: Hemant Kumar
tags: restapi, security, cryptography, authentication, HMAC, OAuth, digital signatures
categories: kodekitab
comments: true
modified_time: '2021-01-06T00:45:00.000-08:00'
---

RESTful services are stateless therefore each request needs to be authenticated individually. State in REST terminology means the state of the resource that the API manages, not session state. There maybe good reasons to build a stateful API but that is going against REST principles. It is important to realize that managing sessions is complex and difficult to do securely, as it is prone to replay and impersonation attacks. So what options do we have to secure RESTful services? This post looks into Basic Authentication, MAC (Message Authentication Code), Digital Signatures and OAuth.

## Security basics

When looking at any security aspect, often a lot of terms get thrown around which can be overwhelming and also confusing. Therefore, before looking at the nitty-gritty of securing RESTful APIs it is worth getting some security jargon out of the way.

* **Authentication** - Establish the sender's identity so that receiver knows **who** they are talking to; e.g. client (user, device, or another service/API) sends credentials (either in plaintext or encrypted) to the server to identify itself.

* **Authorization** - Verification **what** that the sender has access to. Happens post authentication to determine whether they have access to a certain resource.

* **Integrity** - Ensuring message contents of a request haven't changed in transit.

* **Non-repudiation** - Ensuring that the sender cannot deny having sent the message; e.g. your bank cannot deny having sent you a bank statement if it has a valid stamp of the bank on it and this could be proved to a third party.

* **Confidentiality** - No one can see the message contents in transit from sender to receiver.

In order to achieve secure communication, be it client to service or service to service, there are fundamentally two problems to solve:

1. Ensure that the message can only be read by the intended recipient.
2. Ensure that the message is from a known sender and it has not been modified in transit.

The first problem can be solved using encryption. Encryption is used to achieve **confidentiality** and  means only those with a corresponding secret key can read the message. However encryption alone does not guarantee **integrity**. The second problem can be solved using cryptography which often uses combination of encryption and [hashing](https://en.wikipedia.org/wiki/Cryptographic_hash_function) to achieve **authenticity** and **integrity** in addition to **confidentiality**.

### Symmetric (Private key cryptography)

You share the same secret key between sender and receiver to encrypt and decrypt the message. You can trust the **authenticity** (from a trusted known sender) of the message, its **confidentiality** and **integrity** but **non-repudiation** cannot be guaranteed. Because the secret key could be shared amongst several participants, there is no single identity attached to the key, therefore the receiver knows it came from a source in possession of the key but doesn't know which one. The risk of the key falling in the wrong hands is also higher because it needs to be securely shared amongst the participants, often over the internet. Other options include face-to-face meeting or use of a trusted courier but these can often be impractical. Higher the number of participants, higher is the exposure of the key.

### Asymmetric (Public key cryptography)

Different key is used between sender and receiver to encrypt and decrypt the message. This gets us beyond the shared key issue in symmetric key cryptography. In order to solve the first secure communication problem mentioned above, when encrypting, you use the **receiver's public key** to write (encrypt) the message and the receiver uses **their private key** to read (decrypt) the message. This establishes **confidentiality** of the message.

![end-to-end-encryption.png](../assets/end-to-end-encryption.png "End to End Encryption")

In order to solve the 2nd secure communication problem mentioned above, you use a [digital signature](https://en.wikipedia.org/wiki/Digital_signature). Digitally signing data is equivalent to a physical signature that can only be produced by the signing authority and verified by anyone who has visibility of the signing authority's signature. Signing uses public key encryption where the sender uses **their private key** to write message's signature, and the receiver uses the **sender's public key** to check if it's really from the sender. It is a means of attaching identity to a key. It is discussed in further detail in the section below on [message signing using digital signature](## Message signing using Digital Signature).

## Approaches to securing RESTful APIs

Having covered some security fundamentals, we can now look at the different techniques to secure RESTful APIs. The fundamentals discussed above form the basis of the techniques we are going to look at.

### Basic Authentication

The most simple way to authenticate senders is to use HTTP basic authentication. Sender's credentials (username and password) are base64-encoded and sent across the network unencrypted in an HTTP header.

```
GET / HTTP/1.1
Host: api.example.com
Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
```

There are a few issues with HTTP Basic Authentication:

* Credentials are sent over the wire and even though they are encoded, they are not encrypted and can easily be converted to plaintext.
* Credentials are sent repeatedly, for each request, which widens the attack window.
* The password may be stored permanently in the browser, if the user requests. The browser caches the password minimum for the length of the window / process, which can be silently used to make requests to the server e.g. in CSRF attacks.

Using HTTPS can solve the first issue. Even then, the credentials are only protected until SSL/TLS termination. Any internal network routing, logging, etc. can still expose the plaintext credentials. In an enterprise, SSL/TLS termination often occurs much before the request reaches your API server. Does HTTPS protect the credentials in transit? Yes. Is that enough? Usually, No. Basic Authentication with HTTPS provides you **confidentiality** only for a window during which  SSL/TLS is on.

### MAC (Message  Authentication Code)

Basic Auth over HTTP exposes credentials in transit and does not guarantee integrity of the message. MAC on the other hand is used to send hashed version of credentials and the message using a secret key. It can be used to **authenticate** a message and verify its **integrity**. MAC is symmetric, i.e. it uses the same key to produce a MAC value for a message and to verify the MAC value for the message.

![MAC.jpg](../assets/MAC.jpg "MAC")

For accessing a protected resource

```
/users/username/account
```

HMAC (Hash-based message authentication) an implementation of MAC involves calculation of an HMAC value

```
value = base64encode(hmac("sha256", "secret", "GET+/users/username/account"))
```

The HMAC value then is sent over as an HTTP header:

```
GET /users/username/account HTTP/1.1
Host: api.example.com
Authentication: hmac username:[value]
```

#### Prevent hash reuse

Hashing the same message repeatedly results in the same HMAC (hash). If the hash falls into the wrong hands, it can be used to make the same request at a later time. Therefore it is important to introduce entropy to the hash generation to prevent a [replay attack](https://en.wikipedia.org/wiki/Replay_attack). This is done by adding a **timestamp** and **nonce** to the hash computation. The nonce is a number we only use once and is regenerated on each subsequent request, even if the request is for the same resource.

```
value = base64encode(hmac("sha256", "secret", "GET+/users/username/account+28jul201712:59:24+123456"))
```

The additional data - timestamp and nonce is sent to the receiver for reconstructing the hash.

```
GET /users/username/account HTTP/1.1
Host: example.org
Authentication: hmac username:123456:[value]
Date: 28 jul 2017 12:59:24
```

The receiver reconstructs the hash with the nonce value and if it doesn't match the received hash value, discards the message possibly because the hash has been previously used. This ensures each request is only valid once and only once.

If the timestamp is not within a certain range (say 10 minutes) of the receiver's time, then the receiver can discard the message as it is probably a replay of an earlier message. It is worth noting time-limited authentications can be problematic if the sender and receiver's time is not synchronized.

### Message signing using Digital Signature

Digital signatures use asymmetric public key cryptography to establish **authenticity** (message sent by a known sender), **integrity** (message wasn't tampered with) and **non-repudiation** (message sent by the sender cannot be denied).

When signing, the sender uses their private key (also called a secret key, abbreviated to sk) to write message's signature, and the receiver uses the sender's public key to check if it's really from the sender. Again, to ensure a message cannot be duplicated and reused in a [replay attack](https://en.wikipedia.org/wiki/Replay_attack) a unique identifier for the message like **timestamp** and **nonce** is also used while generating the signature.

![message-signing.jpg](../assets/message-signing.jpg "Message Signing")

$Sign(Message, sk) = Signature$ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $Verify(Message, Signature, pk)$

When you have verified that the signature against a given message is valid, you can be extremely confident that the only way some one could have produced it is if they knew the private key, associated with the public key that you used to verify the message.

A service when acting as a **receiver** has a list of public keys for all other services that want to send messages to it. The same service, when acting as the **sender** can provides its public key to other services that it wants to send messages to.

### OAuth 2

OAuth 2 is an open protocol to allow secure authorization in a standard method from web, mobile and desktop applications. It is for **delegation of access** e.g. you hire a business assistant and delegate her to withdraw money from the business account to fulfill business requests on your behalf. You (the user) have delegated the authority to your assistant (client), however the authorization policy (identity and access control checks performed) to allow the assistant to withdraw money are still enforced by your bank account (resource API), not you.

In techniques mentioned above often it is your resource API that is responsible for establishing the identity of clients and defining access controls. Oauth enables [federated security](https://docs.microsoft.com/en-us/dotnet/framework/wcf/feature-details/federation) to allow clear separation between your applications and the associated authentication and authorization mechanism. Other identity protocols like [SAML](https://en.wikipedia.org/wiki/Security_Assertion_Markup_Language) and [WS-Fed](https://en.wikipedia.org/wiki/WS-Federation) also provide federated security but they are older and relatively more complex than OAuth.  Figure below depicts an [Oauth2 protocol flow](https://tools.ietf.org/html/rfc6749)

![oauth-protocol-flow.png](../assets/oauth-protocol-flow.png "OAuth Protocol Flow")

The separation between application (client) and **authorization server** means you can either

* build out the authorization server as a standalone component which is responsible for obtaining authorization from users and issuing tokens to clients
* outsource the authorization server as a service that the user trusts, such as a social identity provider like google or facebook

This allows you to focus on building and scaling your APIs (**resource server**) independent of authorization.

OAuth 2 has multiple [flows](https://www.oauth.com/oauth2-servers/differences-between-oauth-1-2/user-experience-alternative-token-issuance-options/) called *grant types* for obtaining an access token. [Deciding which grants to implement](https://developer.okta.com/authentication-guide/auth-overview/#choosing-an-oauth-20-flow) depends on the type of client applications you support and the experience you want for your users. In essence each flow involves obtaining authorization to get an access token and using the access token to access protected resources. An access token is a [JSON Web Token (JWT)](https://tools.ietf.org/html/rfc7519) encoded in base64URL format that contains a header, payload, and signature. A **resource server** (API) can [validate the access token](https://developer.okta.com/authentication-guide/tokens/validating-access-tokens#what-to-check-when-validating-an-access-token) and can authorize the client (application) to access particular resources based on the scopes and claims in the access token.

#### OpenId Connect Provider

OAuth is for authorization but applications require to know the users identity too. [OpenID Connect](http://openid.net/connect/) adds authentication to OAuth. In OAuth the client applications do not get any information about the user, it is only the resource APIs that get access to the identity data via the access tokens. OpenID Connect defines a standard way of providing this identity data to the client applications by giving them an ID token. Very often an OpenID Connect provider also acts as an OAuth server - which means you can request ID tokens as well as access tokens. This allows client applications to get information about who the user is and when they last authenticated and decide whether to re-authenticate or reject the user. E.g. for high value transactions the client may decide to re-authenticate the user even if they are already logged in.

An OpenId Connect Provider is a REST-like identity layer on top of OAuth 2 that allows clients to verify the identity of the end-user, as well as to obtain basic profile information about the end-user. It provides `/.well-known/openid-configuration` service discovery endpoint for clients to get information about interacting with the OpenId Connect/OAuth server.

## In summary

Before deciding on an API security approach, it is important to understand what are you going to secure and what is the sensitivity of the data being managed? APIs handling things like personal data, medical health records or financial data will need a different security approach than an API  handling, say traffic updates. It is also worth defining the scope of your API security. Securing network and server infrastructure for things like intrusion, eves dropping via packet sniffing and physical security often lie outside the scope of API security. Opting for a particular approach may depend on specific security requirements of your application because each technique provides protection on different security aspects. For example basic authentication without HTTPS can provide authenticity but no integrity or confidentiality. MACs may be sufficient for internal APIs (non public facing) serving a few web applications. For highly sensitive data, digital signatures maybe a necessity, but if you are looking for flexibility and performance at scale OAuth 2 Bearer tokens maybe the way to go.
