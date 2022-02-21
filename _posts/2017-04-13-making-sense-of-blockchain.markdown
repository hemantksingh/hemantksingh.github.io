---
layout: post
title: Making sense of Blockchain
date: '2017-04-13T11:31:00.000-08:00'
author: Hemant Kumar
tags: blockchain, cryptocurrency, cryptography
categories: kodekitab
comments: true
modified_time: '2022-02-21T19:26:00.000-08:00'
redirect_from: "/kodekitab/2017/04/13/making-sense-of-blockchain.html/"
---

 **Trust** is fundamental to commerce. Any business transaction is based upon trust and requires secure way of transferring assets between transacting parties. Financial institutions like banks provide this trust by maintaining a true record of banking transactions. Government agencies provide evidence of land titles, vehicle registration records, health and education records etc by maintaining a transaction log. They provide trust by maintaining a central store for recording transactions that can be relied upon to verify each transaction. The onus of maintaining the security and sanctity of this central store also lies with the authority owning it. This gives the central authority or the intermediary facilitating commerce between the transacting parties, huge responsibility as well as control. The intermediary pretty much dictates the rules of commerce that every transacting party needs to abide by. Sometimes the intermediary gets it right but occasionally it can also be a single point of failure e.g. in the global financial crash of 2008, banks were at the center of the economic turmoil.

* Can a centralized authority with utmost power be trusted to run and meddle with entire economic systems?
* Should the monetary supply and monetary policy be set by a computer where it could not be corrupted by humans, thereby preventing government overreach?
* Is the transaction store owned by the central authority tamper evident and prevent any illegitimate records being added or updated? Is it independently and transparently verifiable in case of a dispute?
* Are the intermediaries efficient in fulfilling monetary transactions? Communication over the internet takes place at a mind boggling rate but systems with layers of middlemen can take days to clear and reconcile.

## What is blockchain?

Shortly after the 2008 global financial crisis, a [white paper](https://bitcoin.org/en/bitcoin-paper) by an unknown entity Satoshi Nakamoto emerged. The paper introduced a new peer to peer financial system where payments are based on cryptographic proof instead of trust, allowing any two willing parties to transact directly with each other without the need for a trusted third party. The system would use a new digital crypto currency called Bitcoin. The technology invented to power this new system was called blockchain. Simply put, a blockchain is a continuously updated record of who holds what.

### Decentralized trust and control

Blockchain attempts to reduce the cost and increase trust in business transactions by using an immutable distributed transaction store on peer to peer networks rather than a central store. Rather than a single authority like a bank responsible for maintaining all transactions, it is now a group of people running blockchain software that do this. They ensure that the information stored in the distributed store is immutable and verifiable by applying techniques like cryptography and hashing. The list of transactions, also known as a **distributed ledger** is decentralized and available for everyone to see and verify. The distributed nature of the blockchain makes it tamper evident and unhackable because if a block is messed with, everyone gets to know about it and it is rejected by the system. Trust is inherently built into the system.

![Blockchain]({{ site.url }}/assets/blockchain.jpg)

### Underlying technology

* **Peer to peer network**
A group of computers that can communicate among themselves without relying on a single central authority or having a single point of failure.

* **Asymmetric cryptography**
A way to send a message encrypted for specific recipients such that anyone can verify the sender’s authenticity but only intended recipients can read the message contents.

* **Cryptographic hashing**
A way to generate a small, unique “fingerprint” for any data allowing quick comparison of large data sets and a secure way to [verify data has not been altered](https://www.miracl.com/press/the-essence-of-the-blockchain).

#### How do we ensure the rules are being followed?

* Group of people who maintain the distributed ledger are called bookkeepers. Transactions often reach different bookkeepers in different order, depending upon which bookkeeper is online. Bookkeepers need to agree on the order of transactions and rules about money creation, version of software to run and the transaction formats.

* Periodically bookkeepers are allowed to add money to their own accounts, thereby creating money out of thin air. But this is only allowed according to very constrained rules. Those rules include a very slow gradual rate of money creation, until no more money can be created.

* Math based voting system to determine what the majority thinks. Bitcoin requires bookkeepers to solve a very special math problem to vote. Voting has a cost in terms of electricity and computing power, making it prohibitively costly for anyone to control the vote. This is called *"Proof of work"* explained in the Bitcoin white paper *"one vote per CPU"* instead of one vote per person.

* Voting is allowed to happen every 10 minutes to allow all bookkeepers to stay synchronized. Each new group of transactions that gets approved is called a block and these blocks are grouped together in a chain called the **blockchain**.

## Where can blockchain be applied?

You can use the FITS model - Fraud, Intermediaries, Throughput, Stable data to understand the possibility of using blockchain applications in a particular environment. This could include

* Fraud - an environment which has a history and likelihood of fraud involved in various transactions, making international finance businesses the early adopters of blockchain.
* Intermediaries or middle men - areas where there are a lot of intermediaries involved who do not provide a lot of value, the application of blockchain can reduce transaction times from days to minutes by taking the middle men out.
* Throughput - environments with high throughput or number of transactions per second (tps). Bitcoin, currently can only process 7 transactions per second. Visa processes around 1,700 transactions per second on average, claiming to be able to support 24,000 tps. Mastercard utilizes a network that claims to handle around 5,000 tps. Researchers are working on increasing the Bitcoin throughput.
* Stable data - For a blockchain application you do not want volatile data, rather you want things that are going to stay the same for a while e.g. land ownership titles and personal information.

### Impact on financial services

* Due to the lack of trust, very little data is shared amongst financial institutions. Blockchain reduces this trust deficit and can allow seamless transfer of digital assets within a business network and better sharing of data across businesses.
* Creation of secured, shared data with common standards - a public distributed ledger that keeps a record of all financial transactions.
* Reduced need for reconciliation at both ends of the business (purchaser and supplier).
* Certification of documents without having to go to a central certifying authority.

### Impact on Public Key Infrastructure (PKI)

The most commonly employed approach to [Public Key Infrastructures (PKIs)](https://www.thesslstore.com/blog/wide-world-pki/) is the Web PKI. It is a Certificate Authority (CA) based system that adopts a centralized trust infrastructure. Communications over the internet are secured through the safe delivery of public keys and the corresponding private keys. PKI has been the backbone of Internet security since its inception through the use of digital certificates.

However, there are [problems with centralized PKIs](https://medium.com/hackernoon/decentralized-public-key-infrastructure-dpki-what-is-it-and-why-does-it-matter-babee9d88579) such as CA-based systems. Because of the ability to impersonate another user or a website, CA systems are well-known targets for hackers. If they get hacked you get hacked. By breaching them, the bad guys gain access to a treasure-trove of personal and financial information traveling on the Internet. DigiNotar a Dutch CA whose systems were [attacked](https://www.wired.com/2011/09/diginotar-bankruptcy/) and many fraudulent certificates issued had to eventually file for bankruptcy. CAs are a single point of failure that can be exploited to compromise encrypted online communication. Blockchain acts as a decentralized, open and transparent key-value store and [eliminates traditional PKI vulnerabilities](https://remme.io/blog/how-blockchain-addresses-public-key-infrastructure-shortcomings). It is capable of securing data to prevent MITM (Man-in-the-Middle) attacks, and to minimize the power and fragilities of third parties.

### Impact on IOT

Today we transact not only with humans but machines and smart devices. How do we trust all the new IOT devices that are coming online? One prediction suggests that by 2020 we will have 7 times more smart devices than we have human beings in the world. That's about 50 billion devices in 2020 that we'll have to transact with and that we'll have to trust. In 1982, a [compromised software in the Trans-Siberian pipeline](https://en.wikipedia.org/wiki/At_the_Abyss) that controlled pump speeds and valve settings, produced pressures far beyond those acceptable to the pipeline joints and welds. This led to a three-kiloton, non-nuclear explosion so big that it was seen from space. There are [centralized PKI based solutions](https://www.digicert.com/internet-of-things/) to securing IOT device communications, however they are still prone to problems of centralized trust. Blockchain provides a decentralized PKI alternative by adopting *given enough eyeballs, all bugs are shallow* approach. This allows

* Securely sharing any information between machines, including connected vehicles, smart appliances, or manufacturing equipment in a decentralized manner without depending upon a single third party to secure your entire system.
* Providing open and transparent scrutiny to the adopted PKI security controls and protocols.
* Reacting fast to misuse by revoking certificates by making the process transparent, immutable, and prevent attackers from breaking in, thus effectively avoiding the MITM attacks.
