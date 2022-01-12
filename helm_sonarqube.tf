module "sonarqube_deploy" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "sonarqube"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "sonarqube.${var.google_domain_name}"
  deployment_path        = "./charts/sonarqube"
  enabled                = "true"
  template_custom_vars   = {
    null_depends_on          = "${null_resource.cert_manager.id}"
    sonarqube_ip_ranges      = "${join(",",var.common_tools_access)}"
    sonarqube_auth_client_id = "${var.sonarqube["sonarqube_auth_client_id"]}"
    sonarqube_auth_secret    = "${var.sonarqube["sonarqube_auth_secret"]}"
    sonarqube_admin_passwd   = "${var.sonarqube["admin_password"]}"
  }
}