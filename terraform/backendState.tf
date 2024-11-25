terraform {
  backend "s3" {
    bucket = "adson-treinamento-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
