# Service Principal
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
# Admin Account (For Key Vault Access Policy)
variable "admin_id" {}
# Lab Variables
variable "labname" {
  type        = string
  description = "Name for the Lab Environment"
  default = "AzureLabServices"
}
variable "region" {
  type        = string
  description = "Region 1 Location for this environment"
  default = "uksouth"
}
variable "labusername" {
  type        = string
  description = "Username for the Lab Machine Account"
  default = "labuser"
}