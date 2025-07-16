# 🚀 MERN Stack CI/CD with Jenkins, Terraform & Docker on AWS

This project demonstrates a complete CI/CD pipeline to deploy a containerized MERN application using **Jenkins**, **Terraform**, and **Docker** on an **AWS EC2** instance.

---

## ⚙️ Tech Stack

- **Jenkins** – CI/CD orchestration
- **Terraform** – AWS Infrastructure provisioning
- **Docker Compose** – Containerization & deployment
- **AWS EC2** – App hosting
- **Docker Hub** – Image registry
- **GitHub** – Source control

---

## 🔄 CI/CD Flow

1. **Version Bump**  
   Updates version in `package.json` (e.g., `1.0.0-17`)

2. **Docker Build & Push**  
   Builds and pushes frontend/backend images to Docker Hub

3. **Git Commit**  
   Commits updated versions to GitHub

4. **Terraform Provisioning**  
   Creates VPC, subnet, EC2 instance, security groups, and outputs public IP

5. **Remote Deployment**  
   SSH into EC2 → run `startup-script.sh` → deploy using `docker-compose`

---

## 🧱 Infra Overview (Terraform)

- **VPC** with Subnet, IGW, Route Table
- **EC2** (Amazon Linux 2) with Docker + Compose installed via `user_data`
- **Security Group** allows ports: 22, 80, 8080, 5173 
- **Output**: EC2 public IP used in Jenkins for deployment

---


