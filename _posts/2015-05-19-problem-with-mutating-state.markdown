---
layout: post
title: Problem with mutating state
date: '2015-05-19T07:23:00.000-08:00'
author: Hemant Kumar
tags: functional
categories: kodekitab
comments: true
modified_time: '2015-07-27T23:50:46.244-08:00'
---

The purpose of any computer program is to take some inputs and produce an output. Producing an output causes the program to have an effect which means during its execution cycle, the program changes certain values. A live program models the real world where things change frequently over time and in parallel. But while writing programs we only have a static view of the problem domain and with the best of intentions and tools at hand we try to manage state change in our program as it would happen in the real world. This leaves us having to deal with values that change over time. Are OO languages capable of handling this complexity easily or do we need to look further?


*“No man ever steps in the same river twice, for it's not the same river and he's not the same man.” - Heraclitus*

Rich Hickey in his [keynote](http://www.infoq.com/presentations/Are-We-There-Yet-Rich-Hickey) at the JVM Languages summit talked about value, identity and state. Values are essentially constants that do not change and can be identified by an identifier. 

```java
1; // value
int x = 1; // identity
x = x + 1; // x changes state (introduces side effect)
```

An assignment statement however, mutates state and introduces the concept of time. The value of x changes before and after the assignment statement therefore time becomes important. The assignment statement separates the code above the assignment from the code below the assignment because other parts of the system that can access x can now have different views of x depending upon what time it is observed. If x is shared between multiple functions, objects or threads and either has the ability to assign to x, this can lead to *side effects*.

When you have a function that gives you a side effect then you need another function to undo the side effect. This **incidental complexity** is inherent in OO languages. When you open a file you must also close it. Functions with side effects are also separated in time - opening a graphical context must precede closing it, using an unmanaged resource in .NET must always precede disposing it. If these functions are not called in the correct order it leads to memory leaks. Our languages support garbage collection to manage some side effects but not all.


One of the main ideas of Functional programming is to manage side effects. Evaluation of a **pure function** f(x) is always the same, no matter what. A pure function is stateless rather than stateful. In practice, applications need to have some side effects. Simon Peyton-Jones, a major contributor to the functional programming language Haskell, said the following: *"In the end, any program must manipulate state. A program that has no side effects whatsoever is a kind of black box. All you can tell is that the box gets hotter."* The key is to limit side effects, clearly identify them, and avoid scattering them throughout the code.

* Functional programs are simpler which makes them easier to write and maintain.
* No temporal coupling - order in which functions are called becomes irrelevant.
* Fewer concurrency issues, there are isolated parts of a functional program that do some assignments.
* Never ask "What's the state?" While debugging a system you don't have to ask what the state of the system is.

#Is it time to give up the assignment statement?#

The addition of more cores to computer hardware means, the individual throughput of each core goes down but the throughput of the chip with multiple processors goes up if you can take advantage of the multiple cores. We as programmers may have to deal with multiple cores not the operating system any more. Our ability to write multi-threaded programs will depend upon the scarce and disciplined use of the assignment statement.