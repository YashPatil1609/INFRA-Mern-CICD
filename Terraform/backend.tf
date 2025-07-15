terraform {
  backend "s3" {
    bucket         = "yash-terraform-state-bucket"
    key            = "myapp/terraform.tfstate"
    region         = "us-east-1"
  }
}