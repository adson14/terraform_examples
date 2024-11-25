module "new-vpc" {
  source         = "./modules/vpc"
  prefix         = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}


module "new-eks" {
  source             = "./modules/eks"
  prefix             = var.prefix
  vpc_id             = module.new-vpc.vpc_id
  cluster_name       = var.cluster_name
  retention_period   = var.retention_period
  desired_size       = var.desired_size
  max_size           = var.max_size
  min_size           = var.min_size
  private_subnet_ids = module.new-vpc.private_subnet_ids
}

module "newecr" {
  source = "./modules/ecr"
  prefix = var.prefix
}
