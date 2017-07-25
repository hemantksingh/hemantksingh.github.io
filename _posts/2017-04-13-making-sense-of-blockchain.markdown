---
layout: post
title: Making sense of Blockchain
date: '2017-04-13T11:31:00.000-08:00'
author: Hemant Kumar
tags: blockchain, cryptocurrency, cryptography
categories: kodekitab
comments: true
modified_time: '2017-04-13T11:31:00.000-08:00'
redirect_from: "/kodekitab/2017/04/13/making-sense-of-blockchain.html/"
---

 **Trust** is fundamental to commerce. Any business transaction is based upon trust and requires secure way of transferring assets between transacting parties. Financial institutions like banks provide this trust by maintaining a true record of banking transactions. Government agencies provide evidence of land title, driving license records, medical records and other assets by often maintaining a ledger. They usually achieve this trust by maintaining a central store for recording transactions that can be relied upon to verify each transaction. This means that onus of maintaining the security and sanctity of this central store also lies with the authority owning it. This gives the central authority or the intermediary between the transacting parties, great responsibility as well as control. The intermediary can pretty much dictate the rules of commerce that every transacting party needs to abide by. The intermediary can also be a single point of failure. Can a single authority be trusted to prevent any illegitimate records being added or updated to the central store? How tamper proof is the central record and is it independently verifiable in a transparent manner in case of a dispute?

## Decentralized trust and control
Blockchain attempts to reduce the cost and increase trust in business transactions by using an immutable distributed transaction store on peer to peer networks rather than a central store. In simple terms rather than a single authority like a bank responsible for maintaining the transactions, it is now a group of people running blockchain servers that do this. They ensure that the information stored in the distributed ledger is immutable and verifiable by applying techniques like cryptography and hashing (explained below). This decentralized approach allows customers to make an exchange (e.g. pay for an item) without the involvement of an intermediary.

![Blockchain]({{ site.url }}/assets/blockchain.jpg)

## Underlying technology

* **Peer to peer network**
A group of computers that can communicate among
themselves without relying on a single central authority or having a single point of failure

* **Asymmetric cryptography**
A way to send a message encrypted for specific recipients
such that anyone can verify the sender’s authenticity but
only intended recipients can read the message contents

* **Cryptographic hashing**
A way to generate a small, unique “fingerprint” for any data allowing quick comparison of large data sets and a secure way to verify data has not been altered. A simplified explanation of cryptographic hashing is available [here](https://www.miracl.com/press/the-essence-of-the-blockchain).

### How do we ensure the rules are being followed?

 * Group of people who maintain the distributed ledger are called bookkeepers. Transactions often reach different bookkeepers in different order, depending upon which bookkeeper is online. Bookkeepers need to agree on the order of transactions and  rules about money creation, version of software to run and the transaction formats.

 * Periodically bookkeepers are allowed to add money to their own accounts, thereby creating money out of thin air. But this is only allowed according to very constrained rules. Those rules include a gradual very slow rate of money creation, until no more money can be created.

* Math based voting system to determine what the majority thinks. Bitcoin requires bookkeepers to solve a very special math problem to vote. Voting has a cost in terms of electricity and computing power, making it prohibitively costly for anyone to control the vote. This is called *"Proof of work"* explained in the original Bitcoin white paper *"one vote per CPU"* instead of one vote per person.

* Voting is allowed to happen every 10 minutes to allow all bookkeepers to stay synchronized. Each new group of transactions that gets approved is called a block and these blocks are grouped together in a chain called the **blockchain**.


## Impact on financial services
* Due to the lack of trust, very little data is shared amongst financial institutions. Blockchain reduces this trust deficit and can allow seamless transfer of digital assets within a business network and better sharing of data across businesses.
* Creation of secured, shared data with common standards - a public distributed ledger that keeps a record of all financial transactions.
* Reduced need for reconciliation at both ends of the business (purchaser and supplier).
* Certification of documents without having to go to a central certifying authority.

## Impact on IOT
The trust gap in commerce is on the rise. Identity fraud alone keeps setting new records every year. Today we transact not only with humans but machines and smart devices. How do we trust all the new IOT devices that are coming online? One prediction suggests that by 2020 we will have 7 times more smart devices than we have human beings in the world. That's about 50 billion devices in 2020 that we'll have to transact with and that we'll have to trust. Blockchain allows
* Securely share any information between machines, including connected vehicles, smart appliances, or manufacturing equipment.
* Once these devices can be trusted, they might be able to order their own spare parts, optimize packing of materials, or pay for their own electricity.
