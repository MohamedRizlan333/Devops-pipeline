terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"  # Compatible version
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "simple-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.0"

  cluster_name    = "my-simple-cluster"
  cluster_version = "1.28"  # ✅ UPDATED TO SUPPORTED VERSION
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t2.micro"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }
}


