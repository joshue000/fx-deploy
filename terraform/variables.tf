variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_pair_name" {
  description = "Name of the existing AWS key pair used for SSH access"
  type        = string
  default     = "banco-deploy-"
}

variable "app_name" {
  description = "Application name — used as a prefix for all resource names and tags"
  type        = string
  default     = "fxreplaychallenge"
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access the application ports (default: open to all)"
  type        = string
  default     = "0.0.0.0/0"
}
