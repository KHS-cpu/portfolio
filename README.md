# Cloud Resume Project Overview
This project kaunghtetsan.tech demonstrates a fully serverless, automated, and scalable cloud portfolio website hosted on AWS using Terraform (IaC) for infrastructure management and a CI/CD pipelinewhat for continuous deployment. It showcases skills in cloud architecture, automation, monitoring, and backend development—all without manual intervention after the initial deployment.

## Project Diagram
![Image](https://github.com/user-attachments/assets/b84ed5be-e6c2-4636-988a-ac1e586518a6)

---

## 🌐 Features
Static Website Hosting: Resume portfolio hosted in an S3 bucket and served securely via CloudFront with Origin Access Control (OAC).
Custom Domain: Managed through Route 53 using a domain kaunghtetsan.tech.
Visitor Tracking: A live visitor counter implemented with API Gateway, AWS Lambda, and DynamoDB.
Infrastructure as Code (IaC): Entire infrastructure is built and maintained using Terraform modules.
CI/CD Pipeline: Frontend updates are automatically deployed using GitHub Actions on every push.
Monitoring and Alerts: Lambda errors and billing alerts are tracked using CloudWatch.

---

## 🔧 Tech Stack

- **Terraform** (modularized IaC)
- **AWS S3** (static site hosting)
- **AWS CloudFront** (global content delivery)
- **AWS Route 53** (domain and DNS)
- **AWS Lambda** (backend logic)
- **API Gateway** (exposes Lambda via REST endpoint)
- **DynamoDB** (stores visitor count)
- **CloudWatch** (monitoring and alarms)
- **GitHub Actions** (CI/CD pipeline)

---

# 📁 Project Structure
<pre><code>```portfolio/
├── terraform/
│   ├── main.tf                     #Entry point for terraform to implement all modules.
│   ├── backend.tf                  #Terraform to use Terraform cloud for state management.
│   ├── providers.tf                #AWS provider for Terraform
│   ├── modules/                    #Modules responsible for provisioning resources related to website's front-end.
│   │   ├── front-end/              #Front-End modules
│   │   │   ├── cloudfront.tf       #Creates a CloudFront distribution to deliver your static website content securely and with low latency. 
│   │   │   ├── dns.tf              #Sets up DNS records using Route 53 to point domain to the CloudFront distribution.
│   │   │   ├── output.tf           #Outputs values like the s3 bucket name and route 53 names to be used on another modules.
│   │   │   ├── s3.tf               #Create an s3 bucket for the static website files.
│   │   │   └── variables.tf        #Delcared variables used in this modules.
│   │   ├── back-end/               #This module sets up serverless backend resources to handle website functionality like a visitor counter.
│   │   │   ├── api.tf              #Creates an API Gateway that exposes the Lambda function as a REST API endpoint.
│   │   │   ├── data.tf             #Defines to pull the AWS account ID to use in the modules.
│   │   │   ├── dynamo-db.tf        #Creates a DynamoDB table to store and manage visitor count data.
│   │   │   ├── lambda.tf           #Deploys a Lambda function to update the visitor counter when someone accesses the API endpoint from API Gateway.
│   │   │   ├── output.tf           #Expose the lambda function name to be used in another modules.
│   │   │   └── variables.tf        #Delcared variables used in this modules.
│   │   └── monitoring-alarm/       #This module is for setting up monitoring and alarms for your infrastructure.
│   │       ├── main.tf             #Contains the resources for CloudWatch monitoring and alarms like Lambda function alert and Billing alert.
│   │       └── variables.tf        #Delcared variables used in this modules.
│   └── website/                    #This folder stores the final static website files that have been built (e.g., HTML, CSS, JavaScript). These files are uploaded to the S3 bucket provisioned in the front-end module.
├── .github/                        #This is the GitHub-specific folder for automating workflows using GitHub Actions.
│   └── workflows/                  #Contains YAML files for CI/CD automation.
│       └── front-end-cicd.yml      #A GitHub Actions workflow file that automatically deploys or syncs front-end static site to S3 (and optionally invalidates CloudFront) when changes are pushed to the repository.```</code></pre>

---

# ⚙️ Key Components
## 1. Static Hosting
- S3 stores website files.
- CloudFront distributes them with SSL (OAC enabled).
- Route 53 maps the domain.

- ## 2. Backend Visitor Count
- API Gateway exposes a REST endpoint.
- Lambda (Python) increases and fetches visitor data.
- DynamoDB stores the visitor count keyed by an identifier.

## 3. CI/CD Pipeline
- GitHub Actions auto-deploys frontend updates to S3 upon code push.
- Enables full automation with zero manual work.

## 4. Monitoring
- CloudWatch Alarms track:
 - Lambda errors
 - Monthly billing thresholds



