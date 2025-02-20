# Role for node group
resource "aws_iam_role" "node-group-role" {
  name = "node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]

  })
}

resource "aws_iam_policy" "lbpolicy" {
  name        = "lbpolicy"
  path        = "/"
  description = "Load balancer node group policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:AuthorizeSecurityGroupIngress",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:CreateTargetGroup",
          "ec2:DeleteSecurityGroup",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteTags",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DescribeListenerAttributes",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:ModifyRule"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# IAM policy attachment to nodegroup
resource "aws_iam_role_policy_attachment" "node-group-LoadBalancerPolicy" {
  policy_arn = aws_iam_policy.lbpolicy.arn
  role       = aws_iam_role.node-group-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-group-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.node-group-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-group-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-group-role.name
}

# Node group 
resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.redis-cluster.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.node-group-role.arn

  subnet_ids = [
    aws_subnet.public-eu-central-1a.id,
    aws_subnet.public-eu-central-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "kubenode"
  }

   launch_template {
     name    = aws_launch_template.eks-with-disks.name
     version = aws_launch_template.eks-with-disks.latest_version
   }

  depends_on = [
    aws_iam_role_policy_attachment.node-group-LoadBalancerPolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-group-AmazonEBSCSIDriverPolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Launch template overriding response hop limit to 2
 resource "aws_launch_template" "eks-with-disks" {
   name = "eks-with-disks"

   metadata_options {
     http_endpoint               = "enabled"
     http_tokens                 = "required"
     http_put_response_hop_limit = 2
   }
 }
