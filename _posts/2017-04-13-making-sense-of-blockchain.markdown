---
layout: post
title: Making sense of Blockchain
date: '2017-04-13T11:31:00.000-08:00'
author: Hemant Kumar
tags: blockchain, cryptocurrency, cryptography
categories: kodekitab
comments: true
modified_time: '2017-04-13T11:31:00.000-08:00'
---

 Any business transaction is based upon trust and requires secure way of transferring assets between transacting parties. Financial institutions like banks provide this trust by maintaining a true record of their business transactions that can be relied upon to verify each transaction. They usually achieves this by maintaining a central store for recording these transactions. Blockchain attempts to reduce the cost and increase trust in business transactions by using distributed transaction store on peer to peer networks rather than a central authority. In simple terms rather than a single authority like a bank responsible for maintaining the transactions, it is now a group of people running blockchain servers that do this. This decentralized approach allows customers to make an exchange (e.g. pay for an item) without third party involvement. This has profound implications for a wide variety of business processes in the financial, healthcare and the energy industry to name a few.

 * Group of people who maintain the distributed ledger are called bookkeepers. Transactions often reach different bookkeepers in different order, depending upon which bookkeeper is online. Bookkeepers need to agree on the order of transactions and  rules about money creation, version of software to run and the transaction formats.

 * Periodically bookkeepers are allowed to add money to their own accounts, thereby creating money out of thin air. But this is only allowed according to very constrained rules. Those rules include a gradual very slow rate of money creation, until no more money can be created.

### How do we ensure these rules are being followed?

 Math based voting system to determine what the majority thinks. Bitcoin requires bookkeepers to solve a very special math problem to vote. Voting has a cost in terms of electricity and computing power, making it prohibitively costly for anyone to control the vote. This is called *"Proof of work"* explained in the original Bitcoin white paper *"one vote per CPU"* instead of one vote per person.

 Voting is allowed to happen every 10 minutes to allow all bookkeepers to stay synchronized. Each new group of transactions that gets approved is called a block and these blocks are grouped together in a chain called the **blockchain**.


* Blockchain is a distributed transaction log, looking at which you can tell what transactions happened at what time. Interested parties want to get together and want to act upon the same data but they don't really trust each other, don't really want to write the APIs to send the data amongst themselves, instead they all just want to work on this distributed log.

* Need for people to compute on shared data.

* Save reconciliation costs on business transactions at both ends of the business (purchaser and supplier).
* Certification of documents without having to go to a central certifying authority.


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



## Impact on financial services

* Creation of secured, shared data with common standards (a public distributed ledger that keeps a record of all financial transactions)
* Reduced need for reconciliation
* Seamless transfer of digital assets within a business network


## Impact on IOT

* Securely share any information between machines, including connected vehicles, smart appliances, or manufacturing equipment.
* Machines might be able to order their own spare parts, optimize packing of materials, or pay for their own electricity.
