resource "htpasswd_password" "basic_auth_password_hash" {
  password = var.basic_auth_password
  salt = substr(sha512(var.basic_auth_password), 0, 8)
}

resource "kubernetes_secret" "basic_auth" {
  metadata {
    namespace = var.k8s_namespace_name
    name = var.k8s_secret_name
  }
  data = {
    auth = "${var.basic_auth_username}:${htpasswd_password.basic_auth_password_hash.apr1}"
  }
}
