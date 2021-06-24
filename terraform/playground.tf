resource "kubernetes_namespace" "playground" {
  metadata {
    name = "playground"
  }
}

module "playground_basic_auth" {
  source = "./modules/basic-auth-secret"

  k8s_namespace_name = kubernetes_namespace.playground.metadata[0].name
}

module "kuard_staging" {
  source = "./modules/http-server"

  namespace_name = kubernetes_namespace.playground.metadata[0].name
  names_prefix = "kuard-"
  names_suffix = "-staging"

  image_name = "gcr.io/kuar-demo/kuard-amd64"
  image_tag = "v0.9-purple"

  liveness_probe_http_get_path = "/healthy"
  readiness_probe_http_get_path = "/ready"
  prometheus_scrape = false
  prometheus_path = "/metrics"

  ingress_enabled = true
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
    "kubernetes.io/tls-acme" = "true"
    "cert-manager.io/cluster-issuer" = "letsencrypt-staging"
    "nginx.ingress.kubernetes.io/auth-type" = "basic"
    "nginx.ingress.kubernetes.io/auth-secret" = module.playground_basic_auth.k8s_secret_name
  }
  # TODO change host
  ingress_host = "kuard-staging.foo.bar.baz"
}
output "kuard_staging_external_endpoint" {
  value = module.kuard_staging.external_endpoint
}

module "kuard_prod" {
  source = "./modules/http-server"

  namespace_name = kubernetes_namespace.playground.metadata[0].name
  names_prefix = "kuard-"
  names_suffix = "-prod"

  image_name = "gcr.io/kuar-demo/kuard-amd64"
  image_tag = "v0.9-green"

  min_replicas = 2
  max_replicas = 3
  target_cpu_utilization_percentage = 10

  liveness_probe_http_get_path = "/healthy"
  readiness_probe_http_get_path = "/ready"
  prometheus_scrape = true
  prometheus_path = "/metrics"

  ingress_enabled = true
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
    "kubernetes.io/tls-acme" = "true"
    "nginx.ingress.kubernetes.io/auth-type" = "basic"
    "nginx.ingress.kubernetes.io/auth-secret" = module.playground_basic_auth.k8s_secret_name
  }
  # TODO change host
  ingress_host = "kuard-prod.foo.bar.baz"
}
output "kuard_prod_external_endpoint" {
  value = module.kuard_prod.external_endpoint
}
