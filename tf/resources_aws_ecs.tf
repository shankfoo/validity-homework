
resource "aws_ecs_cluster" "validity-homework" {
  name = "${var.name_tag}"
}

resource "aws_ecs_task_definition" "validity-homework" {
  family                   = "${var.name_tag}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${local.container_cpu}"
  memory                   = "${local.container_ram}"

  container_definitions = <<JSON
[
  {
    "image": "${var.container_image}",
    "cpu": ${local.container_cpu},
    "memory": ${local.container_ram},
    "name": "${var.name_tag}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port}
      }
    ]
  }
]
JSON
}

resource "aws_ecs_service" "validity-homework" {
  launch_type     = "FARGATE"
  name            = "${var.name_tag}"
  cluster         = "${aws_ecs_cluster.validity-homework.id}"
  task_definition = "${aws_ecs_task_definition.validity-homework.arn}"
  desired_count   = "${local.az_count}"
  network_configuration {
    security_groups = ["${aws_security_group.foo_tasks.id}"]
    subnets         = ["${aws_subnet.validity-homework-internal.*.id}"]
  }
  load_balancer {
    target_group_arn = "${aws_alb_target_group.validity-homework.id}"
    container_name   = "${var.name_tag}"
    container_port   = "${var.container_port}"
  }
  depends_on = ["aws_alb_listener.validity-homework"]
}
