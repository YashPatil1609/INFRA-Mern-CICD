terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "myapp/terraform.tfstate"
    region         = "us-east-1"
  }
}