/*====
Live (non-test) RDS
======*/
resource "aws_db_instance" "default" {
  name                    = "${var.project_name}0${var.environment}"
  identifier              = "${var.project_name}0${var.environment}"
  allocated_storage       = "${var.rds_storage_gb}"
  storage_type            = "gp2"
  storage_encrypted       = "true"
  engine                  = "${var.rds_engine}"
  engine_version          = "${var.rds_engine_version}"
  instance_class          = "${var.rds_instance}"
  name                    = "${var.project_name}0${var.environment}" # alphanumeric only
  username                = "${var.rds_username}"
  password                = "${var.rds_password}"
  vpc_security_group_ids  = ["${var.default_security_group_id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.default.name}"

  tags {
    Name        = "${var.project_name}-${var.environment}-live"
    Environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "${var.project_name}-${var.environment}"
  subnet_ids  = ["${data.aws_subnet_ids.private.ids}"]
}

data "aws_subnet_ids" "private" {
  vpc_id = "${var.vpc_id}"
  tags {
    Tier = "Private"
  }
}

/*====
Test RDS
======*/
resource "aws_db_instance" "test" {
  name                    = "${var.project_name}0${var.environment}0test"
  identifier              = "${var.project_name}0${var.environment}0test"
  allocated_storage       = "${var.rds_storage_gb}"
  storage_type            = "gp2"
  storage_encrypted       = "false"
  engine                  = "${var.rds_engine}"
  engine_version          = "${var.rds_engine_version}"
  instance_class          = "${var.rds_instance}"
  name                    = "${var.project_name}0${var.environment}0test" # alphanumeric only
  username                = "${var.rds_username}"
  password                = "${var.rds_password}"
  vpc_security_group_ids  = ["${var.test_security_group_id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.default.name}"

  tags {
    Name        = "${var.project_name}-${var.environment}-test"
    Environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "test" {
  name        = "${var.project_name}-${var.environment}"
  subnet_ids  = ["${data.aws_subnet_ids.test.ids}"]
}

data "aws_subnet_ids" "test" {
  vpc_id = "${var.test_vpc_id}"
  tags {
    Tier = "Private"
  }
}
