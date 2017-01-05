---
layout: post
title: Think Docker! Think Security!
date: '2016-11-07T07:23:00.000-08:00'
author: Hemant Kumar
tags: docker, microservices, security
categories: kodekitab
comments: true
modified_time: '2016-11-07T07:23:00.000-08:00'
---

Docker provides the flexibility to completely abstract the underlying operating system (OS) and run your app across multiple platforms (local machine, cloud, on-premise data centre) as long as the destination has the Docker runtime (Docker daemon) running. With Docker, the Continuous Delivery philosophy *Build once deploy anywhere* really comes to the fore. You build your binary artifact as a Docker image that includes all the application stack and requirements once and deploy the same image to various environments. This ensures the binary is built once and the same source code is promoted in subsequent deployments.

I have been using Docker for local development, testing as well as in production. It is great to get started with setting up local builds and running tests in a repeatable and consistent manner. But using Docker to run your app in production and putting it on the internet is a different ballgame. You need to be aware of the potential security risks and the mitigation techniques.

## The basics
Docker is a virtualization technique used to create isolated environments called *containers* for running your applications. A container is quite like a VM but light-weight. It is a bare minimum linux machine with minimum packages installed which means it uses less CPU, less memory and less disk space than a full blown VM. Containers are more like application runtime environments that sit on top of the OS (Docker host) and create an isolated environment in which to run your application.

Docker uses the resource isolation features of the Linux kernel such as **Namespaces**, **cgroups** and **capabilities** to allow independent isolated containers to run within a single Linux instance.

*Namesapces* allow resources to have separate values on the host and in the container; for example PID 1 inside a container is not PID 1 on the host.  However not all resources that a container has access to are *namespaced* i.e they are not isolated on the host and in the containers. Containers running on the same host still share the same operating system kernel and any kernel modules.

*cgroups* (abbreviated from control groups) is a Linux kernel feature that limits, accounts for, and isolates the resource usage (CPU, memory, disk I/O, network, etc.) of a collection of processes.

*Capabilites* are a set of privileges that can be independently enabled or disabled for a process to provide or restrict access to the system. Removing capabilities can cause applications to break, therefore deciding which ones to keep and remove is a balancing act. By default, Docker containers run with a subset of capabilities, so for example, a container will not normally be able to modify capabilities for other containers. A complete list of removed capabilities can be found on Daniel Walsh's [post](https://opensource.com/business/14/9/security-for-docker) on docker security.  

## Things that could go wrong
So what sort of security issues should you be worried about that could affect the way you run your apps inside containers? I was at a GOTO conference in Stockholm earlier in the year and [Adrian Mout](https://twitter.com/adrianmouat) speaking on Docker security highlighted some security issues mentioned below. The following is not a comprehensive list but one that should get you thinking.

* ***Kernel exploits***: The kernel is shared amongst all the containers and the host. A flaw in the kernel could be exploited by a container process which will bring down the entire host.

* ***Denial of service***: All containers share the kernel resources. If one container manages to hog kernel resources like CPU, memory or block I/O, it can starve the other containers on the host for resources, resulting in a denial of service attack.

* ***Container breakouts***: Running as root on the container means you will be root on the host. Therefore you need to worry about *escalated privileges* attack where a user can gain root access on the host due to a vulnerability in the application code. If an attacker gains access to one container that should not allow access to other containers or the host. Therefore it becomes important to run your container with restricted privileges.

* ***Tampered images***: You need to be sure that the image that you are running is from a trusted source and not from an attacker who has tricked you. The images that you run should also be up to date, scanned and without any known security vulnerabilities.

* ***Secret Leakages***: Secrets for your applications (like API keys and Database passwords) need to be protected from falling into the wrong hands. You need to be very careful before putting these as plain text in source code; for example in a Dockerfile. Once the secret has made it into the Dockerfile, even if you remove the secret later, an attacker can still retrieve it from the history of the Docker image built from the Dockerfile. Ideally using a secret vault for storing application secrets and allowing restricted access to the secret vault serves as a secure mechanism to distribute secrets.

## Mitigations

Now that we know some of the key container security issues, lets look at some ways to prevent them. You can look at [CIS Docker Benchmark](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.11.0_Benchmark_v1.0.0.pdf) to get an elaborate list of docker security recommendations. Defence in Depth is a common approach to security that involves building multiple layers of defences in order to hinder attackers. The following mitigations are based on securing the host, container and image in a container based environment.

### Host and kernel
Use a good quality supported host system for running containers with regular security updates. Keep the kernel updated with the latest security fixes. The security of the kernel is paramount.

### Run containers with
  * Minimum set of privileges (non admin). A docker container runs as root by default, if there is no user specified.
  * Limited file system (Readonly access)
  * Limited resources (CPU and memory)
  * No access to privileged ports


### Docker images
* Only run images from trusted parties.
* Run regular scans on your docker images for vulnerabilities.
* If needed, remove unwanted packages with major and critical vulnerabilities from the base image to reduce the attack surface.
