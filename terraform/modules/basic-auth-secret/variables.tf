variable "k8s_namespace_name" {
  type = string
  default = "default"
}
variable "k8s_secret_name" {
  type = string
  default = "basic-auth"
}

variable "basic_auth_username" {
  type = string
  default = "demo"
}
variable "basic_auth_password" {
  type = string
  default = "demo"
  sensitive = true
}
