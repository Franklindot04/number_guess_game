# Number Guess Game – Automated CI/CD Pipeline 🚀

![Build Status](https://img.shields.io/badge/Jenkins-Pipeline-blue)
![Java](https://img.shields.io/badge/Java-Servlets-orange)
![Maven](https://img.shields.io/badge/Maven-Build-red)
![SonarQube](https://img.shields.io/badge/Code%20Quality-SonarQube-brightgreen)
![Nexus](https://img.shields.io/badge/Artifacts-Nexus-yellow)
![Tomcat](https://img.shields.io/badge/Deployment-Tomcat-lightgrey)
![AWS](https://img.shields.io/badge/Cloud-AWS-ff9900)

A fully automated DevOps pipeline for a Java Servlet–based web application: **The Number Guess Game**.  
This project implements Continuous Integration and Continuous Deployment (CI/CD) using Jenkins, Maven, SonarQube, Nexus, and Apache Tomcat — deployed on AWS EC2.

> As required in the project brief: *“Your solution must enable continuous integration and continuous deployment (CI/CD) for a Java‑based web application.”*

---

## 📁 Project Structure

```
NumberGuessGame/
├── src/main/java/com/studentapp/NumberGuessServlet.java
├── src/main/webapp/index.jsp
├── src/main/webapp/WEB-INF/web.xml
├── pom.xml
└── README.md
```

---

## 🚀 CI/CD Pipeline Overview

### **Continuous Integration**
- Pulls code from GitHub on every commit  
- Builds with Maven  
- Runs unit tests  
- Performs static analysis using **SonarQube Quality Gates**  
- Packages the application into a `.war` file  
- Uploads versioned artifacts to **Nexus Repository Manager**

### **Continuous Deployment**
- Jenkins retrieves the latest approved artifact  
- Deploys automatically to **Apache Tomcat**  
- Zero manual steps — fully automated release pipeline  

---

## 🏗 Infrastructure

This project uses a clean, production‑style architecture:

- **Jenkins Server** – CI engine  
- **SonarQube Server** – Code quality & static analysis  
- **Nexus Repository** – Artifact storage & versioning  
- **Tomcat Server** – Application deployment  
- **AWS EC2 Instances** – Each service isolated for reliability  

All servers use a **single secure SSH key pair** and were rebuilt cleanly to avoid configuration drift.

---

## 🔄 Versioning & Rollback

- Every build is stored in Nexus with a unique version number  
- Any previous version can be redeployed through Jenkins  
- Ensures safe, controlled rollbacks and traceability  

---

## 🎨 UI Enhancements (Latest Release)

The latest version includes:

- Centered layout  
- Modern block‑style container  
- **Mossy‑hollow color theme**  
- Improved user feedback messages  

---

## 🛠 Tech Stack

| Component | Technology |
|----------|------------|
| Language | Java Servlets + JSP |
| Build Tool | Maven |
| CI/CD | Jenkins Pipeline (Pipeline-as-Code) |
| Code Quality | SonarQube |
| Artifact Repository | Nexus |
| Application Server | Apache Tomcat |
| Cloud | AWS EC2 |

---

## 📚 How to Run Locally

```bash
mvn clean package
```
Deploy the generated .war file to any Tomcat server.



👤 Author
Franklin  
DevOps Engineer | AWS | CI/CD | Automation
