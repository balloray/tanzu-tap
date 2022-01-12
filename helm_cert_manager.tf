module "cert_manager_deploy" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "cert-manager"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "cert-manager.${var.google_domain_name}"
  enabled                = "true"
  deployment_path        = "./charts/cert-manager"
  template_custom_vars   = {
    null_depends_on = "${null_resource.cert_manager_crds.id}"
  }
}

resource "null_resource" "cert_manager" {
  provisioner "local-exec" {
    command = "helm repo add jetstack https://charts.jetstack.io --force-update"
  }
}

resource "null_resource" "cert_manager_crds" {
  provisioner "local-exec" {
    command      = "kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.crds.yaml"
  }
  depends_on = [
    "null_resource.cert_manager"
  ]
}