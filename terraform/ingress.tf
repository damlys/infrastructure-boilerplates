/**********************************************
*
* Ingress controller
* https://kubernetes.github.io/ingress-nginx/
*
***********************************************/

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

// https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx
resource "helm_release" "ingress_nginx" {
  namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
  name = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  version = "3.33.0"

  values = [file("${path.module}/resources/helm_release-ingress_nginx.yaml")]
}

data "kubernetes_service" "ingress_nginx_controller" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  metadata {
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
    name = "ingress-nginx-controller"
  }
}
output "ingress_nginx_controller_hostname" {
  value = data.kubernetes_service.ingress_nginx_controller.status[0].load_balancer[0].ingress[0].hostname
}

/**********************************************
*
* TLS certificates manager
* https://cert-manager.io/
*
***********************************************/

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

// https://github.com/jetstack/cert-manager/tree/master/deploy/charts/cert-manager
resource "helm_release" "cert_manager" {
  depends_on = [
    helm_release.ingress_nginx,
  ]

  namespace = kubernetes_namespace.cert_manager.metadata[0].name
  name = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart = "cert-manager"
  version = "v1.4.0"

  values = [file("${path.module}/resources/helm_release-cert_manager.yaml")]
}

resource "helm_release" "cert_manager_issuers" {
  depends_on = [
    helm_release.cert_manager,
  ]

  namespace = kubernetes_namespace.cert_manager.metadata[0].name
  name = "cert-manager-issuers"
  chart = "./charts/cert-manager-issuers"
}
