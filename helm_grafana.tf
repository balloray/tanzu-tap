module "grafana_deploy" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "grafana"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "grafana.${var.google_domain_name}"
  deployment_path        = "./charts/grafana"
  enabled                = "true"
  template_custom_vars   = {
    null_depends_on         = "${null_resource.cert_manager.id}"
    datasource_dns_endpoint = "https://prometheus.${var.google_domain_name}"
    grafana_password        = "${var.grafana["grafana_password"]}"
    grafana_username        = "${var.grafana["grafana_username"]}"
    grafana_client_secret   = "${var.grafana["grafana_client_secret"]}"
    grafana_auth_client_id  = "${var.grafana["grafana_auth_client_id"]}"
    github_organization     = "${var.grafana["github_organization"]}"
    smtp_user               = "${var.grafana["smtp_username"]}"
    smtp_password           = "${var.grafana["smtp_password"]}"
    smtp_host               = "${var.grafana["smtp_host"]}"
    grafana_ip_ranges       = "${join(",",var.common_tools_access)}"
    slack_url               = "${var.grafana["slack_url"]}"    
  }
}