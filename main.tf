terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  resource_providers_to_register = [
    "Microsoft.Storage"
  ]

  features {}
}

data "azurerm_resource_group" "medusa_dev" {
  name = "rg-medusa-dev"
}

data "azurerm_client_config" "current" {}

locals {
  storage_account_name = "stmedusadev${substr(replace(data.azurerm_client_config.current.subscription_id, "-", ""), 0, 8)}"
}

resource "azurerm_storage_account" "medusa_dev" {
  name                     = local.storage_account_name
  resource_group_name      = data.azurerm_resource_group.medusa_dev.name
  location                 = data.azurerm_resource_group.medusa_dev.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "dev"
    project     = "medusa"
  }
}


