module "roboshop" {
  # source       = "../../terraform-aws-vpc"
  source       = "git::https://github.com/learninguser/terraform-aws-vpc.git?ref=master"
  project_name = var.project_name
  environment  = var.environment
  cidr_block   = var.cidr_block

  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr

  vpc_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  common_tags         = var.common_tags
  is_peering_required = var.is_peering_required
}