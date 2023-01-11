##3we will create subnet
resource "azurerm_subnet" "websubnet" {
  name                 = "example-${var.web_subnet_name}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.web_subnet_address
}

##we will create an nsg --nsg need to be attached with your subnet
resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${var.web_subnet_name}-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

#the top level nsg we will assoicate with subnet
resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
    depends_on = [
      azurerm_network_security_rule.web_nsg_rule_inbound
    ]
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}
locals {
  web_inbound_port = {
  "110":"80",
  "120":"443",
  "130":"22"
  }
}
resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
  for_each = local.web_inbound_port
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "4.246.213.176"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}
