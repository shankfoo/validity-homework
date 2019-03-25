resource "aws_vpc" "validity-homework" {
  cidr_block  = "10.10.0.0/16"
  tags        = { Name = "${var.name_tag}" }
}

# internal and external subnets use chunks of the cidr block
# https://www.terraform.io/docs/configuration-0-11/interpolation.html#cidrsubnet-iprange-newbits-netnum-
resource "aws_subnet" "validity-homework-internal" {
  count             = "${local.az_count}" # 3
  tags              =  { Name = "${var.name_tag}-internal-${count.index}" }
  cidr_block        = "${cidrsubnet(aws_vpc.validity-homework.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.validity-homework.id}"
}
resource "aws_subnet" "validity-homework-external" {
  count             = "${local.az_count}" # 3
  tags              =  { Name = "${var.name_tag}-external-${count.index + local.az_count }" }
  cidr_block        = "${cidrsubnet(aws_vpc.validity-homework.cidr_block, 8, count.index + local.az_count)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.validity-homework.id}"
}
resource "aws_internet_gateway" "validity-homework" {
  vpc_id = "${aws_vpc.validity-homework.id}"
  tags   =  { Name = "${var.name_tag}" }
}

# route public traffic thru internet gateway
resource "aws_route" "validity-homework" {
  # tags                    = { Name = "${var.name_tag}" }
  route_table_id          = "${aws_vpc.validity-homework.main_route_table_id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.validity-homework.id}"
}

# one NAT gateway for each az
resource "aws_nat_gateway" "validity-homework" {
  count         = "${local.az_count}" # 3
  tags          = { Name = "${var.name_tag}-${count.index}" }
  subnet_id     = "${element(aws_subnet.validity-homework-external.*.id, count.index)}"
  allocation_id = "${element(aws_eip.validity-homework.*.id, count.index)}"
}

# one route table for each private subnet
resource "aws_route_table" "validity-homework" {
  count            = "${local.az_count}" # 3
  tags             = { Name = "${var.name_tag}-${count.index}" }
  vpc_id           = "${aws_vpc.validity-homework.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.validity-homework.*.id, count.index)}"
  }
}
# associate route tables to internal subnets
resource "aws_route_table_association" "validity-homework-internal" {
  count          = "${local.az_count}" # 3
  # tags           = { Name = "${var.name_tag}-${count.index}" }
  route_table_id = "${element(aws_route_table.validity-homework.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.validity-homework-internal.*.id, count.index)}"
}

