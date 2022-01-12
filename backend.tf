terraform {
  backend "gcs" {
    bucket  = "balloray8-bucket"
    prefix  = "tools/common_tools"
    project = "heroic-icon-336501"
  }
}
