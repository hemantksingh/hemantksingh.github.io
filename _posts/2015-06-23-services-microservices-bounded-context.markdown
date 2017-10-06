---
layout: post
title: Services, microservices, bounded context, actors.. the lot
date: '2015-10-30T07:23:00.000-08:00'
author: Hemant Kumar
tags: microservices, bounded context, soa
categories: kodekitab
comments: true
modified_time: '2015-10-30T08:08:46.244-08:00'
redirect_from: "/kodekitab/2015/10/30/services-microservices-bounded-context.html"
---

I was at the DDD exchange recently where we had the likes of [Udi Dahan](https://twitter.com/UdiDahan), [Eric Evans](https://twitter.com/ericevans0) and [Scott Wlaschin](https://twitter.com/ScottWlaschin) on the panel. In a post event Q&A session I asked the panel - *"Is microservices SOA renamed? "* which triggered an hour long debate. The panelists argued amongst themselves about what exactly a service or a microservice means. By the end of the debate I doubt any one of us was any more wiser. Clearly there was no consensus on the definition of a microservice and what it actually means. It is quite a buzzword these days but none of the panelists could come to a common understanding. This raised a few questions in my head. Disappointed with the expert advice, I decided to look out for a definition of my own.

As what's needed in such a situation, I looked up the dictionary for the word service - *“the action of helping or doing work for someone”*. Does a microservice fit into this general definition? In order to come up with a more definitive answer, lets recollect the knowledge that is already out there.

<blockquote>“Microservices aim to do SOA well, it is a specific approach of achieving SOA in the same way as XP and Scrum are specific approaches for Agile software development.” - Sam Newman (Building Microservices)
</blockquote>

If microservices is about doing SOA (Service orientated architecture) well, it is probably worth looking at the SOA tenets:

* Services are autonomous - Cohesive single responsibility.
* Services have explicit boundaries - Loosely coupled, owns its data and business rules.
* Service share contract and schema, not Class or Type or a Database
* Service compatibility is based upon policy - Explicitly state the constraints (structural and behavioral) which the service imposes on its usage.

These tenets do not appear to be too different from the object oriented principles. According to Alan Kays 1971 [description of Smalltalk](http://wiki.c2.com/?AlanKaysDefinitionOfObjectOriented)
<blockquote>An object is a little computer that has its own memory, you send messages to it in order to tell it to do something. It can interact with other objects through messages in order to get that task done.</blockquote>

An object's private memory provides it the autonomy and  message based communication an explicit boundary from other objects. Can we define a service based on the above principles? Lets look at the tenets a bit closely.

# What is a Service?

* Autonomy of a service suggests it is independent of other services to perform its tasks, therefore in order to be independent it needs to have one and only one well defined responsibility. Uncle Bob has summarised Single Responsibility Principle rather well - *“Gather together those things that change for the same reason and separate those things that change for different reasons.”* In short a service should not have more than one reason to change.
* Boundaries are drawn to restrict free movement and ensure all movement is governed by a set of rules. In the context of a service this restriction is enforced on free movement of data across a service boundary. All data and business rules reside within the service imposing strict restrictions on any movement in and out.
* Services interact with other services through a shared contract by sending messages. These messages contain stable data (i.e. immutable, think events). The data going through service boundaries is minimal and very basic.
* Usage of a service enforces certain constraints, the incoming messages conform to an expected structure and format.

# What a service is NOT?
* Anything with the word *Service* appended to it does not automatically qualify as a service.
* A service that has only a function is a function not a service, like calculation, validation (not be confused with DDD's *Domain Services* which is a more granular concept). Making it remotely callable through RPC/SOAP still does not make it a service.
* A service that only has data is a database not a service. Doing CRUD through REST over HTTP does not change that.

Philip Kruchten’s 4+1 [Architecture View Model](https://en.wikipedia.org/wiki/4%2B1_architectural_view_model) describes software architecture based on multiple concurrent views.

![alt text](https://upload.wikimedia.org/wikipedia/commons/f/f2/4%2B1_Architectural_View_Model.jpg "4+1 Architecture View Model")

Defining services involves breaking an overall system into smaller isolated sub systems so that adding features to the overall system requires touching as few sub systems as possible. This decomposition can be at the `logical level` (business capabilities - the reason for something to exist), `component level` (dlls, jars, source code repos), `process level` (web app, http endpoints) or the `physical level` (machines, hosts). **Bounded context** in DDD terminology focuses on the logical separation whereas **Microservice** focuses on the physical separation. The idea of slicing up your system into manageable chunks is the key here.

# What is an Actor?
Actors is another decomposition model that allows dividing a system into smaller isolated tasks or actors that can run concurrently. Traditional approaches to concurrency are based on synchronizing shared mutable state which is difficult to get right, as it often involves locking and coordination. Wouldn't it be better not having to deal with coordinating threads, synchronization and locks? Actors achieve this by avoiding shared state and only mutating internal private state between processing messages. When there are no shared state mutations, synchronization and locking are no more required. When an actor wants to communicate with another actor, it sends a message rather than contacting it directly, all messaging being asynchronous. Apart from concurrency and performance gains there are other benefits with the actor based approach like hot code replacements but asynchronous programming is a whole new ballgame.

Asynchronous message communication allows Actors to embrace **latency**, potentially at the cost of **simplicity**. Asynchronous messaging is an event driven model as compared to synchronous model where you have a sequence of events that execute sequentially (in a given order) which in theory is easy (read familiar) to program and reason about.
An asynchronous model (event driven) on the other hand, allows you to scale better but you have to find a way to impose ordering on the incoming requests.

# In summary
Partitioning can occur at different levels, be it a service, a microservice, an actor or even an object. What we really gain from this partitioning is isolation. We want a small computer with private memory that you can interact with through a contract, without any access to its internal private state via  back doors. Isolation is easily compromised in objects. We often break encapsulation by sharing an object's private memory through public getters and setters in languages like Java and C#. Actors enforce this isolation by restricting access to private memory (internal state). Microservies make it even harder to break the isolation by often introducing physical separation and communication over a network.

<blockquote>Each service ends up having its own process or/and network boundary. The contract is a service updates it's shared memory and exposes a mechanism to read from its shared memory but the service itself is the only one that is allowed to write to it.</blockquote>

Turns out, there is nothing revelatory about microservices, rather they reinforce a lot of the old ideas like SOA and object oriented principles that we have known for sometime. Adding features to your system will invariably involve touching more than one sub system at a given time but depending upon how well the system is isolated, it should involve touching as few sub systems as possible. Isolation gives you all the good stuff - loosely coupled systems, failure isolation, independent evolution and scalability. But distributed mircoservices is not the only way to achieve isolation. Modularised monoliths can very well be isolated too, they probably need a bit more discipline.
