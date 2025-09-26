# General Settings

variable "region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1" # Change if needed
}

variable "project_name" {
  description = "A unique name for the project. Used for tagging resources."
  type        = string
}

# Networking (VPC & Subnets)
variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "pub_sub_1a_cidr" {
  description = "CIDR block for the public subnet in availability zone 1a."
  type        = string
}

variable "pub_sub_2b_cidr" {
  description = "CIDR block for the public subnet in availability zone 2b."
  type        = string
}

variable "pri_sub_3a_cidr" {
  description = "CIDR block for the private subnet in availability zone 3a."
  type        = string
}

variable "pri_sub_4b_cidr" {
  description = "CIDR block for the private subnet in availability zone 4b."
  type        = string
}

variable "pri_sub_5a_cidr" {
  description = "CIDR block for the private subnet in availability zone 5a."
  type        = string
}

variable "pri_sub_6b_cidr" {
  description = "CIDR block for the private subnet in availability zone 6b."
  type        = string
}

# Database Credentials
variable "db_username" {
  description = "Master username for the database instance."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the database instance."
  type        = string
  sensitive   = true
}

# SSL Certificate (for HTTPS / ACM)
variable "certificate_domain_name" {
  description = "Primary domain name for the SSL certificate (ACM)."
  type        = string
}

variable "additional_domain_name" {
  description = "Optional additional domain name for the SSL certificate (e.g., www alias)."
  type        = string
  default     = "" # Keep empty if not needed
}
