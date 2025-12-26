# 🛒 E-commerce Application – CI/CD with Docker, Jenkins & AWS EC2

## 📌 Project Overview

This project implements a **complete DevOps workflow** for deploying a React-based frontend application using **Docker, Jenkins, AWS EC2, and open-source monitoring tools**.

The solution demonstrates:

- Branch-based CI/CD logic (`dev` → `master`)
- Docker image build & push to Docker Hub
- Automated deployment on AWS EC2
- Secure AWS networking via Security Groups
- Independent monitoring with alerting when the application goes down

The goal is to keep the system simple, realistic, and production-oriented.

---

## 🎯 Objectives Fulfilled

| Requirement        | Implementation                                          |
| ------------------ | ------------------------------------------------------- |
| Run app on port 80 | Nginx container exposed on EC2 port 80                  |
| Dockerize app      | Custom Dockerfile using Nginx                           |
| Docker Compose     | Used for app, exporters, and monitoring stack           |
| Bash scripts       | `build.sh`, `deploy.sh`, orchestration via `compose.sh` |
| Git branching      | `dev` (development) and `master` (production)           |
| Docker Hub repos   | Public `dev`, Private `prod`                            |
| Jenkins CI/CD      | Branch-aware pipeline (build → push → deploy)           |
| Security Groups    | HTTP open, SSH IP-restricted                            |
| Monitoring         | Prometheus + Grafana + Alertmanager                     |
| Alerts             | Slack notification when app goes down                   |

---

## 🌿 Branch Behavior & CI Logic

### `dev` branch

- Triggered automatically on push (GitHub webhook).
- Builds Docker image and pushes to the **public Docker Hub dev repository**.
- Deploys **dev containers** on the EC2 host.

### `master` branch

- Triggered when `dev` is merged to `master`.
- Builds Docker image and pushes to the **private Docker Hub prod repository**.
- Deploys **production containers** (user-facing application).

---

## 🧱 Architecture Overview

High-level flow:

Developer → GitHub (webhook via cloudflared) → Jenkins Pipeline → Build & Push → Deploy on AWS EC2

EC2 runs:

- Nginx app containers
- Exporters (cAdvisor, Nginx exporter)
- Monitoring stack (Prometheus, Grafana, Alertmanager)

---

## 📁 Repository Structure

Put the repository tree inside a fenced code block so spacing is preserved:

```text
.
├── application/
│   └── deploy-app/          # React build output
│
├── operation/
│   ├── Docker/              # Dockerfile, docker-compose.yml
│   ├── scripts/             # build, deploy, orchestration scripts
│   └── monitoring/          # Prometheus, Grafana, Alertmanager configs
│
├── Jenkinsfile              # CI/CD pipeline
├── .gitignore
└── README.md
```

---

## 🐳 Docker & Deployment Design

- Nginx serves the static React build.
- Docker ensures consistent runtime across environments.
- Docker Compose:
  - Manages dev & prod containers.
  - Runs exporters and monitoring services.
- Bash scripts (build.sh, deploy.sh, compose.sh) abstract Docker commands for clarity and reuse.

This keeps CI scripts clean while allowing local and remote deployments using the same logic.

---

## 🔁 Jenkins CI/CD Pipeline

Add the Jenkinsfile or pipeline snippet inside a fenced code block (use `groovy` for highlighting):

```groovy
pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build') {
      steps { sh './operation/scripts/build.sh' }
    }
    stage('Push') {
      steps { sh './operation/scripts/push.sh' }
    }
    stage('Deploy') {
      steps { sh './operation/scripts/deploy.sh' }
    }
  }
  post {
    always { archiveArtifacts artifacts: 'operation/logs/**', allowEmptyArchive: true }
    failure { mail to: 'devops@example.com', subject: "Pipeline failed", body: "Check Jenkins" }
  }
}
```

Notes:

- Use branch-aware logic in your Jenkinsfile to switch between dev/prod behavior.
- Keep credentials in Jenkins credentials store (do not hardcode secrets).

---

## ☁️ AWS Deployment & Security

- Instance: t3.small EC2
- App served on port 80 via Nginx container
- Security groups:
  - HTTP (80) → 0.0.0.0/0 (public access)
  - SSH (22) → restricted to developer IP (CIDR /32)

Provisioning is handled by `install_tools.sh` (installs Jenkins, Docker, docker-compose, etc.).

---

## 📊 Monitoring & Alerting

Open-source monitoring stack:

- cAdvisor — container-level CPU, memory, and uptime metrics
- Nginx Prometheus Exporter — HTTP and traffic metrics
- Prometheus — scrapes metrics and evaluates alert rules
- Alertmanager — routes alerts to Slack using a webhook (webhook stored outside the repo and mounted at runtime)
- Grafana — dashboards for container health and traffic metrics

Alerting approach:

- Prometheus rules detect when a container stops reporting metrics.
- Alertmanager sends Slack notifications via a secured webhook.

---

## ✅ Submission URLs

- Docker Hub (Dev, Public): [kausheekraj/ecommerce-nginx-dev](https://hub.docker.com/r/kausheekraj/ecommerce-nginx-dev)
- Docker Hub (Prod, Private): [kausheekraj/ecommerce-nginx](https://hub.docker.com/r/kausheekraj/ecommerce-nginx)

Deployed application:

- Prod: [http://3.135.0.171/](http://3.135.0.171/)
- Dev: [http://3.135.0.171:9090/](http://3.135.0.171:9090/)

---

## Project outcomes

This project delivers a **complete, assignment-compliant DevOps solution**:

- Automated CI/CD with branch-based behavior
- Secure Docker image management
- Real AWS deployment with proper networking
- Independent monitoring with alerting
- Clean separation of application, automation, and observability

## 🏁 Final Notes

This README has:

- Properly fenced code blocks for the repository tree and Jenkins pipeline.
- Removed stray/accidental text that could break Markdown rendering.
- Formatted external links using Markdown link syntax.

