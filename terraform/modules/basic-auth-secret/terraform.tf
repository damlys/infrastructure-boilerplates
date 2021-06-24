terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
      version = "0.9.1"
    }
  }
}
