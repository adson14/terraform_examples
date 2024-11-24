variable "prefix" {
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

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(any)
}
