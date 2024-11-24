terraform {
  backend "s3" {
    bucket = "adson-treinamento-terraform"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
