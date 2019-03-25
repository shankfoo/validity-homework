
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${local.aws_region}" # "${var.aws_regions["${var.pilot_input_site}"]}"
}
