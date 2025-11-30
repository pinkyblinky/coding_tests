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

output "resource_group_name" {
  value = data.azurerm_resource_group.ex000.name
}
