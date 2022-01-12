module "dashboard_deployer" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "kubernetes-dashboard"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "dashboard.${var.google_domain_name}"
  deployment_path        = "./charts/kubernetes-dashboard"
  enabled                = "${var.dashboard_deployer}"
  template_custom_vars   = {
    null_depends_on       = "${null_resource.cert_manager.id}"
    github_organization   = "${var.skip_github_organization == "false" ? "fuchicorp" : "" }"
    github_auth_client_id = "${var.kube_dashboard["github_auth_client_id"]}"
    github_auth_secret    = "${var.kube_dashboard["github_auth_secret"]}"
    proxy_cookie_secret   = "${var.kube_dashboard["proxy_cookie_secret"]}"
  }
}