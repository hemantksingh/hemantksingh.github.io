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

Configuring certificate based mutual authentication in Kubernetes using nginx ingress controller is explained pretty well in [this](https://medium.com/@awkwardferny/configuring-certificate-based-mutual-authentication-with-kubernetes-ingress-nginx-20e7e38fdfca) post. However the post assumes that the certificates used for validating the client and the server are issued by the same CA (Certificate Authority). The current [nginx ingress controller docs](https://kubernetes.github.io/ingress-nginx/examples/auth/client-certs/) also do not make it absolutely clear how to configure client certificate authentication when using client and server certificates issued by different CAs. I recently came across a scenario where we were using our own internal/private CA for issuing client certificates and a publicly trusted CA for server TLS. This post covers configuring kubernetes nginx ingress to use certificates issued by different CAs on the same host to perform mutual authentication.

## Generating the certificates

Usually a [Certificate Signing Request](https://en.wikipedia.org/wiki/Certificate_signing_request) (CSR) is sent to a public CA to obtain a globally trusted certificate for securing your assets. You would not be in possession of a public CA key and certificate. However, for demonstration purposes below we will generate two separate CA certificates and then generate server and client certificates signed by each CA to configure kubernetes ingress.

```sh
# Generate a public CA Key and Certificate
$ openssl req -x509 -sha256 -newkey rsa:4096 -days 356 -nodes \
	-keyout public-ca.key \
	-out public-ca.crt \
	-subj '/CN=Public Cert Authority/O=Org Public CA/C=GB'

# Generate the Server Key and Server Certificate and Sign with the public CA Certificate
$ openssl req -new -nodes -newkey rsa:4096 \
	-out server.csr \
	-keyout server.key \
	-subj '/CN={EXTERNAL_IP}.nip.io/O=aks-ingress/C=GB'
$ openssl x509 -req -sha256 -days 365 \
	-in server.csr \
	-CA public-ca.crt -CAkey public-ca.key \
	-set_serial 01 \
	-out server.crt

# Generate an internal CA Key and Certificate
$ openssl req -x509 -sha256 -newkey rsa:4096 -days 356 -nodes \
	-keyout internal-ca.key \
	-out internal-ca.crt \
	-subj '/CN=Internal Cert Authority/O=Org Internal CA/C=GB'

# Generate the Client Key and Client Certificate and Sign with the internal CA Certificate
$ openssl req -new -nodes -newkey rsa:4096 \
	-out client.csr \
	-keyout client.key \
	-subj '/CN=local-client/O=aks-ingress-client/C=GB'
$ openssl x509 -req -sha256 -days 365 \
	-in client.csr \
	-CA internal-ca.crt -CAkey internal-ca.key \
	-set_serial 02 \
	-out client.crt
```

## Create the kubernetes secrets

```sh
# Add a secret for the internal CA certificate to validate client certs 
kubectl create secret generic internal-ca --from-file=ca.crt=internal-ca.crt

# Add a secret for server TLS (e.g. issued by a public CA) to validate server's identity
kubectl create secret tls server-tls --key server.key --cert server.crt
```

## Create the ingress rule

```sh

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    # Enable client certificate authentication
    nginx.ingress.kubernetes.io/auth-tls-verify-client: "on"
    # Create the secret containing the trusted ca certificates
    nginx.ingress.kubernetes.io/auth-tls-secret: "default/internal-ca"
    # Specify the verification depth in the client certificates chain
    nginx.ingress.kubernetes.io/auth-tls-verify-depth: "1"
    # Specify if certificates are passed to upstream server
    nginx.ingress.kubernetes.io/auth-tls-pass-certificate-to-upstream: "true"
  name: nginx-test
  namespace: default
spec:
  rules:
  - host: {EXTERNAL_IP}.nip.io
    http:
      paths:
      - backend:
          serviceName: http-svc
          servicePort: 80
        path: /
  tls:
  - hosts:
    - {EXTERNAL_IP}.nip.io
    secretName: server-tls
```

## Test the ingress configuration

```sh
# Test the ingress configuration without a client certificate
curl -v -k https://{EXTERNAL_IP}.nip.io


# Test the ingress configuration with a client certificate
`curl -v -k https://{EXTERNAL_IP}.nip.io --cert client.crt --key client.key`

```
