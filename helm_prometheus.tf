module "prometheus_deploy" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "prometheus-deploy"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "prometheus.${var.google_domain_name}"
  deployment_path        = "./charts/prometheus"
  enabled                = "true"
  template_custom_vars   = {
    null_depends_on      = "${null_resource.cert_manager.id}"
    prometheus_ip_ranges =  "${join(",",var.common_tools_access)}"
  }
}