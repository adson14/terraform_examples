
# module "vpc" {
#   source = "../vpc" # Caminho para o diretório do módulo vpc
#   prefix = var.prefix
# }

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "adson-treinamento-terraform" # Nome do bucket S3
    key    = "vpc/terraform.tfstate"       # Caminho do tfstate da VPC
    region = "us-east-1"                   # Região do bucket
  }
}


resource "aws_security_group" "sg" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  egress = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []                           # Lista vazia para IPv6
    prefix_list_ids  = []                           # Lista vazia para prefix lists
    security_groups  = []                           # Lista vazia para security groups
    self             = false                        # Não permitir acesso a partir do SG em si
    description      = "Allow all outbound traffic" # Descrição obrigatória
  }]

  tags = {
    Name = "${var.prefix}-sg"
  }
}


resource "aws_iam_role" "eks_cluster" {
  name = "${var.prefix}-${var.cluster_name}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.prefix}-${var.cluster_name}/cluster"
  retention_in_days = var.retention_period
}

resource "aws_eks_cluster" "cluster" {
  name                      = "${var.prefix}-${var.cluster_name}"
  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

    security_group_ids = [
      aws_security_group.sg.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.cluster
  ]
}
