# 📋 DeployMate – DevOps Task Management Dashboard  
*A single repo that goes all the way from* **code → tests → load-test → AWS**.

[![Backend CI](https://github.com/Parth-Patel007/DeployMate/actions/workflows/backend-ci.yml/badge.svg)](https://github.com/Parth-Patel007/DeployMate/actions/workflows/backend-ci.yml)  
[![Cypress E2E](https://github.com/Parth-Patel007/DeployMate/actions/workflows/cypress-e2e.yml/badge.svg)](https://github.com/Parth-Patel007/DeployMate/actions/workflows/cypress-e2e.yml)  
[![k6 Load Test](https://github.com/Parth-Patel007/DeployMate/actions/workflows/load-test.yml/badge.svg)](https://github.com/Parth-Patel007/DeployMate/actions/workflows/load-test.yml)  
[![Coverage](https://codecov.io/gh/Parth-Patel007/DeployMate/branch/main/graph/badge.svg)](https://codecov.io/gh/Parth-Patel007/DeployMate)


A full-stack dashboard for creating, tracking, and monitoring engineering tasks across the SDLC  
(**BUILD → TEST → DEPLOY → MONITOR**). Real-time metrics, CI gates, and AWS IaC included.


## 🚀 Features

- 🖥 **Stack:** React + Vite + TailwindCSS · Spring Boot 3 · PostgreSQL 15  
- 🐳 **Docker Compose:** spins up frontend · backend · db · Prometheus · Grafana  
- 🧪 **Quality Gates:**  
  - Unit tests + JaCoCo coverage (GitHub Actions)  
  - Cypress E2E (`npm run test:e2e`)  
  - k6 load tests (10 VUs × 30s; fail if p95 > 500ms or errors ≥ 1%)  
- 📊 **Observability:** Micrometer → Prometheus → Grafana (pre-provisioned dashboards)  
- 🛠 **IaC:** Terraform → VPC, RDS, ALB, ECS Fargate, ECR, Security Groups & Alertmanager rules  
- 🖼 **Badges:** Build · Coverage · E2E · Performance  

## ⚡ Quick Start (Local)

~~~bash
git clone https://github.com/Parth-Patel007/DeployMate.git
cd DeployMate
docker compose up --build
~~~

- **Frontend**: http://localhost:5173  
- **Backend health**: http://localhost:8080/healthz  
- **Prometheus UI**: http://localhost:9090  
- **Grafana UI**: http://localhost:3001  (login `admin` / `admin`)



---

## 🛠 Local Development

### Backend with hot-reload

~~~bash
# 1️⃣ Start only Postgres
docker compose up -d db

# 2️⃣ Run Spring Boot with DevTools
export SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/deploymate
export SPRING_DATASOURCE_USERNAME=parth
export SPRING_DATASOURCE_PASSWORD=parth123
./gradlew bootRun
~~~


---

###  Running Tests
~~~bash
## 🧪 Running Tests

| Test Type        | Command                               |
|------------------|---------------------------------------|
| Unit + Coverage  | `./gradlew test jacocoTestReport`     |
| Cypress E2E      | `cd frontend && npm run test:e2e`     |
| k6 Load Test     | `k6 run monitoring/k6/loadtest.js`    |

_All these run automatically on every PR via GitHub Actions._

~~~

---


## ☁️ Cloud Deployment (AWS Fargate)

- Backend container → ECR  
- Terraform scripts in `/infra` provision:  
  - VPC, RDS (Postgres)  
  - ECS Fargate Cluster + Task Definitions  
  - Application Load Balancer  
  - IAM Roles & Security Groups  
- GitHub Actions: build → push → terraform apply → smoke-test `/healthz` → k6 loadtest



## 📊 Monitoring & Alerts

- **Metrics**: Spring Boot Actuator → `/actuator/prometheus`  
- **Scraping**: Prometheus (`monitoring/prometheus/prometheus.yml`)  
- **Dashboards**: Grafana provisioning (`monitoring/grafana/`)  
- **Alerts**: Alertmanager rules (`monitoring/prometheus/alert.rules.yml`) → Slack
