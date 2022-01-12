module "spinnaker_deploy" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "spinnaker"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "spinnaker.${var.google_domain_name}"
  deployment_path        = "./charts/spinnaker"
  enabled                = "${var.spinnaker_deploy}"
  template_custom_vars   = {
    null_depends_on = "${null_resource.cert_manager.id}"
  }
}
