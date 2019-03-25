
resource "aws_route53_record" "validity-homework" {
  zone_id = "${local.hzid}"
  name    = "${local.name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_alb.validity-homework.dns_name}"]
}