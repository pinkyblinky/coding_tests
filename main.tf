terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.example.kube_config.0.host
  client_key             = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_key)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.example.kube_config.0.host
    client_key             = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)
  }
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

resource "helm_release" "airbyte" {
  name             = "airbyte"
  repository       = "https://airbytehq.github.io/helm-charts"
  chart            = "airbyte"
  namespace        = "airbyte"
  create_namespace = true

  depends_on = [azurerm_kubernetes_cluster.example]

  values = [
    yamlencode({
      global = {
        hostUrl = "http://airbyte.local"
      }
    })
  ]
}

resource "kubernetes_manifest" "pvc" {
  manifest = yamldecode(file("pvc.yaml"))

  depends_on = [azurerm_kubernetes_cluster.example]
}

resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(file("deployment.yaml"))

  depends_on = [kubernetes_manifest.pvc]
}

output "resource_group_name" {
  value = data.azurerm_resource_group.ex000.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}
