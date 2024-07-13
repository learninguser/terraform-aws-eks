module "db" {
  source         = "git::https://github.com/daws-76s/terraform-aws-security-group.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = "SG for DB MySQL Instances"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
  sg_name        = "db"
}

module "ingress" {
  source         = "git::https://github.com/daws-76s/terraform-aws-security-group.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = "SG for ingress controller"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_name        = "ingress-controller"
}

module "cluster" {
  source         = "git::https://github.com/daws-76s/terraform-aws-security-group.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = "SG for cluster"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_name        = "eks-cluster"
}

module "node" {
  source         = "git::https://github.com/daws-76s/terraform-aws-security-group.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = "SG for eks node"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_name        = "eks-node"
}

# cluster is accepting traffic from node on all ports
resource "aws_security_group_rule" "cluster_node" {
  source_security_group_id = module.node.sg_id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = module.cluster.sg_id
}

# node is accepting traffic from master on all ports
resource "aws_security_group_rule" "node_cluster" {
  source_security_group_id = module.cluster.sg_id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = module.node.sg_id
}

# nodes are accepting traffic on ephemeral ports from ingress controller
resource "aws_security_group_rule" "node_ingress" {
  source_security_group_id = module.ingress.sg_id
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  security_group_id        = module.node.sg_id
}

resource "aws_security_group_rule" "allow-ephemeral" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.node.sg_id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.node.sg_id
}

resource "aws_security_group_rule" "db_node" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.node.sg_id
  security_group_id        = module.db.sg_id
}

resource "aws_security_group_rule" "cluster_default_vpc" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["172.31.0.0/16"]
  security_group_id = module.cluster.sg_id
}
