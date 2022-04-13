
variable "azure_region" {
  description = "Azure Region where to deploy resources. Caution the region must support Availability Zone"
  # To get names of Azure Region : az account list-locations
  # To check support of Availability Zone in the Azure Region see https://docs.microsoft.com/bs-latn-ba/azure/availability-zones/az-overview
  type    = string
  default = "westeurope"
}

#  Resource Group Name
variable "resource_group" {
  type    = string
  default = "RG-AKSCluster"
}

# Virtual Network name
variable "aks_vnet_name" {
  type    = string
  default = "aksvnet"
}


# AKS Cluster name
variable "cluster_name" {
  type    = string
  default = "AKS-000"
}

#AKS DNS name
variable "dns_name" {
  type    = string
  default = "aks0000"
}

# sku of Azure managed K8S control plane
# Free = no SLA, SLO 99.5, Paid = SLA 99.95 with AS, 99.99 with AZ
variable "sku-controlplane" {
  type    = string
  default = "Free"
}

# Supported values are calico or azure
variable "networkpolicy_plugin" {
  type    = string
  default = "azure"
}

variable "enable-privatecluster" {
  type    = bool
  default = false
}

variable "enable-AzurePolicy" {
  type    = bool
  default = false
}

# supported values are : patch, rapid, stable
variable "automatic-channel-upgrade" {
  type    = string
  default = "patch"
}

# Linux nodes admin user name
variable "admin_username" {
  type    = string
  default = "aksadmin"
}


# Specify a valid kubernetes version
# Check before that the version is still available to deploy in Azure with the following command :
# az aks get-versions --location=nameofAzureRegion
variable "kubernetes_version" {
  description = "Version of Kubernetes to deploy"
  type        = string
  default     = "1.22.6"
}


#Default Agent Pool

variable "defaultpool-name" {
  description = "Name of cluster default linux nodepool"
  type        = string
  default     = "pool1"
}

variable "defaultpool-nodecount" {
  description = "Number of node in a static AKS cluster or initial number if autoscaling. between 1 to 100"
  type        = number
  default     = "1"
}

variable "defaultpool-vmsize" {
  description = "Size of VM"
  # check if the choosen size is available in Azure region you selected : az vm list-usage --location NAMEOFAZUREREGION -o table
  type    = string
  default = "standard_d2as_v5"
}

variable "defaultpool-ostype" {
  description = "can be linux or windows except for first system pool that must be linux"
  type        = string
  default     = "linux"
}

variable "defaultpool-osdisksizegb" {
  description = "Size in GB of node OS disk"
  type        = number
  default     = "32"
}

variable "defaultpool-type" {
  description = "Possible values are AvailabilitySet and VirtualMachineScaleSets"
  type        = string
  default     = "VirtualMachineScaleSets"
}

variable "defaultpool-maxpods" {
  description = "number max of pods per node. can be between 30 to 250 on Advanced Network deployment"
  type        = number
  default     = "100"
}

variable "defaultpool-availabilityzones" {
  description = "availability zones of the region" # example : [1, 2, 3]"
  type        = list(number)
  default     = [1, 2, 3]
}

variable "defaultpool-enableautoscaling" {
  description = "use this parameter if you want an AKS Cluster with Nodes autoscaling."
  # Need also min_count and max_count parameters
  type    = bool
  default = true
}

variable "defaultpool-mincount" {
  description = "number min of nodes in pool. can be between 1 to 99"
  type        = number
  default     = "1"
}

variable "defaultpool-maxcount" {
  description = "number max of nodes in pool. can be between 2 to 99"
  type        = number
  default     = "3"
}

variable "defaultpool-securitypolicy" {
  type    = bool
  default = false
}


#KeyVault Resource Group and KeyVaultName
# variable "keyvault_rg" {
#   type = string
# }
# variable "keyvault_name" {
#   type = string
# }
