data "tls_certificate" "eks-tls" {
  url = aws_eks_cluster.redis-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks-tls" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.redis-cluster.identity[0].oidc[0].issuer
}
