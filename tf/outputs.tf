output "alb_hostname" {
  value = "${aws_alb.validity-homework.dns_name}"
}
