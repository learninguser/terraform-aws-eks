module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = data.aws_ssm_parameter.cluster_name.value
  cluster_version = "1.30"

  cluster_endpoint_public_access = false

  vpc_id                   = local.vpc_id
  subnet_ids               = split(",", local.private_subnet_ids)
  control_plane_subnet_ids = split(",", local.private_subnet_ids)

  create_cluster_security_group = false
  cluster_security_group_id     = local.cluster_sg_id

  create_node_security_group = false
  node_security_group_id     = local.node_sg_id

  # The user which you used to create cluster will get admin access
  enable_cluster_creator_admin_permissions = true

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    # instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
    instance_types = ["t3.small"]
  }

  eks_managed_node_groups = {

    blue = {
      min_size      = 2
      max_size      = 3
      desired_size  = 2
      capacity_type = "SPOT"
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
        AmazonEC2FullAccess               = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
        AmazonRDSFullAccess               = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
      }
    }

    # green = {
    #   min_size      = 2
    #   max_size      = 3
    #   desired_size  = 2
    #   capacity_type = "SPOT"
    #   iam_role_additional_policies = {
    #     AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
    #     AmazonEC2FullAccess               = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    #     AmazonRDSFullAccess               = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
    #   }
    # }
  }

  tags = var.common_tags
}
