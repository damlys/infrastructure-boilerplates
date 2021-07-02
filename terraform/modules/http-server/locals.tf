locals {
  match_labels = {
    "app.kubernetes.io/name": replace(var.image_name, "/[^a-zA-Z0-9-_.]/", "__")
    "app.kubernetes.io/instance": var.k8s_resources_name
    "app.kubernetes.io/component": "http-server"
    "app.kubernetes.io/part-of": var.k8s_namespace_name
    "app.kubernetes.io/managed-by": "terraform"
  }
  meta_labels = merge(local.match_labels, {
    "app.kubernetes.io/version": replace(var.image_tag, "/[^a-zA-Z0-9-_.]/", "__")
  })
  tls_secret_name = "tls-${join("-", reverse(split(".", var.ingress_host)))}"
  config_checksum = md5(jsonencode(merge(var.plain_environment_variables, var.secret_environment_variables)))
}
