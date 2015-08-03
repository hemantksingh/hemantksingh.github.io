---
layout: post
title: Services, microservices, bounded context, actors.. the lot
date: '2015-07-30T07:23:00.000-08:00'
author: Hemant Kumar
tags: microservices, bounded context, soa
categories: kodekitab
comments: true
modified_time: '2015-08-03T08:08:46.244-08:00'
---

I was at the DDD exchange recently where we had the likes of [Udi Dahan](https://twitter.com/UdiDahan), [Eric Evans](https://twitter.com/ericevans0) and [Scott Wlaschin](https://twitter.com/ScottWlaschin) on the panel. In a post event Q&A session I asked the panel - *"Is microservices SOA renamed? "* which triggered an hour long debate. The panelists argued amongst themselves about what exactly a service or a microservice means. By the end of the debate I doubt any one was any more wiser. Clearly there was no consensus on the definition of the word service and what it means. It is a term that is widely used and abused in our industry but we do not seem to have a common understanding of it. This raised a few questions in my head. Disappointed with the expert advice, I decided to look out for a definition of my own.

The dictionary definition of a service is - *"the action of helping or doing work for someone"*. Is a microservice significantly different from a service? In order to come to a definitive answer, lets recollect the knowledge that is already out there. 

####*"Microservices aim to do SOA well, it is a specific approach of achieving SOA in the same way as XP and Scrum are specific approaches for Agile software development."* - Sam Newman (Building Microservices)####

Now according to SOA (Service orientated architecture) a service has the following tenets:

* Services are autonomous - Coherent single responsibility.
* Services have explicit boundaries - Loosely coupled, owns its data and business rules.
* Service share contract and schema, not Class or Type or a Database
* Service compatibility is based upon policy - Explicitly state the constraints (structural and behavioral) which the service imposes on its usage.

These tenets do not appear to be too different from the object oriented design principles. Can we define a service based on the above principles? Lets look at them a bit closely.  

#What is a Service?#

* Autonomy of a service suggests it is independent of other services to perform its tasks, therefore in order to be independent it needs to have one and only one well defined responsibility. It is a technical authority for a specific business capability. 
* Boundaries are drawn to restrict free movement and ensure all movement is governed by a set of rules. In the context of a service this restriction is enforced on free movement of data across a service boundary. All data and business rules reside within the service making the service autonomous and defining an explicit boundary.
* Services interact with other services through a shared contract by sending messages. These messages contain stable data (immutable, think events). The data going through service boundaries is minimal and very basic.
* Usage of a service enforces certain constraints, the incoming messages conform to an expected structure and format.

#What a service is NOT?#
* Anything with the word *Service* appended to it does not automatically qualify it to be a service.
* A service that has only a function is a function not a service, like calculation, validation. Making it remotely callable through RPC/SOAP still does not make it a service. A service is a bit more coarse-grained and it satisfies a business need.
* A service that has only data is a database not a service. Doing CRUD through REST over HTTP does not change that.

Philip Kruchten’s 4+1 [Architecture View Model](https://en.wikipedia.org/wiki/4%2B1_architectural_view_model) describes software architecture based on multiple concurrent views.

![alt text](https://upload.wikimedia.org/wikipedia/commons/f/f2/4%2B1_Architectural_View_Model.jpg "4+1 Architecture view model")

						4+1 Architecture View Model


I see defining services as breaking an overall system into smaller isolated sub systems so that adding features to the overall system requires touching as few sub systems as possible. This decomposition can be at the `logical level` (business capabilities - the reason for something to exist), `component level` (dlls, jars, source code repos), `process level` (web app, http endpoints) or the `physical level` (machines, hosts). **Bounded context** in DDD terminology focuses on the logical separation whereas **Micro service** focuses on the physical separation. The philosophy of slicing up your system into manageable chunks still remains.

Adding features will invariably involve touching more than one sub system at a given time but depending upon how well the system has been partitioned it should involve touching as few sub systems as possible. Loosely coupled systems allow failure isolation, allow services and consumers to evolve independently of each other and lower the risk of future changes, therefore reducing complexity, effort and cost.

