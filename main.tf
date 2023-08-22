resource "random_string" "rg_suffix" {
  length  = 6
  special = false
}
resource "random_string" "storage_account_suffix" {
  length  = 7
  special = false
  upper = false
}



resource "azurerm_resource_group" "rg" {
  name     = "Abhishek-${random_string.rg_suffix.result}"
  location = "eastus"
}

resource "azurerm_storage_account" "storageacc" {
  name                     = "akashsa${random_string.storage_account_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.actTier
  account_replication_type = var.repplication
  access_tier              = var.accessTier

}

resource "azurerm_storage_container" "my-Container" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.storageacc.name
  container_access_type = var.conAccessTypepipeline
}

resource "azurerm_storage_blob" "file" {
  depends_on = [azurerm_storage_container.my-Container]
  name                   = "file-from-home"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.my-Container.name
  type                   = "Block"
  source                 = var.sourceFile
}

#policy

resource "azurerm_storage_management_policy" "example" {
  storage_account_id ="${azurerm_storage_account.storageacc.id}"


 rule {
    name    = "newrule"
    enabled = true
    filters {
      prefix_match = ["newcontainer/file-from-home"]
      blob_types   = ["blockBlob"]

    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 5
        tier_to_archive_after_days_since_modification_greater_than = 20
        delete_after_days_since_modification_greater_than          = 50
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 25
      }
    }
  }


}




#files

resource "azurerm_storage_share" "fileShare" {
  name                 = "storagefile"
  storage_account_name = azurerm_storage_account.storageacc.name
  quota                = "1024"
  enabled_protocol     = "SMB"
}

# #queue

# resource "azurerm_storage_queue" "tfQueue" {
#   name                 = "storagequeue"
#   storage_account_name = azurerm_storage_account.storageacc.name
  
# }

# #Table

# resource "azurerm_storage_table" "azureTable" {
#   name                 = "nosqltable"
#   storage_account_name = azurerm_storage_account.storageacc.name
# }







