terraform {
  backend "s3" {
    # Replace this with YOUR bucket's name 
    bucket         = "terraform-state-it-sunnyvale"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
  }
}