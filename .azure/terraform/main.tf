resource "azurerm_resource_group" "res-0" {
  location = var.location
  name     = "rg-${var.app_name}"
}
resource "azurerm_log_analytics_workspace" "res-1" {
  location            = azurerm_resource_group.res-0.location
  name                = "log-${var.app_name}"
  resource_group_name = azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_service_plan" "res-512" {
  location            = azurerm_resource_group.res-0.location
  name                = "plan-${var.app_name}"
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.res-0.name
  sku_name            = "B1"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_linux_web_app" "res-513" {
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insights.res-521.instrumentation_key
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
    APPLICATIONINSIGHTS_CONNECTION_STRING           = azurerm_application_insights.res-521.connection_string
    APPLICATIONINSIGHTS_ENABLESQLQUERYCOLLECTION    = "true"
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~3"
    DISABLE_APPINSIGHTS_SDK                         = "disabled"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    IGNORE_APPINSIGHTS_SDK                          = "disabled"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
  }
  client_affinity_enabled = true
  location                = azurerm_resource_group.res-0.location
  name                    = "web-${var.app_name}"
  resource_group_name     = azurerm_resource_group.res-0.name
  service_plan_id         = azurerm_service_plan.res-512.id
  site_config {
    always_on  = false
    ftps_state = "FtpsOnly"
    application_stack {
      dotnet_version = "6.0"
    }
  }
  sticky_settings {
    app_setting_names = ["APPINSIGHTS_INSTRUMENTATIONKEY", "APPLICATIONINSIGHTS_CONNECTION_STRING ", "APPINSIGHTS_PROFILERFEATURE_VERSION", "APPINSIGHTS_SNAPSHOTFEATURE_VERSION", "ApplicationInsightsAgent_EXTENSION_VERSION", "XDT_MicrosoftApplicationInsights_BaseExtensions", "DiagnosticServices_EXTENSION_VERSION", "InstrumentationEngine_EXTENSION_VERSION", "SnapshotDebugger_EXTENSION_VERSION", "XDT_MicrosoftApplicationInsights_Mode", "XDT_MicrosoftApplicationInsights_PreemptSdk", "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT", "XDT_MicrosoftApplicationInsightsJava", "XDT_MicrosoftApplicationInsights_NodeJS"]
  }
  depends_on = [
    azurerm_service_plan.res-512,
  ]
}
resource "azurerm_application_insights" "res-521" {
  application_type    = "web"
  location            = azurerm_resource_group.res-0.location
  name                = "ai-${var.app_name}"
  resource_group_name = azurerm_resource_group.res-0.name
  sampling_percentage = 0
  workspace_id        = azurerm_log_analytics_workspace.res-1.id
  depends_on = [
    azurerm_log_analytics_workspace.res-1,
  ]
}
