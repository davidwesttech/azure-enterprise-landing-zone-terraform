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