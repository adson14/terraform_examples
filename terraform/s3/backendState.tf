terraform {
  backend "s3" {
    bucket = "adson-treinamento-terraform"
    key    = "s3/terraform.tfstate"
    region = "us-east-1"
  }
}
