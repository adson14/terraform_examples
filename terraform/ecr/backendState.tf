terraform {
  backend "s3" {
    bucket = "adson-treinamento-terraform"
    key    = "ecr/terraform.tfstate"
    region = "us-east-1"
  }
}
