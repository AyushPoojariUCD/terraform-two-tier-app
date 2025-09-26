# VPC Module
# Creates VPC, public/private subnets, and internet gateway.
# All networking resources (subnets, VPC, IGW) are provisioned here.

module "vpc" {
  source        = "../modules/vpc"
  region        = var.region
  project_name  = var.project_name
  vpc_cidr      = var.vpc_cidr
  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_2b_cidr = var.pub_sub_2b_cidr
  pri_sub_3a_cidr = var.pri_sub_3a_cidr
  pri_sub_4b_cidr = var.pri_sub_4b_cidr
  pri_sub_5a_cidr = var.pri_sub_5a_cidr
  pri_sub_6b_cidr = var.pri_sub_6b_cidr
}

# NAT Gateway Module
# Provides internet access to private subnets via NAT gateways.

module "nat" {
  source = "../modules/nat"

  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  igw_id        = module.vpc.igw_id
  vpc_id        = module.vpc.vpc_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
}

# Security Groups
# Creates security groups for ALB, EC2 (client), and RDS.

module "security-group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

# Key Pair
# Creates an SSH key pair for EC2 instance login.

module "key" {
  source = "../modules/key"
}

# Application Load Balancer (ALB)
# Creates ALB, Target Group, Listeners, and attaches to public subnets.

module "alb" {
  source        = "../modules/alb"
  project_name  = module.vpc.project_name
  alb_sg_id     = module.security-group.alb_sg_id
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id        = module.vpc.vpc_id
}

# Auto Scaling Group (ASG)
# Deploys application EC2 instances in private subnets behind the ALB.

module "asg" {
  source        = "../modules/asg"
  project_name  = module.vpc.project_name
  key_name      = module.key.key_name
  client_sg_id  = module.security-group.client_sg_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  tg_arn        = module.alb.tg_arn
}

# RDS (Database Layer)
# Creates an RDS instance in private subnets for backend database storage.

module "rds" {
  source        = "../modules/rds"
  db_sg_id      = module.security-group.db_sg_id
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
  db_username   = var.db_username
  db_password   = var.db_password
}

# CloudFront Distribution (CDN + HTTPS)
# Creates CloudFront distribution for ALB with SSL certificate.

module "cloudfront" {
  source                   = "../modules/cloudfront"
  certificate_domain_name  = var.certificate_domain_name
  additional_domain_name   = var.additional_domain_name
  alb_domain_name          = module.alb.alb_dns_name
  project_name             = module.vpc.project_name
}

# Route 53 DNS
# Creates DNS records to map domain name to CloudFront distribution.

module "route53" {
  source                    = "../modules/route53"
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
}
