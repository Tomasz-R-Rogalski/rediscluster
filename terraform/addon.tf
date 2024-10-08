resource "aws_eks_addon" "ebs-addon" {
  cluster_name = aws_eks_cluster.redis-cluster.name
  addon_name   = "aws-ebs-csi-driver"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.redis-cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kubeproxy" {
  cluster_name = aws_eks_cluster.redis-cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.redis-cluster.name
  addon_name   = "vpc-cni"
}
