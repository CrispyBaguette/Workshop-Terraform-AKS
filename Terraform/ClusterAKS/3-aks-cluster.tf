
#            _  __ _____    _____ _           _            
#      /\   | |/ // ____|  / ____| |         | |           
#     /  \  | ' /| (___   | |    | |_   _ ___| |_ ___ _ __ 
#    / /\ \ |  <  \___ \  | |    | | | | / __| __/ _ \ '__|
#   / ____ \| . \ ____) | | |____| | |_| \__ \ ||  __/ |   
#  /_/    \_\_|\_\_____/   \_____|_|\__,_|___/\__\___|_|   

# https://patorjk.com/software/taag/#p=display&f=Big&t=AKS%20Cluster                                                       

# More info about azurerm_kubernetes_cluster resource :
# see https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/azurerm/resource_arm_kubernetes_cluster.go
# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster 

resource "azurerm_kubernetes_cluster" "Terra_aks" {
  name                    = var.cluster_name
  location                = var.azure_region
  resource_group_name     = var.resource_group
  dns_prefix              = var.dns_name
  kubernetes_version      = var.kubernetes_version
  sku_tier                = var.sku-controlplane
  private_cluster_enabled = var.enable-privatecluster


  default_node_pool {
    name                = var.defaultpool-name
    node_count          = var.defaultpool-nodecount
    vm_size             = var.defaultpool-vmsize
    os_disk_size_gb     = var.defaultpool-osdisksizegb
    max_pods            = var.defaultpool-maxpods
    availability_zones  = var.defaultpool-availabilityzones
    enable_auto_scaling = var.defaultpool-enableautoscaling
    min_count           = var.defaultpool-mincount
    max_count           = var.defaultpool-maxcount
    vnet_subnet_id      = azurerm_subnet.Terra_aks_subnet.id
  }

  #   linux_profile {
  #     admin_username = var.admin_username
  #     ssh_key {
  #       key_data = data.azurerm_key_vault_secret.ssh_public_key.value
  #     }
  #   }

  network_profile {
    network_plugin = "azure" # Can be kubenet (Basic Network) or azure (=Advanced Network)
    # network_policy     = var.networkpolicy_plugin # Options are calico or azure - only if network plugin is set to azure
    dns_service_ip     = "10.0.0.10" # Required when network plugin is set to azure, must be in the range of service_cidr and above 1
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16" # Must not overlap any address from the VNet
    load_balancer_sku  = "Standard"    # sku can be basic or standard. Here it an AKS cluster with AZ support so Standard SKU is mandatory
  }

  # addon_profile {
  # oms_agent {
  #   enabled = true
  #   log_analytics_workspace_id = azurerm_log_analytics_workspace.Terra-LogsWorkspace.id
  # }

  # Enable HTTP Application routing (Ingress for Test and Dev only)
  # http_application_routing {
  #   enabled = false
  # }

  # Enable Azure Container Instance as a Virtual Kubelet
  # aci_connector_linux {
  #   enabled = true
  #   # https://github.com/terraform-providers/terraform-provider-azurerm/issues/3998
  #   subnet_name = azurerm_subnet.Terra_aks_aci_subnet.name
  # }

  # Enable Azure Policy
  # cf. https://docs.microsoft.com/en-us/azure/governance/policy/concepts/policy-for-kubernetes
  # azure_policy {
  #   enabled = var.enable-AzurePolicy
  # }

  # Enable Azure Application Gateway Ingress Controller
  # ingress_application_gateway {
  #   enabled = true
  #   # gateway_id = ""                       # for Brownfield deployment if you already set up an Application Gateway
  #   gateway_name ="appgw-aks-july21"        # Greenfield deployment, this gateway will be created in cluster resource group.
  #   # subnet_cidr = "10.252.0.0/16"
  #   subnet_id = azurerm_subnet.Terra_aks_appgw_subnet.id
  # }
  # }

  # Enable Kubernetes RBAC 
  role_based_access_control {
    enabled = true # please do NOT set up RBAC to false !!!
  }

  # Managed Identity is mandatory because Kubernetes will provision some Azure Resources like Azure Load Balancer, Public IP, Managed Disks... 
  # You can also use a Service Principal (but it more complicated). One of either identity or service_principal must be specified
  identity {
    type = "SystemAssigned"
  }


  tags = {
    Usage       = "WorkShop IaC"
    Environment = "Azure AKS"
  }
}

