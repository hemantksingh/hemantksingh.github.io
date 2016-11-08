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

Docker is pretty cool, the ability to completely abstract the underlying operating system (OS) and run your app across multiple platforms is pretty awesome. With Docker, the Continuous Delivery philosophy *Build once deploy anywhere* really comes to the fore. You build your binary artifact as a Docker image that includes all the application stack and requirements once and deploy the same image to various environments. This ensures the binary is built once and the same source code is promoted in subsequent deployments. I have been using Docker for local development, testing as well as in production. It is great to get started with when setting up local builds and running tests in a repeatable manner. But running Docker in a production environment is a different cup of tea. You need to be aware of the potential security risks and their mitigation.

## The Basics
Docker is a virtualization technique used to create isolated environments called *containers* for running your applications. A container is quite like a VM but light-weight, it is a bare minimum linux machine with minimum packages installed which means it uses less CPU, less memory and less disk space than a full blown VM. Containers are more like application runtime environments that sit on top of the OS (Docker host) and create an isolated environment in which to run your application.

Docker uses the resource isolation features of the Linux kernel such as **cgroups** and **kernel namespaces**, and a **union file system** (such as AUFS) to allow independent isolated containers to run within a single Linux instance. *Namesapces* allow resources to have separate values on the host and in the container; for example PID 1 inside a container is not PID 1 on the host.  However not all resources that a container has access to are *namespaced* i.e they are not isolated on the host and in the containers. Containers running on the same host still share the same operating system kernel and any kernel modules.

## Things that could go wrong
So what sort of security issues should you be worried about that could be exploited? I was at a GOTO conference in Stockholm this year and [Adrian Mout](https://twitter.com/adrianmouat) speaking on Docker security highlighted some mentioned below. The following list is not a comprehensive one but should get you thinking. You can look at [CIS Docker Benchmark](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.11.0_Benchmark_v1.0.0.pdf) to get an elaborate list of security recommendations.

* ***Kernel exploits***: The kernel is shared amongst all the containers and the host. A flaw in the kernel could be exploited by a container process which will bring down the entire host.

* ***Denial of service***: All containers share the kernel resources. If one container manages to hog kernel resources like CPU, memory or block I/O, it can starve the other containers on the host for resources, resulting in a denial of service attack.

* ***Container breakouts***: Running as root on the container means you will be root on the host. Therefore you need to worry about *escalated privileges* attack where a user can gain root access on the host due to a vulnerability in the application code. If an attacker gains access to one container that should not allow access to other containers or the host. Therefore it becomes important to run your container with restricted privileges.

* ***Tampered images***: You need to be sure that the image that you are running is from a trusted source and not from an attacker who has tricked you. The images that you run should also be up to date, scanned and without any known security vulnerabilities.

* ***Secret Distribution***: Secrets for your applications (like API keys and Database passwords) need to be protected from falling into the wrong hands. You need to be very careful before putting these as plain text in source code; for example in a Dockerfile. Once the secret has made it into the Dockerfile, even if you remove the secret later, an attacker can still retrieve it from the history of the Docker image built from the Dockerfile. Ideally using a secret vault for storing application secrets and allowing restricted access to the secret vault serves as a secure mechanism to distribute secrets.

## Mitigations

Now that we know the possible security issues with containers, following are some precautions that can be taken in order to mitigate the security risks.

### Host and kernel
Use a good quality supported host system for running containers with regular security updates. Keep the kernel updated with the latest security fixes. The security of the kernel is paramount.

### Run containers with
  * Minimum set of privileges (non admin). A docker container runs as root by default, if there is no user specified.
  * Readonly file system
  * Specified resources (CPU and memory)
  * No access to privileged ports


### Docker images
* Only run images from trusted parties.
* Run regular scans on your docker images for vulnerabilities.
* If needed, remove unwanted packages with major and critical vulnerabilities from the base image to reduce the attack surface.
