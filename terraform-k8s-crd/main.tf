terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "helm" {}

resource "helm_release" "metrics_server" {
  namespace = "kube-system"
  name = "metrics-server"
  chart = "./charts/metrics-server"
}
