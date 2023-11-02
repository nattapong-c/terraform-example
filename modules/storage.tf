resource "azurerm_storage_account" "upload" {
  name                     = local.name_storage_upload
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    "project" = local.project
    "product" = local.tag_product
    "platform" = local.tag_platform
    "module"  = local.tag_module
    "owner"   = local.tag_owner
    "stage"   = var.stage
  }
}

resource "azurerm_storage_container" "upload" {
  name                  = "core-3"
  storage_account_name  = azurerm_storage_account.upload.name
  container_access_type = "container"
}

resource "azurerm_storage_account" "configuration" {
  name                     = local.name_storage_config
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    "project" = local.project
    "product" = local.tag_product
    "platform" = local.tag_platform
    "module"  = local.tag_module
    "owner"   = local.tag_owner
    "stage"   = var.stage
  }
}

resource "azurerm_storage_container" "configuration" {
  name                  = "core-3"
  storage_account_name  = azurerm_storage_account.configuration.name
  container_access_type = "private"
}
