output "k8s_namespace_name" {
  value = kubernetes_secret.basic_auth.metadata[0].namespace
}
output "k8s_secret_name" {
  value = kubernetes_secret.basic_auth.metadata[0].name
}

output "basic_auth_username" {
  value = var.basic_auth_username
}
output "basic_auth_password" {
  value = var.basic_auth_password
  sensitive = true
}
