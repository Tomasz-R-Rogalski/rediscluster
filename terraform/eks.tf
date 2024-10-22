# IAM role for eks
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"
  tags = {
    tag-key = "eks-cluster-role"
  }

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# eks policy attachment
resource "aws_iam_role_policy_attachment" "eks-cluster-policy-attachments" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS cluster
resource "aws_eks_cluster" "redis-cluster" {
  name     = "redis-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-eu-central-1a.id,
      aws_subnet.private-eu-central-1b.id,
      aws_subnet.public-eu-central-1a.id,
      aws_subnet.public-eu-central-1b.id
    ]
  }
  instance_metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  depends_on = [aws_iam_role_policy_attachment.eks-cluster-policy-attachments]
}
