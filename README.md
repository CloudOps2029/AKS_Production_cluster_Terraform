
# Provision AKS cluster using Terraform via Service Principal

In this project, we will be creating AKS cluster the right way by using service principle.kubeconfig and service principle will be generated after the terraform plan and secret will be upload to keyvault to be used further.

## Below resources will be created using this terraform configuration:-
- Resource Group
- Service Principle
- AKS cluster using the SPN
- Azure key vault to store the client secret
- Secret uploaded to key vault
- kubeconfig for AKS


## Pre-requisites

- kubectl cli installed
- Azure CLI installed and logged in
- Storage Account and blob container created to store the tfstate file as backend, you can use script as well provided in this repo

`
## Usage/Examples

### 1) login to the CLI
```shell
az login --use-device-code
```
### 2) set alias
```shell
alias tf=terraform
```
### 3) initialize the providers
```shell
tf init
```
### 4) Run the plan
```shell
tf plan
```
### 5) Apply the changes
```shell
tf apply --auto-approve
```




## Some common Errors

#### Error1:-
``` shell
Error: creating Cluster: (Managed Cluster Name 
"clusternew-aks-cluster" / Resource Group "rgname"): 
containerservice.ManagedClustersClient#CreateOrUpdate: 
Failure sending request: StatusCode=404 -- Original Error: 
Code="ServicePrincipalNotFound" Message="Service principal 
clientID: xxxx-xxxxx-xxxx-xxxxx not found in Active Directory
 tenant xxxx-xxxxx-xxxx-xxxxx, Please see https://aka.ms/
 aks-sp-help for more details."
```
#### Resolution:-
Rerun the tf apply command, this could be a bug in the 
particular provider version. Running the command again 
resolves the issue.


#### Error2:-
``` shell
Error: checking for presence of existing Secret 
"xxxx-xxxxx-xxxx-xxxxx" (Key Vault "https://keyvaultname.
vault.azure.net/"): keyvault.BaseClient#GetSecret: Failure 
responding to request: StatusCode=403 -- Original Error: 
autorest/azure: Service returned an error. Status=403 
Code="Forbidden" Message="Caller is not authorized to perform
 action on resource.\r\nIf role assignments, deny assignments
  or role definitions were changed recently, InnerError=
  {"code":"ForbiddenByRbac"}
  
  on main.tf line 46, in resource "azurerm_key_vault_secret"
   "example":      
  46: resource "azurerm_key_vault_secret" "example" {



``

#### Resolution:-
User should have keyvault admin role even if the user has owner role.

