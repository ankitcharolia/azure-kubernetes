resource "azurerm_resource_group" "this" {
  name     = "rg-vnet-${var.environment}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "kube_subnet" {
  name                 = "snet-01"
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "snet-02"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.this.name
}

# Create public IP
resource "azurerm_public_ip" "this" {
  count               = var.azure_nat_address_count
  name                = "${var.environment}-nat-ip-${count.index}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard" # default when allocated_method is Static
}

# Nat Gateway
resource "azurerm_nat_gateway" "this" {
  name                    = "${var.environment}-nat-gateway"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = var.vnet_availability_zones
}

# Nat - Public IP Association
resource "azurerm_nat_gateway_public_ip_association" "this" {
  count                = var.azure_nat_address_count
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.this[count.index].id
}

# NAT - Subnets association
resource "azurerm_subnet_nat_gateway_association" "kube" {
  subnet_id      = azurerm_subnet.kube_subnet.id
  nat_gateway_id = azurerm_nat_gateway.this.id

  depends_on = [
    azurerm_nat_gateway_public_ip_association.this
  ]
}

resource "azurerm_subnet_nat_gateway_association" "vm" {
  subnet_id      = azurerm_subnet.vm_subnet.id
  nat_gateway_id = azurerm_nat_gateway.this.id

  depends_on = [
    azurerm_nat_gateway_public_ip_association.this
  ]
}

