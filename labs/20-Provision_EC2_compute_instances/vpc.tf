module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "10.0.0.0/16"

  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2]
  ]
  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  "10.0.3.0/24"]
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
  "10.0.103.0/24"]

  # If you want the EC2 instances to live within the private subnets but still be able to communicate with the public internet
  enable_nat_gateway = true
  # Save some money but less resilient to AZ failures
  single_nat_gateway = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "main" {
  id = "${module.vpc.vpc_id}"
}