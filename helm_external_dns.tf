module "external-dns" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "external-dns"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "${var.google_domain_name}"
  deployment_path        = "./charts/external-dns"
  enabled                = "true"
  template_custom_vars   = {
    google_project  = "${var.google_project_id}"
    null_depends_on = "${null_resource.cert_manager.id}"
  }
}

resource "kubernetes_secret" "external_dns_secret" {
  metadata {
    name      = "google-service-account"
    namespace = "${kubernetes_namespace.service_tools.metadata.0.name}"
  }
  data = {
    "credentials.json" = "${file(pathexpand("~/google-credentials.json"))}"
  }
  type = "generic"
}

resource "null_resource" "kube_dns" {
  provisioner "local-exec" {
    command = "kubectl apply -f terraform_templates/kube-dns.yaml"
  }
}