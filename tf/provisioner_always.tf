resource "null_resource" "provisioner_always_01" {
  triggers { last_run_at = "${timestamp()}" }
  provisioner "local-exec" {
    command = "echo 'AZ count is ${length(data.aws_availability_zones.available.names)}' > ../az_count.log"
  }
  depends_on = ["aws_alb.validity-homework"]
}
resource "null_resource" "provisioner_always_02" {
  count = "${length(data.aws_availability_zones.available.names)}" # seems to tolerate string cast to integer
  triggers { last_run_at = "${timestamp()}" }
  provisioner "local-exec" {
    command = "echo 'AZ name ${count.index} is ${data.aws_availability_zones.available.names[count.index]}' >> ../az_count.log"
  }
  depends_on = ["null_resource.provisioner_always_01"]
}
resource "null_resource" "provisioner_always_03" {
  triggers { last_run_at = "${timestamp()}" }
  provisioner "local-exec" {
    command = "echo 'try this address: http://${local.name}.${local.domain}:80' >> ../try_this_address.log"
  }
  depends_on = ["aws_route53_record.validity-homework"]
}