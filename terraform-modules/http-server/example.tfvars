namespace_name = "terraform-playground"
names_prefix = "prefix-"
names_suffix = "-suffix"

image_name = "nginx"
image_tag = "1.19"
image_pull_secrets = [
  "example-image-pull-secret"
]

environment_variables = {
  plain = {
    APP_USERNAME = "usernameX"
  }
  secret = {
    APP_PASSWORD = "passwordX"
  }
}

run_as_non_root = false
run_as_user = 0
run_as_group = 0
read_only_root_filesystem = false
capabilities_add = []
capabilities_drop = []
liveness_probe_http_get_path = "/"
readiness_probe_http_get_path = "/"

container_port = 80
service_type = "NodePort"
service_node_port = 30080
ingress_enabled = false
ingress_annotations = {
  "ingress.kubernetes.io/auth-type" = "basic"
  "ingress.kubernetes.io/auth-secret" = "example-htpasswd-secret"
}
ingress_host = "www.example.tld"
ingress_path = "/"
ingress_tls_secret_name = "example-tls-certificate-secret"
