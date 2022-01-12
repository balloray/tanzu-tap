google_bucket_name       = "balloray8-bucket"
google_project_id        = "heroic-icon-336501"
google_domain_name       = "balloray.com"
vault_token               = ""
deployment_environment   = "tools"
deployment_name          = "common_tools"

jenkins = {
  admin_user             = "admin"
  admin_password         = "redhat"
  jenkins_auth_client_id = "8b4d1557524b3edb9694"
  jenkins_auth_secret    = "bdfbd6068682cf77a15bd0ddd263dfca44443693"
  git_token              = "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"
  git_username           = "balloray"
}

nexus = {
   admin_password         = "nexusfuchicorp"            # Configure strong password for Nexus admin  
}

grafana = {
  grafana_username                = "admin"
  grafana_password                = "redhat"
  grafana_auth_client_id          = "09e273769c16668b2b93"
  grafana_client_secret           = "06f45a3e4649d9a71745d9a6cddcd80c53384688"
  slack_url                       = "https://hooks.slack.com/services/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"
  git_organisation                = "balloray-llc"
}

kube_dashboard = {
  github_auth_client_id          = "F6a3d228e98ad0658c6b"
  github_auth_secret             = "2854fb2975b5ab6725939b5229eaec52d317d5eb"
  github_organization            = "balloray-llc"
}

sonarqube = {
  sonarqube_auth_client_id    = "8f7850896cead6a83a6f" 
  sonarqube_auth_secret       = "56f5795e695d84663b3b2ae5243e0944e4cf3a86"
  admin_password              = "sonarqubefuchicorp" # Configure a strong password for sonarqube admin
}

#create lists of trusted IP addresses or IP ranges from which your users can access your domains
common_tools_access = [
                        "10.16.0.27/8",         ## Cluster access
                        "50.194.68.229/32",     ## Office IP1
                        "50.194.68.230/32",     ## Office IP2
                        "50.194.68.237/32",     ## fsadykov home
                        "146.120.213.167/32",   ## fsadykov Russia
                        "24.14.53.36/32",       ## fsadykov 
                        "67.175.156.228/32",    ## My Home IP
			                  "67.167.220.165/32",    ## Kelly was here
                        "73.111.37.229",
                        "172.58.142.241",
                        "73.183.190.36/32",
                      ]

# Set to <false> to do not show password on terraform output
show_passwords            = "true" # Set to false when presenting a demo or showing output to someone

# Optional common_tools
dashboard_deployer        = "false" # Optional, set to true to deploy
spinnaker_deploy          = "false" # Optional, set to true to deploy
waypoint_deploy           = "false" # Optional, set to true to deploy

github_org = "balloray-llc"
github_owner = "balloray"
