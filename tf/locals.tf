locals {
  site = "${var.pilot_inputs["site"]}"
  cpu  = "${var.pilot_inputs["cpu"]}"
  ram  = "${var.pilot_inputs["ram"]}"
  name = "${var.pilot_inputs["name"]}"
  hzid = "${var.pilot_inputs["hzid"]}"
  domain = "${var.pilot_inputs["domain"]}"
}
locals {
  aws_region  = "${var.aws_regions[local.site]}"
  az_count    = "${length(data.aws_availability_zones.available.names)}"
  container_cpu = "${var.aws_fargate_cpu_units[local.cpu]}"
  container_ram = "${var.aws_fargate_ram_units[local.ram]}"
}
