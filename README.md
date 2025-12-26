# 🛒 E-commerce Application – CI/CD with Docker, Jenkins & AWS EC2

## 📌 Project Overview

This project implements a **complete DevOps workflow** for deploying a React-based frontend application using **Docker, Jenkins, AWS EC2, and open-source monitoring tools**.

The solution fulfills all assignment objectives by demonstrating:

- Branch-based CI/CD logic (`dev` → `master`)
- Docker image build & push to separate Docker Hub repositories
- Automated deployment on AWS EC2
- Secure AWS networking via Security Groups
- Independent monitoring with alerting when the application goes down

The goal was to keep the system **simple, realistic, and production-oriented**, without unnecessary complexity.

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

- Triggered automatically on push (GitHub webhook)
- Builds Docker image
- Pushes image to **public Docker Hub dev repository**
- Deploys **dev containers** on the EC2 host

### `master` branch

- Triggered when `dev` is merged to `master`
- Builds Docker image
- Pushes image to **private Docker Hub prod repository**
- Deploys **production containers** (user-facing application)

This directly implements:

- **Push to dev → build & push dev image**
- **Merge to master → build & push prod image → deploy**

---

## 🧱 Architecture Overview

### High-level Flow

Developer
|
| git push
v
GitHub Repository
|
| (Webhook via Cloudflared)
v
Jenkins Pipeline
|
|-- Build Docker Image
|-- Push to Docker Hub (dev / prod)
|-- Deploy via Docker Compose
v
AWS EC2 (t3.small)
|
|-- Nginx App Containers
|-- cAdvisor & Nginx Exporters
|-- Monitoring Stack


---

## 📁 Repository Structure
.
├── application/
│ └── deploy-app/ # React build output
│
├── operation/
│ ├── Docker/ # Dockerfile, docker-compose.yml
│ ├── scripts/ # build, deploy, orchestration scripts
│ └── monitoring/ # Prometheus, Grafana, Alertmanager configs
│
├── Jenkinsfile # CI/CD pipeline
├── .gitignore
└── README.md

## 🐳 Docker & Deployment Design

- **Nginx** is used to serve the static React build
- Docker ensures consistent runtime across environments
- Docker Compose:
  - Manages **dev & prod containers**
  - Runs **exporters and monitoring services**
- Bash scripts abstract Docker commands for clarity and reuse

This keeps CI scripts clean while allowing local and remote deployments using the same logic.

---

## 🔁 Jenkins CI/CD Pipeline

### Pipeline Logic (from Jenkinsfile)

Checkout
↓
Build Docker Image
↓
Push Image to Docker Hub
↓
Deploy Containers on EC2

markdown
Copy code

### Key Characteristics

- **Branch-aware logic** (`dev` vs `master`)
- Uses **only CLI tools**
- Docker authentication handled via Jenkins credentials
- No hardcoded secrets in the pipeline
- Same scripts used locally and in CI

This mirrors real-world Jenkins pipelines used in small to mid-scale production systems.

---

## ☁️ AWS Deployment & Security

- Application runs on a **t3.small EC2 instance**
- Docker containers serve the app on **port 80**
- Provisioned by install_tools.sh to setup and Install essential tools: Jenkins , Docker and Docker-compose

### Security Group Configuration

- **HTTP (80)** → Open to `0.0.0.0/0`  
  Allows public access to the deployed application

- **SSH (22)** → Restricted to developer’s public IP (`/32`)  
  Ensures secure administrative access

This setup satisfies both **accessibility** and **security** requirements.

---

## 📊 Monitoring & Alerting Design

### Monitoring Stack (Open-Source)

- **cAdvisor**  
  Collects container-level CPU, memory, and uptime metrics

- **Nginx Prometheus Exporter**  
  Exposes HTTP and traffic metrics for dev and prod containers

- **Prometheus**  
  Scrapes metrics and evaluates alert rules

- **Alertmanager**  
  Sends Slack notifications when the app goes down
  ### Alerting with Alertmanager (Slack)

Alertmanager is configured alongside Prometheus to send notifications when the application goes down.

- Alerts are triggered using Prometheus rules (e.g., container not reporting metrics).
- Alertmanager routes notifications to a Slack channel using a webhook.
- The Slack webhook URL is stored securely outside Git and mounted at runtime.

This ensures immediate notification when the application becomes unavailable, demonstrating real-world operational alerting.

- **Grafana**  
  Visualizes container health and traffic metrics
  Uses 193 template , output shown in Screenshots submitted

---

### Why Monitoring Is Outside the CI Pipeline

The monitoring stack is **deployed and managed independently** from Jenkins.

**Benefits:**

- **Separation of concerns**  
  Monitoring should remain active even if deployments fail

- **Operational stability**  
  Alerts and dashboards stay available during CI failures

- **Simpler iteration**  
  Alert rules and dashboards can be tuned without triggering builds

- **Safer secret handling**  
  Slack webhooks and credentials are managed via volumes/files, not pipeline scripts

This design reflects how monitoring is typically handled in real production environments.

---

## ✅ Submission URLs

### Docker Hub

- **Dev Repository (Public):**  
  `https://hub.docker.com/r/kausheekraj/ecommerce-nginx-dev`

- **Prod Repository (Private):**  
  `https://hub.docker.com/r/kausheekraj/ecommerce-nginx`

### Deployed Application

- **Application URL:**
  # prod
  `http://3.135.0.171/`
  # dev
  `http://3.135.0.171:9090/`

---

## 🏁 Final Outcome

This project delivers a **complete, assignment-compliant DevOps solution**:

- Automated CI/CD with branch-based behavior
- Secure Docker image management
- Real AWS deployment with proper networking
- Independent monitoring with alerting
- Clean separation of application, automation, and observability

The implementation prioritizes **clarity, correctness, and real-world practices** ov
