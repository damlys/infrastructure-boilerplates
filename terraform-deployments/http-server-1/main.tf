terraform {
  backend "local" {
  }
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
  }
}

provider "kubernetes" {
}

module "nginx_staging" {
  source = "../../terraform-modules/http-server"

  namespace_name = "terraform-playground"
  names_prefix = "nginx-"
  names_suffix = "-staging"

  image_name = "nginx"
  image_tag = "1.19"

  run_as_non_root = false
  run_as_user = 0
  run_as_group = 0
  read_only_root_filesystem = false
  capabilities_drop = []
  liveness_probe_http_get_path = "/"
  readiness_probe_http_get_path = "/"

  container_port = 80
  ingress_enabled = true
  ingress_host = "staging.example.tld"
  ingress_path = "/"
  ingress_tls_secret_name = "example-tls-certificate-secret"
}

module "nginx_prod" {
  source = "../../terraform-modules/http-server"

  namespace_name = "terraform-playground"
  names_prefix = "nginx-"
  names_suffix = "-prod"

  image_name = "nginx"
  image_tag = "1.19"

  run_as_non_root = false
  run_as_user = 0
  run_as_group = 0
  read_only_root_filesystem = false
  capabilities_drop = []
  liveness_probe_http_get_path = "/"
  readiness_probe_http_get_path = "/"

  container_port = 80
  ingress_enabled = true
  ingress_host = "prod.example.tld"
  ingress_path = "/"
  ingress_tls_secret_name = "example-tls-certificate-secret"
}
