terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "ex000" {
  name = "ex000"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "ex000aks"
  location            = data.azurerm_resource_group.ex000.location
  resource_group_name = data.azurerm_resource_group.ex000.name
  dns_prefix          = "ex000aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "example"
  }
}

output "resource_group_name" {
  value = data.azurerm_resource_group.ex000.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}
