# 📋 DeployMate – DevOps Task Management Dashboard

A full-stack dashboard to create, edit, and monitor engineering tasks across the SDLC (BUILD, TEST, DEPLOY, MONITOR). Designed for DevOps workflow visibility with real-time updates, metrics, and CI/CD integration.

## 🚀 Features

- 🧑‍💻 **React + Spring Boot + PostgreSQL** stack
- 🐳 Dockerized frontend/backend with `docker-compose`
- 📊 **Prometheus + Grafana** for live monitoring
- 🧪 **JUnit + JaCoCo** for test coverage
- 🔁 **GitHub Actions CI** with test + health check pipelines
- 📉 Slack alerts via **Alertmanager**
- 📦 Clean UI with TailwindCSS and dark mode

## 📈 Code Coverage
[![codecov](https://codecov.io/gh/Parth-Patel007/DeployMate/graph/badge.svg?token=42LU5X6CCH)](https://codecov.io/gh/Parth-Patel007/DeployMate)

## 🛠️ Local Setup

```bash
git clone https://github.com/your-username/deploymate.git
cd deploymate
docker-compose up --build
