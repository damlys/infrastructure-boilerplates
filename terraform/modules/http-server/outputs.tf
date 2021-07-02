output "internal_endpoint" {
  value = "http://${var.k8s_resources_name}"
}
output "external_endpoint" {
  value = (
  var.ingress_enabled ? "https://${var.ingress_host}${var.ingress_path}" : (
  var.service_type == "LoadBalancer" ? "http://${kubernetes_service.this.status[0].load_balancer[0].ingress[0].hostname}" : (
  var.service_type == "NodePort" ? "http://${kubernetes_service.this.spec[0].cluster_ip}:${kubernetes_service.this.spec[0].port[0].node_port}" : (
  ""))))
}
