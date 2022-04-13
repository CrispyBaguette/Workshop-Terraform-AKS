#           https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#           https://docs.microsoft.com/en-us/azure/container-registry/container-registry-roles?tabs=azure-cli 
#                  scope                = l'Azure Container Registry
#                  role_definition_name = "ACR Reader"
#                  principal_id         = la system managed identity du cluster AKS


# Récupération info de l'ACR depuis un autre TFState
# https://www.terraform.io/language/state/remote-state-data
data "terraform_remote_state" "Terra-datasource-acr" {
  backend = "azurerm"

  config = {
    resource_group_name  = "RG-AKSCluster"        # mettre ici le nom du resource group de vos ressource
    storage_account_name = "zwpjcfqqyhzvspdqvqaf" # mettre le nom du compte de stockage créer dans le lab 1
    container_name       = "tfstate"
    key                  = "acr.terraform.tfstate"
  }
}

# On donne le role ACR Pull à la User-managed identity du VMScale Set représentant le nodepool (par defaut) sur la registry ACR
resource "azurerm_role_assignment" "Terra-RoleAssigment-defaultnodepool" {
  scope                = data.terraform_remote_state.Terra-datasource-acr.outputs.acr-id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.Terra_aks.kubelet_identity[0].object_id
}

# On donne le role ACR Pull au cluster AKS sur la registry ACR
# cf. https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#containers
# resource "azurerm_role_assignment" "Terra-RoleAssigment" {
#   scope                =  data.terraform_remote_state.Terra-datasource-acr.outputs.acr-id    
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.Terra_aks.identity[0].principal_id
# }


# juste pour vérifier la valeur
# output "acr-id" {
#   value =  data.terraform_remote_state.Terra-datasource-acr.outputs.acr-id
# }

