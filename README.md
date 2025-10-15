## Azure Kubernetes Services
```shell
# Make sure to login using Azure CLI
az login
# check available Azure subscription
az account list --output table
# Set the correct subscription by ID or name
az account set --subscription "SUBSCRIPTION-NAME"
```


```shell
# Terraform command
terraform workspace list
terraform workspace select <ENV_NAME>
terraform init -upgrade
terraform fmt -recurisve
terraform validate
terraform plan -var-file=environments/test.tfvars
terraform apply -var-file=environments/test.tfvars
```

### Question - 1
Kindly refer `question-1.tf`

### Question - 2
Kindly refer `question-2.tf`
* python start as child process of bash script (PID 1) and pythpn SimpleHTTPServer module can not handle concurrent request. so livenessprobe and readiness probe is failing.
* shop-backend-api Helm chart is stored under `charts/` folder
* `aks-cluster` and `vnet` terraform module is under `modules` directory

### Question - 3
Kindly refer [this repository](https://github.com/ankitcharolia/log-analysis)


## Debug
```shell
kubectl debug -it shop-backend-api-b77dfc8cc-vfgkz --image=ubuntu --target=shop-backend-api
 apt-get install -y curl wget dnsutils net-tools iputils-ping telnet netcat-traditional gpg
```