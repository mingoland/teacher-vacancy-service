output "live_rds_address" {
  value = "${aws_db_instance.default.address}"
}

output "test_rds_address" {
  value = "${aws_db_instance.test.address}"
}
