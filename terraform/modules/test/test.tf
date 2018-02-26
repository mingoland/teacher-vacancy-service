/*====
The Test VPC
======*/
resource "aws_vpc" "test" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = false
  enable_dns_support   = false

  tags {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = "${var.environment}"
  }
}

/*====
Subnets
======*/
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.test.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
    Tier        = "Private"
  }
}

/*====
Test VPC's Default Security Group
======*/
resource "aws_security_group" "test" {
  name        = "${var.environment}-sg"
  description = "Test security group to allow CodeBuild to run with the required resources"
  vpc_id      = "${aws_vpc.test.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags {
    Name        = "${var.project_name}-${var.environment}"
    Environment = "${var.environment}"
  }

  depends_on  = ["aws_vpc.test"]
}
