---
layout: post
title: Making sense of Blockchain
date: '2017-04-13T11:31:00.000-08:00'
author: Hemant Kumar
tags: blockchain, cryptocurrency, cryptography
categories: kodekitab
comments: true
modified_time: '2020-08-18T06:15:00.000-08:00'
redirect_from: "/kodekitab/2017/04/13/making-sense-of-blockchain.html/"
---

 **Trust** is fundamental to commerce. Any business transaction is based upon trust and requires secure way of transferring assets between transacting parties. Financial institutions like banks provide this trust by maintaining a true record of banking transactions. Government agencies provide evidence of land title, driving license records, medical records and other assets by often maintaining a transaction log. They usually achieve this trust by maintaining a central store for recording transactions that can be relied upon to verify each transaction. This means that the onus of maintaining the security and sanctity of this central store also lies with the authority owning it. This gives the central authority or the intermediary facilitating commerce between the transacting parties, great responsibility as well as control. The intermediary can pretty much dictate the rules of commerce that every transacting party needs to abide by. The intermediary can also be a single point of failure.

* Can a single authority prevent any illegitimate records being added or updated to the central store?
* How tamper proof is the central store and is it independently and transparently verifiable in case of a dispute?
* How efficient is the intermediary in fulfilling the transactions? Machine to machine communication takes place at a mind boggling rate but machine to machine payments can sometimes take days to clear because they have to go through the intermediary's centralized clearing system.

## Decentralized trust and control

Blockchain attempts to reduce the cost and increase trust in business transactions by using an immutable distributed transaction store on peer to peer networks rather than a central store. In simple terms rather than a single authority like a bank responsible for maintaining the transactions, it is now a group of people running blockchain servers that do this. They ensure that the information stored in the distributed ledger is immutable and verifiable by applying techniques like cryptography and hashing (explained below). This decentralized approach allows customers to make an exchange (e.g. pay for an item) without the involvement of an intermediary.

![Blockchain]({{ site.url }}/assets/blockchain.jpg)

## Underlying technology

* **Peer to peer network**
A group of computers that can communicate among themselves without relying on a single central authority or having a single point of failure.

* **Asymmetric cryptography**
A way to send a message encrypted for specific recipients such that anyone can verify the sender’s authenticity but only intended recipients can read the message contents.

* **Cryptographic hashing**
A way to generate a small, unique “fingerprint” for any data allowing quick comparison of large data sets and a secure way to [verify data has not been altered](https://www.miracl.com/press/the-essence-of-the-blockchain).

### How do we ensure the rules are being followed?

* Group of people who maintain the distributed ledger are called bookkeepers. Transactions often reach different bookkeepers in different order, depending upon which bookkeeper is online. Bookkeepers need to agree on the order of transactions and  rules about money creation, version of software to run and the transaction formats.

* Periodically bookkeepers are allowed to add money to their own accounts, thereby creating money out of thin air. But this is only allowed according to very constrained rules. Those rules include a very slow gradual rate of money creation, until no more money can be created.

* Math based voting system to determine what the majority thinks. Bitcoin requires bookkeepers to solve a very special math problem to vote. Voting has a cost in terms of electricity and computing power, making it prohibitively costly for anyone to control the vote. This is called *"Proof of work"* explained in the original Bitcoin white paper *"one vote per CPU"* instead of one vote per person.

* Voting is allowed to happen every 10 minutes to allow all bookkeepers to stay synchronized. Each new group of transactions that gets approved is called a block and these blocks are grouped together in a chain called the **blockchain**.

## Impact on financial services

* Due to the lack of trust, very little data is shared amongst financial institutions. Blockchain reduces this trust deficit and can allow seamless transfer of digital assets within a business network and better sharing of data across businesses.
* Creation of secured, shared data with common standards - a public distributed ledger that keeps a record of all financial transactions.
* Reduced need for reconciliation at both ends of the business (purchaser and supplier).
* Certification of documents without having to go to a central certifying authority.

## Impact on Public Key Infrastructure (PKI)

The most commonly employed approach to [Public Key Infrastructures (PKIs)](https://www.thesslstore.com/blog/wide-world-pki/) is the Web PKI. It is a Certificate Authority (CA) based system that adopts a centralized trust infrastructure. Communications over the internet are secured through the safe delivery of public keys and the corresponding private keys. PKI has been the backbone of Internet security since its inception through the use of digital certificates.

However, [issues with centralizing trust](https://medium.com/hackernoon/decentralized-public-key-infrastructure-dpki-what-is-it-and-why-does-it-matter-babee9d88579) also affect centralized PKIs such as CA-based systems. Because of the ability to impersonate another user or a website, CA systems are well-known targets for hackers. By breaching them, the bad guys gain access to a treasure-trove of personal and financial information traveling on the Internet. DigiNotar a Dutch CA whose systems were [attacked](https://www.wired.com/2011/09/diginotar-bankruptcy/) and many fraudulent certificates issued had to eventually file for bankruptcy. CAs are a single point of failure that can be exploited to compromise encrypted online communication. Blockchain acts as a decentralized, open and transparent key-value store and [eliminates traditional PKI vulnerabilities](https://remme.io/blog/how-blockchain-addresses-public-key-infrastructure-shortcomings). It is capable of securing data to prevent MITM (Man-in-the-Middle) attacks, and to minimize the power and fragilities of third parties.

## Impact on IOT

Today we transact not only with humans but machines and smart devices. How do we trust all the new IOT devices that are coming online? One prediction suggests that by 2020 we will have 7 times more smart devices than we have human beings in the world. That's about 50 billion devices in 2020 that we'll have to transact with and that we'll have to trust. In 1982, a [compromised software in the Trans-Siberian pipeline](https://en.wikipedia.org/wiki/At_the_Abyss) that controlled pump speeds and valve settings, produced pressures far beyond those acceptable to the pipeline joints and welds. This led to a three-kiloton, non-nuclear explosion so big that it was seen from space. There are [centralized PKI based solutions](https://www.digicert.com/internet-of-things/) to securing IOT device communications, however they are still prone to problems of centralized trust. Blockchain provides a decentralized PKI alternative by adopting *given enough eyeballs, all bugs are shallow* approach. This allows

* Securely sharing any information between machines, including connected vehicles, smart appliances, or manufacturing equipment in a decentralized manner without depending upon a single third party to secure your entire system.
* Providing open and transparent scrutiny to the adopted PKI security controls and protocols.
* Reacting fast to misuse by revoking certificates by making the process transparent, immutable, and prevent attackers from breaking in, thus effectively avoiding the MITM attacks.
