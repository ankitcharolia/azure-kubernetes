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

shop-backend-api Helm chart is stored under `charts/` folder

`aks-cluster` and `vnet` terraform module is under `modules` directory

### Question - 3
Kindly refer [this repository](https://github.com/ankitcharolia/log-analysis)

### Bonus Question - Backstage Template
kindly refer `backstage.tf`