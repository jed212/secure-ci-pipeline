# Secure-CI-pipeline
This project demonstrates a secure CI pipeline implementation for a Go-based microservice, incorporating DevSecOps best practices such as automated testing, code quality enforcement, vulnerability scanning, and Software Supply Chain visibility through SBOM generation.

## Project Overview

This repository contains a simple Go web service and a fully automated CI pipeline designed to enforce security and quality at every stage of the software delivery lifecycle.

The pipeline implements a shift-left security approach, ensuring vulnerabilities and misconfigurations are detected early in the development lifecycle.

## Architecture
```
Developer Push
      ↓
GitHub Actions CI
      ↓
Code Build (Go)
      ↓
Unit Tests
      ↓
Code Quality Checks (golangci-lint, go vet, formatting)
      ↓
Secret Scanning (Gitleaks)
      ↓
Vulnerability Scanning (Trivy - filesystem)
      ↓
Docker Image Build
      ↓
Container Vulnerability Scan (Trivy)
      ↓
SBOM Generation (CycloneDX via Trivy)
      ↓
Artifact Publishing (SBOM)
```
## Tech Stack
* Go (Backend service)
* Docker (Containerization)
* GitHub Actions 
* Trivy (Security scanning + SBOM)
* golangci-lint (Code quality)
* Gitleaks (Secret detection)
* Cosign with sigstore(Image signing)

## Security Features Implemented
✔ Code Quality Enforcement
* golangci-lint (Pinned to SHA)
* go vet
* formatting checks

✔ Secret Detection
* Gitleaks used to prevent credential leakage in commits

✔ Vulnerability Scanning & Reporting
* Trivy filesystem scan with SARIF report upload to GitHub Security tab
* Trivy container image scan
* Blocking pipeline on HIGH and CRITICAL severity vulnerabilities

✔ Software Supply Chain Security
* SBOM (Software Bill of Materials) generation using Trivy (CycloneDX format)
* SBOM published as CI artifact
* **Container Image Signing** using Cosign (Keyless signing with Sigstore/OIDC)
* Action version pinning via commit SHAs

✔ Hardened Containerization
* Multi-stage builds
* Distroless base image (minimizes attack surface)
* Specific image digests for reproducibility

## CI Pipeline Features
* Automated build and test on every push
* Security-first pipeline design
* Fail-fast security gates
* Artifact generation (SBOM)
* Reproducible container builds

## SBOM (Software Bill of Materials)

The pipeline generates an SBOM in CycloneDX format, providing full visibility into:
* application dependencies
* transitive libraries
* system packages inside container image
  
This enables:
* vulnerability tracking
* compliance readiness
* supply chain transparency



## Project Structure
```
secure-gitops-platform/
├── app/
│   ├── cmd/
│   ├── internal/
│   ├── go.mod
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── Dockerfile
├── sbom.json (generated in CI)
└── README.md
```
## Running Locally
To run application
```
cd app
go run ./cmd/server
```
Run tests
```
go test ./...
```

Build Docker Image
```
docker build -t secure-go-api:1.0 .
docker run -p 8080:8080 secure-go-api:1.0
```

## Key DevSecOps Principles Demonstrated
* Shift-left security (security embedded in CI)
* Automated policy enforcement
* Secure software supply chain awareness
* Immutable artifact generation
* Continuous vulnerability detection

# Roadmap

This project currently focuses on implementing a secure CI and software supply chain workflow around a lightweight Go service.

A natural progression from this setup would be extending these security practices into deployment and runtime environments through GitOps and Kubernetes-native policy enforcement.

## Possible Next Steps
GitOps & Secure CD

* Explore FluxCD-based GitOps deployments
* Separate CI and CD concerns using a dedicated GitOps repository
* Automate Kubernetes deployment synchronization from Git

Kubernetes Policy Enforcement

* Explore policy enforcement using Kyverno or Open Policy Agent
* Experiment with trusted image verification and admission control policies

Runtime Security Exploration

* Explore Kubernetes runtime and workload security concepts
* Extend supply chain security controls beyond CI into deployment environments
