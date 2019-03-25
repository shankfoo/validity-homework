resource "aws_eip" "validity-homework" {
  count      = "${local.az_count}" # 3
  tags       = { Name = "${var.name_tag}-${count.index}" }
  vpc        = true
  depends_on = ["aws_internet_gateway.validity-homework"] # why?
}

resource "aws_alb" "validity-homework" {
  tags            = { Name = "${var.name_tag}" }
  name            = "${var.name_tag}"
  subnets         = ["${aws_subnet.validity-homework-external.*.id}"]
  security_groups = ["${aws_security_group.foo_alb.id}"]
}

resource "aws_alb_target_group" "validity-homework" {
  tags        = { Name = "${var.name_tag}" }
  name        = "${var.name_tag}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.validity-homework.id}"
  target_type = "ip"
}

resource "aws_alb_listener" "validity-homework" {
  load_balancer_arn = "${aws_alb.validity-homework.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.validity-homework.id}"
    type             = "forward"
  }
}
resource "aws_security_group" "foo_alb" {
  tags        = { Name = "${var.name_tag}_alb" }
  name        = "${var.name_tag}-alb"
  description = "controls public access to the alb"
  vpc_id      = "${aws_vpc.validity-homework.id}"
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "foo_tasks" {
  tags        = { Name = "${var.name_tag}_tasks" }
  name        = "${var.name_tag}-tasks"
  description = "allow inbound access from alb only"
  vpc_id      = "${aws_vpc.validity-homework.id}"
  ingress {
    protocol        = "tcp"
    from_port       = "${var.container_port}"
    to_port         = "${var.container_port}"
    security_groups = ["${aws_security_group.foo_alb.id}"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
