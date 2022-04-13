variable "azureRegion" {
  description = "Azure Region where to deploy resources. Caution the region must support Availability Zone"
  # To get names of Azure Region : az account list-locations
  # To check support of Availability Zone in the Azure Region see https://docs.microsoft.com/bs-latn-ba/azure/availability-zones/az-overview
  type    = string
  default = "westeurope"
}

#  Resource Group Name
variable "resourceGroupName" {
  type    = string
  default = "RG-AKSCluster"
}

#  Azure Container Registry name
variable "acrName" {
  type    = string
  default = "acrbvqoqqkqxk" # IMPORTANT : changer ce nom et mettre un nom unique (cf. https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-storage)
}
