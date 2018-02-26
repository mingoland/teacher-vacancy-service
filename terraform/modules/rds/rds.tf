resource "aws_db_instance" "default" {
  name                    = "${var.project_name}${var.environment}"
  identifier              = "${var.project_name}${var.environment}"
  allocated_storage       = "${var.rds_storage_gb}"
  storage_type            = "gp2"
  storage_encrypted       = "true"
  engine                  = "${var.rds_engine}"
  engine_version          = "${var.rds_engine_version}"
  instance_class          = "${var.rds_instance}"
  name                    = "${var.project_name}${var.environment}" # alphanumeric only
  username                = "${var.rds_username}"
  password                = "${var.rds_password}"
  vpc_security_group_ids  = ["${var.default_security_group_id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.default.name}"

  tags {
    Name        = "${var.project_name}-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_db_instance" "test" {
  name                    = "${var.project_name}${var.environment}test"
  identifier              = "${var.project_name}${var.environment}test"
  allocated_storage       = "${var.rds_storage_gb}"
  storage_type            = "gp2"
  storage_encrypted       = "true"
  engine                  = "${var.rds_engine}"
  engine_version          = "${var.rds_engine_version}"
  instance_class          = "${var.rds_instance}"
  name                    = "${var.project_name}${var.environment}" # alphanumeric only
  username                = "${var.rds_username}"
  password                = "${var.rds_password}"
  vpc_security_group_ids  = ["${var.default_security_group_id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.default.name}"

  tags {
    Name        = "${var.project_name}-${var.environment}"
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
