resource "kubernetes_config_map" "http_server_config_map" {
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
  }
  data = var.environment_variables.plain
}
