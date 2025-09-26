# terraform-two-tier-app
Infrastructure as Code (IaC) for deploying a highly available two-tier application using Terraform. The setup provisions a VPC, networking, security groups, and compute resources for the web (frontend) tier and database (backend) tier, demonstrating modular and reusable Terraform configurations.


This project provisions a modular cloud infrastructure that includes:

- **VPC & Networking** (public/private subnets, route tables, NAT gateways, Internet Gateway)  
- **Security Groups** (web, app, database tiers)  
- **Application Load Balancer (ALB)** for the frontend  
- **Auto Scaling Group (ASG)** for web/app instances  
- **RDS Database** (backend tier in private subnets)  
- **CloudFront CDN** with SSL (ACM)  
- **Route 53 DNS** integration  
- **Remote backend (S3 + DynamoDB)** for Terraform state  

---

## 📌 Architecture

```text
                  +----------------------------+
                  |        Route 53 (DNS)      |
                  +-------------+--------------+
                                |
                  +-------------v--------------+
                  |    CloudFront Distribution |
                  +-------------+--------------+
                                |
                  +-------------v--------------+
                  |   Application Load Balancer|
                  +-------------+--------------+
                                |
         +----------------------+----------------------+
         |                                             |
+--------v---------+                          +--------v---------+
| Private Subnet   |                          | Private Subnet   |
| EC2 (ASG)        |                          | EC2 (ASG)        |
+------------------+                          +------------------+
                                |
                         +------v------+
                         |   RDS DB    |
                         | (Private)   |
                         +-------------+
```

## 📂 Project Structure
```
terraform-two-tier-app/
│── main.tf                # Root module wiring child modules
│── variables.tf           # Input variables
│── outputs.tf             # Useful outputs (ALB DNS, RDS endpoint, etc.)
│── terraform.tfvars       # Example variable values
│── backend.tf             # Remote backend config (S3 + DynamoDB)
│
├── modules/
│   ├── vpc/               # VPC, Subnets, IGW, Route tables
│   ├── nat/               # NAT Gateways
│   ├── security-group/    # Security groups
│   ├── key/               # Key Pair
│   ├── alb/               # Application Load Balancer
│   ├── asg/               # Auto Scaling Group
│   ├── rds/               # RDS Database
│   ├── cloudfront/        # CloudFront distribution
│   └── route53/           # Route 53 records
```