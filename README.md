**THE COMMON_TOOLS DEPLOYMENT STEPS**


Prerequisites:

Make sure you have finished with [cluster-infrastructure](https://github.com/fuchicorp/cluster-infrastructure) deployment


## Terraform Version 
```
Terraform v0.11.15
+ provider.helm v1.3.2
+ provider.kubernetes v1.13.4
+ provider.local v1.4.0
+ provider.null v2.1.2
+ provider.template v2.1.2
```

**A - THE STEPS OF CONFIGURATION:**


1. Clone the repository from GitHub

```
git clone https://github.com/fuchicorp/common_tools.git
cd common_tools
```

2. Make sure `~/google-credentials.json` is exist and can be used by common tools 
```
ls -l ~/google-credentials.json  
```


3. Create Github oAuth Credentials under your github account. </br>
Please note that once you generate your client secret you will not be able to repull this information.  You can generate new secret if you lose your inital seceret text.  You will need both the Client ID and Client secret for each App for the common_tools.tvars configuration in the next step. </br>

   - Go to your github profile page than go Settings>> Developer Settings >>  oAuth Apps </br>
   - You have to create a new oAuth application for each of the resource ( Jenkins, Grafana, Sonarqube )</br>
   - Replace "fuchicorp.com" with your domain name. <br>
- Jenkins
```
     Register a new oAuth application:
     Application Name: Jenkins
     HomePage URL, add your domain name: https://jenkins.yourdomain.com
     Authorization callback URL: https://jenkins.yourdomain.com/securityRealm/finishLogin
     
```
- Grafana
 ```    
     Register a new oAuth application:
     Application Name: Grafana
     HomePage URL, add your domain name: https://grafana.yourdomain.com/login
     Authorization callback URL: https://grafana.yourdomain.com/login
     
```
- Dashboard Kubernetes
 ```  
     Register a new oAuth application:
     Application Name: Dashboard Kubernetes
     HomePage URL, add your domain name: https://dashboard.yourdomain.com
     Authorization callback URL: https://dashboard.yourdomain.com/oauth2/callback
     
```
- Sonarqube
 ```
     Register a new oAuth application:
     Application Name: Sonarqube 
     HomePage URL, add your domain name: https://sonarqube.yourdomain.com
     Authorization callback URL: https://sonarqube.yourdomain.com/oauth2/callback
```
4. Create `common_tools.tfvars` file inside common_tools directory. </br>
#Spelling of `common_tools.tfvars` must be exactly same syntax see [WIKI](https://github.com/fuchicorp/common_tools/wiki/Create-a-jenkins-secret-type-SecretFile-on-kubernetes-using-terraform) for more info

5. Configure  the `common_tools.tfvars` file 

```
# Your main configurations for common tools 
google_bucket_name         = "" # Write your bucket name from google cloud
google_project_id          = "" # Write your project id from google cloud
google_domain_name         = "" # your domain name
deployment_environment     = "" # namespace you like to deploy
deployment_name            = "" # Configure a deployment name

# Your Jenkins configuration !!
jenkins = {
  admin_user               = "" # Configure jenkins admin username
  admin_password           = "" # Configure strong password for Jenkins admin
  jenkins_auth_client_id   = "" # Client ID for jenkins from your github oAuth Apps
  jenkins_auth_secret      = "" # Client Secret for jenkins from your github oAuth Apps
  git_token                = "" # Github token
  git_username             = "" # Github username
}

# Your Nexus configuration !!
nexus = {
  admin_password           = "" # Configure strong password for Nexus admin  
}

# Your Grafana configuration !!
grafana = {
  grafana_username         = "" # Configure grafana admin username
  grafana_password         = "" # Configure strong password for Grafana
  grafana_auth_client_id   = "" # Client ID for grafana from your github oAuth Apps
  grafana_client_secret    = "" # Client Secret for grafana from your github oAuth Apps
  slack_url                = "" # Slack channel url for alerts
}

# THIS IS OPTIONAL TO FILL OUT
# Your Kubernetes Dashboard configuration !!
kube_dashboard = {
  github_auth_client_id    = "" # Client ID for kube dashboard from your github oAuth Apps
  github_auth_secret       = "" # Client Secret for kube dashboard from your github oAuth Apps
}

# Your SonarQube configuration !!
sonarqube = {
  sonarqube_auth_client_id = "" # Client ID for Sonarqube from your github oAuth Apps
  sonarqube_auth_secret    = "" # Client Secret for Sonarqube from your github oAuth Apps
  admin_password           = "" # Configure a strong password for sonarqube admin
}

#create lists of trusted IP addresses or IP ranges from which your users can access your domains
common_tools_access = [ 
  "10.16.0.27/8",     # Cluster access
  "50.194.68.229/32", # Office IP1 
  "50.194.68.230/32", # Office IP2
  "24.12.115.204/32", # fsadykov home
  "#.#.#.#",          # Add your IP address (Required)
]

# Set to <false> to do not show password on terraform output
show_passwords            = "true" # Set to false when presenting a demo or showing output to someone

# Optional common_tools
dashboard_deployer        = "false" # Optional, set to true to deploy
spinnaker_deploy          = "false" # Optional, set to true to deploy
waypoint_deploy           = "false" # Optional, set to true to deploy
```

6. The name servers that respond to DNS queries for this domain. Your DNS and cluster/cloud DNS (name servers) should be matched for connection.
   if you use Route53, you have to check and edit your name servers. 

   ### Registered Zones
   - To find your GCP NS record to copy from, go to your GCloud console, type in search bar "Cloud DNS"
   - Click "cluster-infrastructure-zone" and look for NS record
   - You will see something similar to this
      ```
      ns-cloud-b1.googledomains.com.
      ns-cloud-b2.googledomains.com.
      ns-cloud-b3.googledomains.com.
      ns-cloud-b4.googledomains.com.
      ```
   - Now open Route53 in AWS and go to Domains > Register domains. 
   - Click on your domain name and you will see "Name Servers" on the far right.  You will need to click "Add or edit name servers"
   - Copy and paste each record from your GCP NS into this area and save.  </br>**This will take some time to update, be patient.  You will recieve an email from AWS when updated. 
   
   
   

7. After you have configured all of the above now you run commands below to create the resources.
commands:

```
source set-env.sh common_tools.tfvars
terraform apply -var-file=$DATAFILE
```

If you are facing any issues please submit the issue here https://github.com/fuchicorp/common_tools/issues