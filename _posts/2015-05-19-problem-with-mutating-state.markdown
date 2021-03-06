---
layout: post
title: Problem with mutating state
date: '2015-05-19T07:23:00.000-08:00'
author: Hemant Kumar
tags: functional
categories: kodekitab
comments: true
modified_time: '2015-08-03T23:50:46.244-08:00'
redirect_from: "/kodekitab/2015/05/19/problem-with-mutating-state.html"
---

The purpose of any computer program is to take some inputs and produce an output. Producing an output causes the program to have an effect which means during its execution cycle, the program changes certain values. A live program models the real world where things change frequently over time and in parallel. But while writing programs we only have a static view of the problem domain and with the best of intentions and tools at hand we try to manage state change in our program as it would happen in the real world. This leaves us having to deal with values that change over time. Are OO languages capable of handling this complexity easily or do we need to look further?


<blockquote>“No man ever steps in the same river twice, for it's not the same river and he's not the same man.” - *Heraclitus*</blockquote>

Rich Hickey in his [keynote](http://www.infoq.com/presentations/Are-We-There-Yet-Rich-Hickey) at the JVM Languages summit talked about value, identity and state. Values are essentially constants that do not change.  The flowing water in a river makes the river change constantly over time, this introduces the concept of identity. Identity is a succession of related values where the current one is caused from the previous. State is the value of an identity at a given time.

```java
1; // value (immutable)
int x = 1; // identity (variables are like rivers that change)
x = x + 1; // x changes state (introduces side effect)
```

An assignment statement however, mutates state and introduces the concept of time. The value of x changes before and after the assignment statement therefore time becomes important. The assignment statement separates the code above the assignment from the code below the assignment because other parts of the system that can access x can now have different views of x depending upon what time it is observed. If x is shared between multiple functions, objects or threads and either has the ability to assign to x, this can lead to *side effects*.

When you have a function that gives you a side effect then you need another function to undo the side effect. This leads to [**non deterministic**](https://en.wikipedia.org/wiki/Nondeterministic_algorithm) results  that introduce [**accidental complexity**](https://en.wikipedia.org/wiki/No_Silver_Bullet) (problems which engineers create and fix). For example a program whose output is influenced by the particular order of execution of threads or by a call to `gettimeofday` or some other non-repeatable thing is generally best considered as non-deterministic. This accidental complexity is inherent in OO languages. When you open a file you must also close it. Functions with side effects are also separated in time - opening a graphical context must precede closing it, using an unmanaged resource in .NET must always precede disposing it. If these functions are not called in the correct order it leads to memory leaks. OO languages support garbage collection to manage some side effects but not all.

# Managing side effects
One of the main ideas of Functional programming is to manage side effects. It enables programs to make decisions based on stable values rather than those that change over time (like rivers). Evaluation of a **pure function** or **higher order function** has *no side effects*. f(x) is always the same, no matter what. This leads to [**referential transparency**](https://wiki.haskell.org/Referential_transparency) which implies that provided a set of inputs a function will always result in the same output or it will have the same behaviour.

A pure function is **stateless** rather than stateful i.e it does not update any shared state/memory. This means that execution of a pure function has no effect on the output of the execution of any other function in your application. However in practice, applications do need to have some side effects.

<blockquote>"In the end, any program must manipulate state. A program that has no side effects whatsoever is a kind of black box. All you can tell is that the box gets hotter" - *Simon Peyton-Jones (Haskell contributor)*</blockquote>

The key is to limit side effects, clearly identify them, and avoid scattering them throughout your application. This can be achieved by having more and more pure functions inside your application that depend only on the input and return a value without:

* Accessing global memory/state
* Modifying input(s)
* Changing shared memory/state

It is interesting to note in an imperative style, the above situations result as a use of the assignment statement. Functional programs attempt to remove the non determinism and complexity in your application by containing side effects. This makes them easier to write and maintain:

* Without temporal coupling - order in which functions are called becomes irrelevant.
* Fewer concurrency issues due to restricted updates to shared memory/state.
* Less time spent in the debugger without having to constantly ask "*What is the application state ?*"

# Time to give up the assignment statement?

The addition of more cores to computer hardware means, the individual throughput of each core goes down but the throughput of the chip with multiple processors goes up, if you can take advantage of the multiple cores. In order to utilise all those cores, we will have to learn to write more pure functions. Our ability to write multi-threaded programs will depend upon the scarce and disciplined use of the assignment statement.
