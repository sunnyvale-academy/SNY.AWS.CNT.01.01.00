resource "aws_ecs_task_definition" "friendly-hello" {
  family                = "friendlyhello-task-def"
  container_definitions = file("task.json")

  

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-1a, eu-west-1b, eu-west-1c]"
  }
}

resource "aws_ecs_service" "service-run" {
  name            = "friendlyhello-service"
  cluster         = "demo-cluster"
  task_definition = "${aws_ecs_task_definition.friendly-hello.arn}"
  desired_count   = 2

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.ecs-target-group.arn}"
    container_name   = "friendlyhello"
    container_port   = 80
  }


  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-1a, eu-west-1b, eu-west-1c]"
  }
}

resource "aws_ecs_task_definition" "redis" {
  family                = "redis-task-def"
  container_definitions = file("redis-task.json")

  

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-1a, eu-west-1b, eu-west-1c]"
  }
}

resource "aws_ecs_service" "redis-service-run" {
  name            = "redis-service-run"
  cluster         = "demo-cluster"
  task_definition = "${aws_ecs_task_definition.redis.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-1a, eu-west-1b, eu-west-1c]"
  }
}



resource "aws_lb_target_group" "ecs-target-group" {
  name     = "ecs-lb-tg"
  port     = 30100
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  depends_on = ["aws_lb.ecs-lb"] 

  health_check {
    port   = 30100
  }
}


resource "aws_lb" "ecs-lb" {
  name               = "ecs-frindlyhello-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb_sg.id}"]
  subnets            = "${data.aws_subnet_ids.subnets.ids}"

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.ecs-lb.arn}"
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ecs-target-group.arn}"
  }
}


resource "aws_security_group" "lb_sg" {
  name_prefix = "ecs_lb_sg"
  description = "Security group for LB"
  vpc_id      = "${var.vpc_id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http" {
  type      = "ingress"
  from_port = 0
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "allow_egress_all" {
  security_group_id = aws_security_group.lb_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]
}

data "aws_subnet_ids" "subnets" {
  vpc_id = "${var.vpc_id}"
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}
