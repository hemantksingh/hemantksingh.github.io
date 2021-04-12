---
layout: post
title: Six rules for tech leadership
date: '2020-02-29T23:31:00.000-08:00'
author: Hemant Kumar
tags: technology, leadership, agile
categories: kodekitab
comments: true
modified_time: '2020-02-29T23:31:00.000-08:00'
---

Over the years I have lead some complex technical pieces of work with teams of varied sizes and location. This has involved optimizing working practices and processes of teams, advising management on building engineering capabilities, agile practices, technical governance and continuous delivery. As a technical leader, I have faced numerous challenges while trying to align team objectives, resolve conflicts, highlighting the importance of cross functional requirements to the business and managing technical risk. Learning from my mistakes I have devised a set of rules to help me overcome these challenges. The following six rules by no means is an exhaustive list but I'm hoping people working in technology will find them useful or at the least something they can relate to.

## Know your goal

"*If you don't know where you want to go, then it doesn't matter which path you take*" - Lewis Carroll

What's most important to you? This is a tough question to answer, because it requires you to think long and deep. Knowing yourself and knowing exactly what you want to achieve is a continuous process, therefore your answer may change over time. For example at this point I have the following priorities:

* Control and flexibility over the kind of work I do and when it is done
* Have a positive influence and a wider impact on a number of people (colleagues or customers) based on what I do

Having a clear purpose and repeating it often gives you the strength and the drive to lead by example and take others with you on the journey, even in the face of resistance. It is only when you have a clear understanding of what you want that you are going to be able to articulate it to others. Enabling others can only begin once you know what you want to achieve. People are going to take you seriously only if you are clear in your thinking. However, working in a business you also have certain immediate priorities at a given time. This could be a shared organisation goal or a team goal. The idea is to find that sweet spot where you align your personal goals with that of the business.

## Know your team

Leadership is about enabling others to achieve their true potential and getting the best out of people. Getting to know your team and the wider business by listening and engaging with them is crucial to be able to connect, build relationships and understand other people’s viewpoints.

"*If there is one secret of success, it lies in the ability to get the other person's point of view and see things from that person's angle as well as your own*" - Henry Ford

Empower others by aligning their individual goals with the team or organizational goals. Team goals often vary vastly and may even be contrary to each other, resulting in **silos** e.g Development teams want to push new features and functionality quickly to customers where as Operations want the systems to be resilient and can be averse to rapid change. Collaboration, not only within teams but across teams is required to figure out how disparate goals can be met keeping the overall business goals in mind. Some strategies that have worked for me in enabling teams to be self empowered capable of building, running and supporting their apps are

* Breaking organizational silos e.g. development & operations - changing the org set up by introducing **cross functional teams**
* Coaching & mentoring dev teams to be focussed on production readyness and support, right from project kick off. Delivering great apps is fine but in order for them to be effective you need the right tools (e.g. logging and monitoring tools) and processes in place to keep them running.
* Adopting similar tool set across build, delivery & ops teams that support collaboration e.g. adopting approaches like [GitOps](https://www.gitops.tech/)
* Pair programming within teams to prevent single point of failures.

## Get the business on-board

Technical leadership is a lot about meeting, influencing, planning and shaping the technical direction than hands-on work. Your hands-on experience may not be up to date, however you learn a lot about new tools and practices by seeing what the team is doing. Execs and management don't expect "architect" types to be hands-on. They *do* expect you to be able to talk authoritatively about technical topics at the high level. For example,

* What has proven to be useful approach to cloud migrations - IAAS, PAAS, FAAS etc?
* Impact of moving from capex to opex on budgeting (e.g. moving from owning a car to renting a car)
* Why invest in adopting continuous integration and continuous delivery?
* Sharing pitfalls of serverless
* Explaining where container orchestration has gone wrong on projects

This is the kind of stuff that you pick up through having lots of conversations with different people. The key qualification is your recommendations should be aligned to the experiences and wisdom of devs who actually do stuff. The goal is that if the business believes what the "architect" says, it will help the team to deliver as opposed to creating pain for them.

Before making any technology choices, think critically and innovatively - seeing situations in new ways, being able to deal with uncertainty and ambiguity. It is critical to get decisions right early in a project. Ensure the business goals are clear and aligned with the technical direction you want to pursue. While the execs may find your technical proposal amusing, what they are really interested in is:

* Cost
* Timeline
* Resources required
* Customer impact

## Visualize your tech strategy

Having a visual representation of your technology estate and capabilities allows you to

* share technical vision and direction with the entire organisation to get alignment & ensure everybody is pulling in the same direction
* identify gaps that could be filled with training
* achieve standardisation and assess new technologies for innovation

Light weight documentation that captures key technology decisions and choices helps in providing context not only to your team but also for future teams, who may want to evolve your technology landscape. [Architecture decision records](https://github.com/joelparkerhenderson/architecture_decision_record) is a useful technique that I have used to capture key architecture decisions on projects for visibility within the team and for external oversight.

Most of our time and energy is spent translating complex business rules into code, rather than thinking about the rules themselves. When you’re thinking in terms of a programming language, code constrains your ability to think, it can make you miss the forest for the trees. Therefore it is crucial to think before writing any code and to document your thinking. This could be your business architecture, system architecture or the associated data flows. Whilst documentation is important, it is also important for it to be easily consumable. Using a standard approach like [C4 model](https://c4model.com/) across all your artifacts for visualising your architecture, goes a long way in communicating and thinking above the code.

## Simplify not over engineer

Simplicity in software can be elusive because we often do not make the distinction between essential complexity and accidental complexity. Automation is a noble pursuit, however knowing what to automate and when, determines whether you are simplifying or over engineering. Before you go on an *"automate everything"* spree it is worth thinking about

* What percentage of your software is really complicated? How much of it actually impacts the business? Does the complex part absolutely need to be automated? Can the business deal with it manually or accept it as a risk?
* Are you designing a system that can never possibly fail? Trying to handle *"every possible thing"* that can go wrong in your system leads to accidental complexity. Perform a cost benefit analysis of your design choices and think if all of them are worth investing time and money.
* Are you doing premature generalisation? When do you prioritise extensibility and generalisation in your software because each of them has simplicity and cost trade offs?
* Do you adopt bleeding edge tech or something that works? *Boring is good*. Are you experimenting with new tech at the core of your system or at the periphery?
* Are you optimising for the things that can be easily seen and measured (e.g. code repetition) while ignoring software complexity that can be hard to measure?
* Are you a victim of tech overuse? Technology can solve a lot of problems but overusing it can cause more problems that it can solve. *With a hammer everything looks like a nail*. You can let humans deal with the edge cases, especially early on in a project.

## Adopt tools and tech fit for purpose

"*Technology can bring benefits if and only if it diminishes a limitation*" - Eliyahu Goldratt

Before adopting any new technology, it is important to do an objective evaluation of:

* What is the **power** of the technology?
* What **limitation** does the technology diminish? How can you prove that the limitation is holding you back? How would you know it was diminishing? What could you measure?
* What **existing rules** enable us to manage this limitation? Do we need to be wedded to those rules? Who owns the rules? Who might be threatened by dismantling them? How can we make it safe to change? How to create a graceful exit?
* What **new rules** will we need? How can we safely exploit this new technology? How do we introduce and institutionalise these new rules across the business?

As a principle - chose the best tools and implementations available over standardising on any one language or platform and resentfully accepting its inherent limitation. Select a tool/programming language keeping business goals in mind to optimise for the right combination of

* Cost of the service
    * Runtime cost - current vs future, cost variance with scale and additional capabilities  
    * Cost of operation and support
* Fit for purpose
    * Minimal lock-in (choice)
    * Ease and speed of development (agility)
    * Tech capability of the business (support)
    * Availability of existing libraries/integrations (flexibility)
* Performance & security
* Openness - can't do it alone, learn from shared practices and best ideas in the open source community, no vendor lock-in, contribute & attract talent. e.g. in your area it maybe easier to hire engineers for deploying and securing linux based systems than say windows.
