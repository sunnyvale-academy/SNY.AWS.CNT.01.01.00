variable "vpc_name" {
  description = "The name to use VPC. Only alphanumeric characters and dash allowed (e.g. 'my-cluster')"
}

variable "cluster_name" {
  description = "The name to use to create the cluster and the resources. Only alphanumeric characters and dash allowed (e.g. 'my-cluster')"
}
variable "ssh_key_name" {
  description = "SSH key to use to enter and manage the EC2 instances within the cluster. Optional"
  default     = ""
}
variable "instance_type_spot" {
  default = "t2.micro"
}
variable "spot_bid_price" {
  default = "0.0159"
  description = "How much you are willing to pay as an hourly rate for an EC2 instance, in USD"
}
variable "min_spot_instances" {
  default     = "1"
  description = "The minimum EC2 spot instances to have available within the cluster when the cluster receives less traffic"
}
variable "max_spot_instances" {
  default     = "3"
  description = "The maximum EC2 spot instances that can be launched during period of high traffic"
}
variable "desired_capacity" {
  default     = "3"
  description = "The number of EC2 spot instances that have to be launched"
}