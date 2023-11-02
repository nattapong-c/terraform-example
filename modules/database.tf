resource "azurerm_cosmosdb_account" "db" {
  name                 = local.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  offer_type           = "Standard"
  kind                 = "MongoDB"
  location             = data.azurerm_resource_group.rg.location
  mongo_server_version = "4.0"

  tags = {
    "project" = local.project
    "product" = local.tag_product
    "platform" = local.tag_platform
    "module"  = local.tag_module
    "owner"   = local.tag_owner
    "stage"   = var.stage
  }

  geo_location {
    location          = data.azurerm_resource_group.rg.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  capabilities {
    name = "EnableMongo"
  }

  capabilities {
    name = "EnableServerless"
  }

  capabilities {
    name = "DisableRateLimitingResponses"
  }

  backup {
    type = "Continuous"
  }
}
