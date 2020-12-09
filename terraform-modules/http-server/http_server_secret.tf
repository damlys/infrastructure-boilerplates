resource "kubernetes_secret" "http_server_secret" {
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
  }
  data = var.environment_variables.secret
}
