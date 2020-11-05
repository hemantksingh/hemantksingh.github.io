---
layout: post
title: Kubernetes certificate based mutual auth with different CAs
date: '2020-02-29T23:31:00.000-08:00'
author: Hemant Kumar
tags: kubernetes, aks, mutual-auth, ingress, nginx
categories: kodekitab
comments: true
modified_time: '2020-02-29T23:31:00.000-08:00'
---

Configuring certificate based mutual authentication in Kubernetes using nginx ingress controller is explained in [this](https://medium.com/@awkwardferny/configuring-certificate-based-mutual-authentication-with-kubernetes-ingress-nginx-20e7e38fdfca) post, however the post assumes that the certificates used for validating the client and the server are issued by the same CA (Certificate Authority). The [nginx ingress controller docs](https://kubernetes.github.io/ingress-nginx/examples/auth/client-certs/) also do not make it absolutely clear how to configure client certificate authentication when using client and server certificates issued by different CAs. I recently came up with a scenario where we use our own internal/private CA for issuing client certificates and a publicly trusted CA for server TLS. This post covers configuring kubernetes nginx ingress to use certificates issued by different CAs on the same host to perform mutual authentication.

