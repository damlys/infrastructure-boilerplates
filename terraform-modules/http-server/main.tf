locals {
  common_name = "${var.names_prefix}http-server${var.names_suffix}"
  match_labels = {
    "app.kubernetes.io/name": replace(var.image_name, "/[^a-zA-Z0-9-_.]/", "__")
    "app.kubernetes.io/instance": local.common_name
    "app.kubernetes.io/component": "http-server"
    "app.kubernetes.io/part-of": ""
    "app.kubernetes.io/managed-by": "terraform"
  }
  meta_labels = merge(local.match_labels, {
    "app.kubernetes.io/version": replace(var.image_tag, "/[^a-zA-Z0-9-_.]/", "__")
  })
}
