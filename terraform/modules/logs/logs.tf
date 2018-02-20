/*====
Cloudwatch Log Group
======*/
resource "aws_cloudwatch_log_group" "tvs" {
  name                = "${var.project_name}-${var.environment}"
  retention_in_days   = 90

  tags {
    Environment = "${var.environment}"
    Application = "${var.project_name}"
  }
}
