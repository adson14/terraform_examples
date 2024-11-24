variable "prefix" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}
variable "cluster_name" {
  type = string
}

variable "retention_period" {
  type = number
}

variable "desired_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}
variable "bucket_name" {
  type = string
}
