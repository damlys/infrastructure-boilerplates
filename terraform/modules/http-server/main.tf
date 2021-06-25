resource "kubernetes_config_map" "this" {
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
  }
  data = var.plain_environment_variables
}

resource "kubernetes_secret" "this" {
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
  }
  data = var.secret_environment_variables
}

resource "kubernetes_deployment" "this" {
  depends_on = [
    kubernetes_config_map.this,
    kubernetes_secret.this
  ]
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
  }
  spec {
    replicas = var.min_replicas
    strategy {
      type = var.strategy_type
      rolling_update {
        max_surge = var.strategy_type == "RollingUpdate" ? var.rolling_update.max_surge : null
        max_unavailable = var.strategy_type == "RollingUpdate" ? var.rolling_update.max_unavailable : null
      }
    }
    progress_deadline_seconds = var.progress_deadline_seconds
    min_ready_seconds = var.min_ready_seconds
    selector {
      match_labels = local.match_labels
    }
    template {
      metadata {
        labels = local.meta_labels
        annotations = merge({
          "prometheus.io/scrape" = tostring(var.prometheus_scrape)
          "prometheus.io/port" = "http"
          "prometheus.io/path" = var.prometheus_path
          "config-checksum" = local.config_checksum
        }, var.pod_annotations)
      }
      spec {
        restart_policy = "Always"
        termination_grace_period_seconds = var.termination_grace_period_seconds
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secrets
          content {
            name = image_pull_secrets.value
          }
        }
        container {
          name = local.common_name
          image = "${var.image_name}:${var.image_tag}"
          image_pull_policy = var.image_pull_policy
          command = var.container_command
          args = var.container_args
          env_from {
            config_map_ref {
              name = local.common_name
            }
          }
          env_from {
            secret_ref {
              name = local.common_name
            }
          }
          resources {
            requests = {
              cpu = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }
            limits = {
              cpu = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
          }
          security_context {
            run_as_non_root = var.run_as_non_root
            run_as_user = var.run_as_user
            run_as_group = var.run_as_group
            read_only_root_filesystem = var.read_only_root_filesystem
            capabilities {
              add = var.capabilities_add
              drop = var.capabilities_drop
            }
          }
          port {
            name = "http"
            container_port = var.container_port
            protocol = "TCP"
          }
          readiness_probe {
            http_get {
              port = "http"
              path = var.readiness_probe_http_get_path
            }
            initial_delay_seconds = var.readiness_probe_initial_delay_seconds
            period_seconds = var.readiness_probe_period_seconds
            timeout_seconds = var.readiness_probe_timeout_seconds
            failure_threshold = var.readiness_probe_failure_threshold
            success_threshold = var.readiness_probe_success_threshold
          }
          liveness_probe {
            http_get {
              port = "http"
              path = var.liveness_probe_http_get_path
            }
            initial_delay_seconds = var.liveness_probe_initial_delay_seconds
            period_seconds = var.liveness_probe_period_seconds
            timeout_seconds = var.liveness_probe_timeout_seconds
            failure_threshold = var.liveness_probe_failure_threshold
            success_threshold = var.liveness_probe_success_threshold
          }
          termination_message_path = var.termination_message_path
        }
        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                topology_key = "kubernetes.io/hostname"
                label_selector {
                  match_labels = local.meta_labels
                }
              }
            }
          }
        }
        node_selector = var.node_selector
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "this" {
  depends_on = [
    kubernetes_deployment.this
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

resource "kubernetes_service" "this" {
  depends_on = [
    kubernetes_deployment.this
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

resource "kubernetes_ingress" "this" {
  count = var.ingress_enabled ? 1 : 0
  depends_on = [
    kubernetes_service.this
  ]
  wait_for_load_balancer = true
  metadata {
    namespace = var.namespace_name
    name = local.common_name
    labels = local.meta_labels
    annotations = var.ingress_annotations
  }
  spec {
    rule {
      host = var.ingress_host
      http {
        path {
          path = var.ingress_path
          backend {
            service_name = local.common_name
            service_port = "http"
          }
        }
      }
    }
    tls {
      hosts = [
        var.ingress_host
      ]
      secret_name = local.tls_secret_name
    }
  }
}
