module "logging" {
  source = "../../modules/logging"

  location                     = var.location
  environment                  = var.environment
  resource_group_name          = "rg-platform-management-${var.environment}"
  log_analytics_workspace_name = "law-lz-${var.environment}"
  retention_in_days            = 30

  tags = {
    environment = var.environment
    workload    = "platform-management"
    project     = "azure-landing-zone"
    owner       = "DavidWest"
  }
}

module "hub_network" {
  source = "../../modules/hub_network"

  location                        = var.location
  environment                     = var.environment
  resource_group_name             = "rg-platform-connectivity-${var.environment}"
  vnet_name                       = "vnet-hub-${var.environment}"
  vnet_address_space              = ["10.0.0.0/16"]
  shared_services_subnet_name     = "snet-shared-services"
  shared_services_subnet_prefixes = ["10.0.1.0/24"]
  firewall_subnet_prefixes        = ["10.0.2.0/24"]
  gateway_subnet_prefixes         = ["10.0.3.0/24"]

  tags = {
    environment = var.environment
    workload    = "platform-connectivity"
    project     = "azure-landing-zone"
    owner       = "DavidWest"
  }
}

module "spoke_network" {
  source = "../../modules/spoke_network"

  location                          = var.location
  environment                       = var.environment
  resource_group_name               = "rg-workload-${var.environment}"
  vnet_name                         = "vnet-spoke-${var.environment}"
  vnet_address_space                = ["10.1.0.0/16"]
  app_subnet_name                   = "snet-app"
  app_subnet_prefixes               = ["10.1.1.0/24"]
  private_endpoints_subnet_name     = "snet-private-endpoints"
  private_endpoints_subnet_prefixes = ["10.1.2.0/24"]

  tags = {
    environment = var.environment
    workload    = "application"
    project     = "azure-landing-zone"
    owner       = "DavidWest"
  }
}