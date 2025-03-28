data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

data "http" "ipinfo" {
  url = "https://ipinfo.io"
}