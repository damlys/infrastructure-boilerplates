resource "kubernetes_service" "http_server_service" {
  depends_on = [
    kubernetes_deployment.http_server_deployment
  ]
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
    annotations = var.service_annotations
  }
  spec {
    type = var.service_type
    cluster_ip = var.service_type == "ClusterIP" ? var.service_cluster_ip : null
    load_balancer_ip = var.service_type == "LoadBalancer" ? var.service_load_balancer_ip : null
    port {
      name = "http"
      target_port = "http"
      port = 80
      node_port = var.service_type == "NodePort" ? var.service_node_port : null
      protocol = "TCP"
    }
    selector = local.match_labels
  }
}
