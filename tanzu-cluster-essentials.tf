module "tanzu_cluster_essentials" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "tanzu-cluster-essentials"
  deployment_path        = "./components/tanzu-cluster-essentials"
  template_custom_vars   = {
    null_depends_on = "${null_resource.tanzu-cluster-essentials.name}"
  }
}

resource "null_resource" "tanzu-cluster-essentials" {
  provisioner "local-exec" {
    command = "helm repo add jetstack https://charts.jetstack.io --force-update"
  }
}

