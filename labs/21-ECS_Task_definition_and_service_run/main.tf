resource "aws_ecs_task_definition" "service" {
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
  task_definition = "${aws_ecs_task_definition.service.arn}"
  desired_count   = 3

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }


  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-1a, eu-west-1b, eu-west-1c]"
  }
}