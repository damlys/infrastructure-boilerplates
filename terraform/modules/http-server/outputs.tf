data "kubernetes_service" "http_server_service" {
  depends_on = [
    kubernetes_service.http_server_service
  ]
  metadata {
    namespace = var.namespace_name
    name = local.common_name
  }
}

data "kubernetes_ingress" "http_server_ingress" {
  count = var.ingress_enabled ? 1 : 0
  depends_on = [
    kubernetes_ingress.http_server_ingress
  ]
  metadata {
    namespace = var.namespace_name
    name = local.common_name
  }
}

output "internal_endpoint" {
  value = "http://${local.common_name}"
}
output "external_endpoint" {
  value = (
  var.ingress_enabled ? "https://${var.ingress_host}${var.ingress_path}" : (
  var.service_type == "LoadBalancer" ? "http://${data.kubernetes_service.http_server_service.status[0].load_balancer[0].ingress[0].hostname}" : (
  var.service_type == "NodePort" ? "http://${data.kubernetes_service.http_server_service.spec[0].cluster_ip}:${data.kubernetes_service.http_server_service.spec[0].port[0].node_port}" : (
  ""))))
}
