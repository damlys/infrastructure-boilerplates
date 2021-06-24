resource "kubernetes_horizontal_pod_autoscaler" "http_server_horizontal_pod_autoscaler" {
  depends_on = [
    kubernetes_deployment.http_server_deployment
  ]
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
  }
  spec {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
    target_cpu_utilization_percentage = var.target_cpu_utilization_percentage
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = local.common_name
    }
  }
}
