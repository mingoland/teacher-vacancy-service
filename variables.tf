variable "aws_account_id" {
  description = "AWS account ID"
}

variable "repository_url" {
  description = "GitHub repository"
  default     = "https://github.com/dxw/teacher-vacancy-service.git"
}

variable "github_token" {
  description = "GitHub auth token that can read from the GitHub repository"
}

# General
variable "region" {
  default = "eu-west-2"
}

variable "project_name" {
  default = "tvs"
}

# Network
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "trusted_ips" {
  type = "list"
}

# EC2
variable "load_balancer_check_path" {
  default = "/"
}

variable "asg_name" {
  default = "tvs-default-asg"
}

variable "asg_max_size" {
  default = 4
}

variable "asg_min_size" {
  default = 2
}

variable "asg_desired_size" {
  default = 2
}

# ECS
variable "ecs_cluster_name" {
  default = "tvs-cluster"
}

variable "ecs_service_name" {
  default = "tvs-web"
}

variable "ecs_service_task_name" {
  default = "web"
}

variable "ecs_service_task_count" {
  default = "3"
}

variable "ecs_service_task_port" {
  default = 3000
}

variable "ecs_service_task_definition_file_path" {
  default = "./web_task_definition.json"
}

variable "buildspec_location" {
  default = "./buildspec.yml"
}

variable "launch_configuration_name" {
  default = "tvs-default-launch-config"
}

# Make sure this AWS AMI is valid for the chosen region.
variable "image_id" {
  default = "ami-67cbd003"
}

variable "instance_type" {
  default = "t2.small"
}

variable "ecs_key_pair_name" {
  description = "To enable SSH to the ecs managed ec2 instances"
}

# Application environment variables
variable "secret_key_base"      {}
variable "http_user"            {}
variable "http_pass"            {}
variable "google_maps_api_key"  {}
