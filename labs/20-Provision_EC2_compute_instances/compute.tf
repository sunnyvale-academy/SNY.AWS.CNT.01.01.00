data "aws_ami" "ecs" {
  most_recent = true # get the latest version

  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-*"] # ECS optimized image
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "amazon" # Only official images
  ]
}

resource "aws_autoscaling_group" "ecs_cluster_spot" {
  name_prefix = "${var.cluster_name}_asg_spot_"
  termination_policies = [
     "OldestInstance" # When a “scale down” event occurs, which instances to kill first?
  ]
  default_cooldown          = 30
  health_check_grace_period = 30
  max_size                  = var.max_spot_instances
  min_size                  = var.min_spot_instances
  desired_capacity          = var.min_spot_instances

  # Use this launch configuration to define “how” the EC2 instances are to be launched
  launch_configuration      = aws_launch_configuration.ecs_config_launch_config_spot.name

  lifecycle {
    create_before_destroy = true
  }

  # Refer to vpc.tf for more information
  # You could use the private subnets here instead,
  # if you want the EC2 instances to be hidden from the internet
  vpc_zone_identifier = module.vpc.public_subnets

  tags = [
    {
      key                 = "Name"
      value               = var.cluster_name,

      # Make sure EC2 instances are tagged with this tag as well
      propagate_at_launch = true
    }
  ]
}

# Attach an autoscaling policy to the spot cluster to target 70% MemoryReservation on the ECS cluster.
resource "aws_autoscaling_policy" "ecs_cluster_scale_policy" {
  name = "${var.cluster_name}_ecs_cluster_spot_scale_policy"
  policy_type = "TargetTrackingScaling"
  adjustment_type = "ChangeInCapacity"
  lifecycle {
    ignore_changes = [
      adjustment_type
    ]
  }
  autoscaling_group_name = aws_autoscaling_group.ecs_cluster_spot.name

  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name = "ClusterName"
        value = var.cluster_name
      }
      metric_name = "MemoryReservation"
      namespace = "AWS/ECS"
      statistic = "Average"
    }
    target_value = 70.0
  }
}


resource "aws_launch_configuration" "ecs_config_launch_config_spot" {
  name_prefix                 = "${var.cluster_name}_ecs_cluster_spot"
  image_id                    = data.aws_ami.ecs.id # Use the latest ECS optimized AMI
  instance_type               = var.instance_type_spot # e.g. t3a.medium

  # e.g. “0.013”, which represents how much you are willing to pay (per hour) most for every instance
  # See the EC2 Spot Pricing page for more information:
  # https://aws.amazon.com/ec2/spot/pricing/
  #spot_price                  = var.spot_bid_price

  enable_monitoring           = true
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }

  # This user data represents a collection of “scripts” that will be executed the first time the machine starts.
  # This specific example makes sure the EC2 instance is automatically attached to the ECS cluster that we create earlier
  # and marks the instance as purchased through the Spot pricing
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES={\"purchase-option\":\"spot\"} >> /etc/ecs/ecs.config
EOF

  # We’ll see security groups later
  security_groups = [
    aws_security_group.sg_for_ec2_instances.id
  ]

  # If you want to SSH into the instance and manage it directly:
  # 1. Make sure this key exists in the AWS EC2 dashboard
  # 2. Make sure your local SSH agent has it loaded
  # 3. Make sure the EC2 instances are launched within a public subnet (are accessible from the internet)
  key_name             = var.ssh_key_name

  # Allow the EC2 instances to access AWS resources on your behalf, using this instance profile and the permissions defined there
  iam_instance_profile = aws_iam_instance_profile.ec2_iam_instance_profile.arn
}

resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "ec2_iam_instance_profile"
  role = "ecsInstanceRole"
}

# Allow EC2 instances to receive HTTP/HTTPS/SSH traffic IN and any traffic OUT
resource "aws_security_group" "sg_for_ec2_instances" {
  name_prefix = "${var.cluster_name}_sg_for_ec2_instances_"
  description = "Security group for EC2 instances within the cluster"
  vpc_id      = data.aws_vpc.main.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = var.cluster_name
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sg_for_ec2_instances.id
}
resource "aws_security_group_rule" "allow_http_in" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_for_ec2_instances.id
  to_port           = 80
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  type = "ingress"
}

resource "aws_security_group_rule" "allow_https_in" {
  protocol  = "tcp"
  from_port = 443
  to_port   = 443
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.sg_for_ec2_instances.id
  type              = "ingress"
}
resource "aws_security_group_rule" "allow_egress_all" {
  security_group_id = aws_security_group.sg_for_ec2_instances.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]
}