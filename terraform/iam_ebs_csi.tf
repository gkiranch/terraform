locals {
  oidc_provider_host = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}

resource "aws_iam_role" "ebs_csi_controller" {
  name = "eks-ebs-csi-controller-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider_host}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider_host}:aud" = "sts.amazonaws.com"
            "${local.oidc_provider_host}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_controller_policy" {
  role       = aws_iam_role.ebs_csi_controller.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Extra permission required by driver health checks
resource "aws_iam_policy" "ebs_csi_extra" {
  name        = "eks-ebs-csi-controller-extra"
  description = "Extra permissions for EBS CSI controller"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ec2:DescribeAvailabilityZones"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_extra_attach" {
  role       = aws_iam_role.ebs_csi_controller.name
  policy_arn = aws_iam_policy.ebs_csi_extra.arn
}
