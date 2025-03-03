# Declaración del recurso aws_iam_user
data "aws_iam_user" "example" {
  user_name = "kopsadmin"  # O el nombre de usuario que estás utilizando
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0" # Nos aseguramos de que solo se actualizará la versión 19

  cluster_name    = "jam-eks"
  cluster_version = "1.27"

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
      resolve_conflict = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflict = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflict = "OVERWRITE"
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = data.aws_iam_user.example.arn  # Referencia al recurso aws_iam_user.example
      username = "kopsadmin"
      groups = [
        "system:masters"
      ]
    }
  ]

  eks_managed_node_groups = {
    node-group = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_types   = ["t3.medium"]

      tags = {
        Environment = "tech"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "tech"
  }
}

# Obtener información del clúster EKS
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

# Obtener autenticación para el clúster EKS
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# Configuración del proveedor Kubernetes
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
