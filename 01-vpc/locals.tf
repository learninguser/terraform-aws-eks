resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "terraform-eks-${random_string.suffix.result}"
}
