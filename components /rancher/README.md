# Rancher deployment 


## Requirements
1. Make sure common tools up and running
2. Cert manager should be up and running
3. External DNS should all DNS records
4. Ingress controller should router the traffics


First you will need to go common tools folder since rancher chart is there
```
cd ~/common_tools/charts/rancher
```


Ones you are in you need to do small change in values.yaml of the rancher
```
vim values.yaml
hostname: rancher.fuchicorp.com > rancher.your-domain-name.com

```

Ones you did the changes in `values.yaml` you can go ahead and deploy it by running 
```
helm upgrade --install rancher -n tools ./
```

