variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string

}

variable "resource_group_location" {
  description = "The location/region where the resources will be created."
  type        = string
}

variable "app_service_name" {
  description = "The name of the App Service."
  type        = string

}

variable "service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string

}

variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string

}

variable "sql_database_name" {
  description = "The name of the SQL Database."
  type        = string

}

variable "sql_admin_login" {
  description = "The username of the SQL Server administrator."
  type        = string

}

variable "sql_admin_password" {
  description = "The password of the SQL Server administrator."
  type        = string

}

variable "repo_url" {
  description = "The URL of the repository to deploy the app from."
  type        = string

}

variable "firewall_rule_name" {
  description = "The name of the firewall rule."
  type        = string

}