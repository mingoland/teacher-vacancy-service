provider "aws" {
  region = "${var.region}"
}

/* Store tfstate files remotely in S3 instead of the repository.
This means:
  - no plain text credentials are committed into the repository
  - tfstate is versioned by the s3 bucket
  - teams can sync the latest state and s3 supports further with file locking
 */
data "terraform_remote_state" "production" {
  backend = "s3"
  config {
    # Create this bucket in AWS first with permissions: https://www.terraform.io/docs/backends/types/s3.html
    bucket    = "${var.project_name}-1"
    key       = "production/terraform.tfstate"
    region    = "eu-west-2"
    encrypt   = "true"
  }
}

data "terraform_remote_state" "staging" {
  backend = "s3"
  config {
    # Create this bucket in AWS first with permissions: https://www.terraform.io/docs/backends/types/s3.html
    bucket    = "${var.project_name}-1"
    key       = "staging/terraform.tfstate"
    region    = "eu-west-2"
    encrypt   = "true"
  }
}

module "core" {
  source                     = "./terraform/modules/core"

  environment                = "${terraform.workspace}"
  project_name               = "${var.project_name}"
  vpc_cidr                   = "${var.vpc_cidr}"
  availability_zones         = "${var.availability_zones}"
  public_subnets_cidr        = "${var.public_subnets_cidr}"
  private_subnets_cidr       = "${var.private_subnets_cidr}"
  availability_zones         = "${var.availability_zones}"
  trusted_ips                = "${var.trusted_ips}"

  region                     = "${var.region}"
  load_balancer_check_path   = "${var.load_balancer_check_path}"
  image_id                   = "${var.image_id}"
  instance_type              = "${var.instance_type}"
  ecs_key_pair_name          = "${var.ecs_key_pair_name}"
  launch_configuration_name  = "${var.launch_configuration_name}"

  asg_name                   = "${var.asg_name}"
  asg_max_size               = "${var.asg_max_size}"
  asg_min_size               = "${var.asg_min_size}"
  asg_desired_size           = "${var.asg_desired_size}"

  ecs_cluster_name           = "${module.ecs.cluster_name}"
  ecs_service_name           = "${module.ecs.service_name}"
  aws_iam_instance_profile_name = "${module.ecs.aws_iam_instance_profile_name}"
}

module "ecs" {
  source                                = "./terraform/modules/ecs"

  environment                           = "${terraform.workspace}"
  project_name                          = "${var.project_name}"
  region                                = "${var.region}"
  ecs_cluster_name                      = "${var.ecs_cluster_name}"
  ecs_service_name                      = "${var.ecs_service_name}"
  ecs_service_task_name                 = "${var.ecs_service_task_name}"
  ecs_service_task_count                = "${var.ecs_service_task_count}"
  ecs_service_task_port                 = "${var.ecs_service_task_port}"
  launch_configuration_name             = "${var.launch_configuration_name}"
  ecs_service_task_definition_file_path = "${var.ecs_service_task_definition_file_path}"

  aws_alb_target_group_arn              = "${module.core.alb_target_group_arn}"
  aws_cloudwatch_log_group_name         = "${module.logs.aws_cloudwatch_log_group_name}"

  # Application variables
  http_pass                             = "${var.http_pass}"
  http_user                             = "${var.http_user}"
  google_maps_api_key                   = "${var.google_maps_api_key}"
  secret_key_base                       = "${var.secret_key_base}"
}

module "logs" {
  source                    = "./terraform/modules/logs"

  environment               = "${terraform.workspace}"
  project_name              = "${var.project_name}"
}

module "pipeline" {
  source                    = "./terraform/modules/pipeline"

  environment               = "${terraform.workspace}"
  project_name              = "${var.project_name}"
  aws_account_id            = "${var.aws_account_id}"
  github_token              = "${var.github_token}"
  buildspec_location        = "${var.buildspec_location}"

  registry_name             = "${module.ecs.registry_name}"
  ecs_cluster_name          = "${module.ecs.cluster_name}"
  ecs_service_name          = "${module.ecs.service_name}"
}
