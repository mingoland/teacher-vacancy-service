output "test_vpc_id" {
  value = "${aws_vpc.test.id}"
}

output "test_security_group_id" {
  value = "${aws_security_group.test.id}"
}
