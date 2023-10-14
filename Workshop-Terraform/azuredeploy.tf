# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}"
  location = var.region
}
# VNET
resource "azurerm_virtual_network" "vn" {

  name                = "vnet-${var.name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]
  dns_servers         = [var.dns]
}
# Subnet
resource "azurerm_subnet" "region1-vnet1-snet1" {

  name                 = "vnet-${var.name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = [var.subnet_cidr]
}
# VNET peering
resource "azurerm_virtual_network_peering" "lab-to-hub" {

  name                      = "${var.name}-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vn.name
  remote_virtual_network_id = var.hub_vnetid
}

resource "azurerm_virtual_network_peering" "hub-to-lab" {

  name                      = "hub-to-${var.name}"
  resource_group_name       = var.hub_rg
  virtual_network_name      = var.hub_vnetname
  remote_virtual_network_id = azurerm_virtual_network.vn.id
}
# Host Pool
resource "azurerm_virtual_desktop_host_pool" "hp" {

  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  name                     = "hp-${var.name}"
  friendly_name            = "hp-${var.name}"
  validate_environment     = false
  start_vm_on_connect      = false
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "1 to many Host Pool"
  type                     = "Pooled"
  maximum_sessions_allowed = 50
  load_balancer_type       = "DepthFirst"
}
# App Groups
resource "azurerm_virtual_desktop_application_group" "ag" {

  name                         = "ag-${var.name}"
  location                     = var.region
  resource_group_name          = azurerm_resource_group.rg.name
  type                         = "Desktop"
  host_pool_id                 = azurerm_virtual_desktop_host_pool.hp.id
  friendly_name                = "ag-${var.name}-${var.name}"
  description                  = "Multi User Desktop Session"
  default_desktop_display_name = "${var.name} - SCS Lab Test Desktop"
}
# Workspaces 
resource "azurerm_virtual_desktop_workspace" "ws" {

  name                = "ws-${var.name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  friendly_name = "ws-${var.name}"
  description   = "Demo AVD Workspace"
}
# App Group to Workspace Assignment
resource "azurerm_virtual_desktop_workspace_application_group_association" "assignment" {

  workspace_id         = azurerm_virtual_desktop_workspace.ws.id
  application_group_id = azurerm_virtual_desktop_application_group.ag.id
}