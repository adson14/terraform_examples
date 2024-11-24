terraform {
  backend "s3" {
    bucket = "adson-treinamento-terraform"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
