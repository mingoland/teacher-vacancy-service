module "es" {
  source                         = "github.com/terraform-community-modules/tf_aws_elasticsearch?ref=0.0.1"
  domain_name                    = "es.local"
  vpc_options                    = {
    security_group_ids = ["${module.core.default_security_group_id}"]
    subnet_ids         = ["${var.private_subnet_ids}"]
  }
  instance_count                 = 1
  instance_type                  = "${var.es_instance}"
  dedicated_master_type          = "${var.es_instance}"
  es_zone_awareness              = false
  ebs_volume_size                = 35
}
