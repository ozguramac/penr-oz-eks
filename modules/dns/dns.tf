data "aws_region" "current" {}

data "aws_eks_cluster" "main" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "main" {
  name = var.cluster_id
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
  version                = ">= 1.10.0"
}

resource "aws_iam_policy" "external_dns" {
  count = 1

  name = "KubernetesExternalDNS"
  path = "/"
  description = "Allows access to resources needed to run external dns."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  count = 1

  role = var.aws_iam_role_for_policy
  policy_arn = aws_iam_policy.external_dns.0.arn
}

locals {
  kubernetes_resources_labels = {
    "penr-oz/terraform-module" = "aws-kube-external-dns",
  }

  kubernetes_deployment_labels_selector = {
    "penr-oz/deployment" = "aws-kube-external-dns-tf-module",
  }

  kubernetes_deployment_labels = merge(local.kubernetes_deployment_labels_selector, local.kubernetes_resources_labels)

  kubernetes_deployment_image = "registry.opensource.zalan.do/teapot/external-dns:v0.5.15"


  kubernetes_deployment_container_args_sources = formatlist("--source=%s", ["ingress", "service"])
  kubernetes_deployment_container_args_domains = formatlist("--domain-filter=%s", [var.hosted_domain])
  kubernetes_deployment_container_args_base = [
    "--provider=aws",
    "--policy=upsert-only",
    "--aws-zone-type=public",
    "--registry=txt",
    "--txt-owner-id=${data.aws_eks_cluster.main.name}",
  ]

  kubernetes_deployment_container_args = concat(
  local.kubernetes_deployment_container_args_sources,
  local.kubernetes_deployment_container_args_domains,
  local.kubernetes_deployment_container_args_base
  )
}

resource "kubernetes_service_account" "external_dns" {
  metadata {
    name = "external-dns"
    namespace = "kube-system"
    labels = local.kubernetes_resources_labels
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
    labels = local.kubernetes_resources_labels
  }

  rule {
    api_groups = [""]
    resources = ["services"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = [""]
    resources = ["pods"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = ["extensions"]
    resources = ["ingresses"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["list","watch"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = "external-dns"
    labels = local.kubernetes_resources_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.external_dns.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.external_dns.metadata.0.name
    namespace = kubernetes_service_account.external_dns.metadata.0.namespace
  }
}

resource "kubernetes_deployment" "external_dns" {
  metadata {
    name = "external-dns"
    namespace = "kube-system"
    labels = local.kubernetes_resources_labels
  }

  spec {
    selector {
      match_labels = local.kubernetes_deployment_labels_selector
    }

    template {
      metadata {
        labels = local.kubernetes_deployment_labels
      }

      spec {
        service_account_name = kubernetes_service_account.external_dns.metadata.0.name

        container {
          image = local.kubernetes_deployment_image
          name = "external-dns"

          args = local.kubernetes_deployment_container_args

          volume_mount { # hack for automountServiceAccountToken
            name = kubernetes_service_account.external_dns.default_secret_name
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            read_only = true
          }
        }

        volume { # hack for automountServiceAccountToken
          name = kubernetes_service_account.external_dns.default_secret_name
          secret {
            secret_name = kubernetes_service_account.external_dns.default_secret_name
          }
        }

        node_selector = {}
      }
    }
  }
}