terraform {
  required_providers {
    aws   = ">= 3.54.0"
    local = ">=2.1.0"
  }
}

provider "aws" {
  region = "us-east-1"
}
