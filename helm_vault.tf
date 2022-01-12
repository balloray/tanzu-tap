# FuchiCorp Vault Deployment
module "vault_deploy" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "vault"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "vault.${var.google_domain_name}"
  deployment_path        = "./charts/vault"
  enabled                = "true"
  template_custom_vars   = {
    null_depends_on = "${null_resource.cert_manager.id}"
    vault_ip_ranges = "${join(",",var.common_tools_access)}"
  }
}