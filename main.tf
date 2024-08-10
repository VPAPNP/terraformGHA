terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }


  }
  backend "azurerm" {
    resource_group_name  = "storageStateFile"
    storage_account_name = "taskboardstoragevasil"
    container_name       = "taskboradstoragevasil"
    key                  = "terraform.tfstate"

  }


}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999

}

resource "azurerm_service_plan" "asp" {
  name                = "${var.service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "as" {
  name                = "${var.app_service_name}-${random_integer.ri.result}"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=$;User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "aassc" {


  app_id                 = azurerm_linux_web_app.as.id
  repo_url               = var.repo_url
  branch                 = "main"
  use_manual_integration = true

}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = "${var.sql_server_name}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password



}

resource "azurerm_mssql_database" "database" {

  server_id            = azurerm_mssql_server.sqlserver.id
  name                 = "${var.sql_database_name}${random_integer.ri.result}"
  license_type         = "LicenseIncluded"
  read_scale           = false
  sku_name             = "S0"
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  storage_account_type = "Zone"



}

resource "azurerm_mssql_firewall_rule" "fr" {

  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"




}