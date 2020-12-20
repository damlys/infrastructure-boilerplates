/*
 * Metadata
 */
variable "namespace_name" {
  type = string
  default = "default"
}
variable "names_prefix" {
  type = string
  default = ""
}
variable "names_suffix" {
  type = string
  default = ""
}

/*
 * Image
 */
variable "image_name" {
  type = string
  default = ""
  validation {
    condition = length(var.image_name) > 0
    error_message = "Image name cannot be empty."
  }
}
variable "image_tag" {
  type = string
  default = "latest"
}
variable "image_pull_policy" {
  type = string
  default = "IfNotPresent"
}
variable "image_pull_secrets" {
  type = list(string)
  default = []
}

/*
 * Container
 */
variable "container_command" {
  type = list(string)
  default = null
}
variable "container_args" {
  type = list(string)
  default = null
}
variable "environment_variables" {
  type = object({
    plain = map(string)
    secret = map(string)
  })
  default = {
    plain = {}
    secret = {}
  }
  sensitive = true
}

/*
 * Deployment
 */
variable "pod_annotations" {
  type = map(string)
  default = {}
}
variable "min_replicas" {
  type = number
  default = 1
}
variable "max_replicas" {
  type = number
  default = 1
}
variable "target_cpu_utilization_percentage" {
  type = number
  default = null
}
variable "strategy_type" {
  type = string
  default = "RollingUpdate"
}
variable "rolling_update" {
  type = object({
    max_surge = string
    max_unavailable = string
  })
  default = {
    max_surge = null
    max_unavailable = null
  }
}
variable "progress_deadline_seconds" {
  type = number
  default = null
}
variable "min_ready_seconds" {
  type = number
  default = null
}
variable "termination_grace_period_seconds" {
  type = number
  default = null
}
variable "termination_message_path" {
  type = string
  default = null
}
variable "resources" {
  type = object({
    requests = object({
      cpu = string
      memory = string
    })
    limits = object({
      cpu = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu = "100m"
      memory = "128M"
    }
    limits = {
      cpu = "1000m"
      memory = "1G"
    }
  }
}
variable "run_as_non_root" {
  type = bool
  default = true
}
variable "run_as_user" {
  type = number
  default = 1000
}
variable "run_as_group" {
  type = number
  default = 1000
}
variable "read_only_root_filesystem" {
  type = bool
  default = true
}
variable "capabilities_add" {
  type = list(string)
  default = []
}
variable "capabilities_drop" {
  type = list(string)
  default = [
    "CAP_CHOWN"
  ]
}
variable "readiness_probe_http_get_path" {
  type = string
  default = "/-/ready"
}
variable "readiness_probe_initial_delay_seconds" {
  type = number
  default = null
}
variable "readiness_probe_period_seconds" {
  type = number
  default = null
}
variable "readiness_probe_timeout_seconds" {
  type = number
  default = null
}
variable "readiness_probe_failure_threshold" {
  type = number
  default = null
}
variable "readiness_probe_success_threshold" {
  type = number
  default = null
}
variable "liveness_probe_http_get_path" {
  type = string
  default = "/-/healthy"
}
variable "liveness_probe_initial_delay_seconds" {
  type = number
  default = null
}
variable "liveness_probe_period_seconds" {
  type = number
  default = null
}
variable "liveness_probe_timeout_seconds" {
  type = number
  default = null
}
variable "liveness_probe_failure_threshold" {
  type = number
  default = null
}
variable "liveness_probe_success_threshold" {
  type = number
  default = null
}
variable "prometheus_scrape" {
  type = bool
  default = false
}
variable "prometheus_path" {
  type = string
  default = "/-/metrics"
}
variable "node_selector" {
  type = map(string)
  default = {}
}

/*
 * Network
 */
variable "container_port" {
  type = number
  default = 8080
}
variable "service_annotations" {
  type = map(string)
  default = {}
}
variable "service_type" {
  type = string
  default = "ClusterIP"
}
variable "service_cluster_ip" {
  type = string
  default = null
}
variable "service_load_balancer_ip" {
  type = string
  default = null
}
variable "service_node_port" {
  type = number
  default = null
}
variable "ingress_enabled" {
  type = bool
  default = false
}
variable "ingress_annotations" {
  type = map(string)
  default = {}
}
variable "ingress_host" {
  type = string
  default = null
}
variable "ingress_path" {
  type = string
  default = null
}
variable "ingress_tls_secret_name" {
  type = string
  default = null
}
