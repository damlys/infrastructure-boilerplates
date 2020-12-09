resource "kubernetes_ingress" "http_server_ingress" {
  count = var.ingress_enabled ? 1 : 0
  depends_on = [
    kubernetes_service.http_server_service
  ]
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
    annotations = var.ingress_annotations
  }
  spec {
    rule {
      host = var.ingress_host
      http {
        path {
          path = var.ingress_path
          backend {
            service_name = local.common_name
            service_port = "http"
          }
        }
      }
    }
    tls {
      hosts = [
        var.ingress_host
      ]
      secret_name = var.ingress_tls_secret_name
    }
  }
}
