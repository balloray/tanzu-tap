module "nexus_deploy" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.9"
  deployment_name        = "nexus"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "nexus.${var.google_domain_name}"
  deployment_path        = "./charts/sonatype-nexus"
  enabled                = "true"
  template_custom_vars   = {
    null_depends_on = "${null_resource.cert_manager.id}"
    docker_endpoint    = "docker.${var.google_domain_name}"
    docker_repo_port   = "${var.nexus["docker_repo_port"]}"
    nexus_password     = "${var.nexus["admin_password"]}"
    nexus_docker_image = "${var.nexus["nexus_docker_image"]}"
    nexus_ip_ranges    = "${join(",",var.common_tools_access)}"
    nexus_pvc          = "${kubernetes_persistent_volume_claim.nexus_pv_claim.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume_claim" "nexus_pv_claim" {
  metadata {
    name      = "nexus"
    namespace = "${kubernetes_namespace.service_tools.metadata.0.name}"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "30Gi"
      }
    }
    storage_class_name = "standard"
  }
  lifecycle {
    prevent_destroy = "false"
  }
  depends_on = ["kubernetes_namespace.create_namespaces"]
}


data "template_file" "docker_config_template" {
  template = "${file("${path.module}/terraform_templates/config_template.json")}"
  vars {
    docker_endpoint = "docker.${var.google_domain_name}"
    user_data       = "${base64encode("admin:${var.nexus["admin_password"]}")}"
  }
}

resource "kubernetes_secret" "nexus_creds" {
  metadata {
    name = "nexus-creds"
  }
  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_template.rendered}"
  }
  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "nexus_creds_namespaces" {
  count = "${length(var.namespaces)}"
  metadata {
    name      = "nexus-creds"
    namespace = "${var.namespaces[count.index]}"
  }
  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_template.rendered}"
  }
  type       = "kubernetes.io/dockerconfigjson"
  depends_on = ["kubernetes_namespace.create_namespaces"]
}

resource "null_resource" "chack_norris" {
  count      = "${length(var.namespaces)}"
  provisioner "local-exec" {
    command = "kubectl patch serviceaccount default -p  '{\"imagePullSecrets\": [{\"name\": \"nexus-creds\"}]}' -n ${var.namespaces[count.index]}"
  }
  depends_on = ["kubernetes_namespace.create_namespaces"]
}

