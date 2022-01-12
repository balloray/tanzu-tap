module "ingress_controller" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "ingress-controller"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "ingress.${var.google_domain_name}"
  deployment_path        = "./charts/ingress-controller"
  enabled                = "true"
  template_custom_vars   = {
    null_depends_on = "${null_resource.cert_manager.id}"
  }
}