variable "stage" {
  default = "dev"
  type    = string
}

variable "vm_size" {
  default = "Standard_B2s"
  type    = string
}

variable "node_count" {
  default = 1
  type    = number
}

variable "min_count" {
  default = 1
  type    = number
}

variable "max_count" {
  default = 3
  type    = number
}

variable "max_pods" {
  default = 250
  type    = number
}

variable "address_space" {
  default = ["172.22.0.0/16"]
  type    = list(string)
}

variable "address_prefixes_aks" {
  default = "172.22.0.0/22"
  type    = string
}

variable "public_ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
  type    = string
}

variable "vm_user_name" {
  default = "vmuser1"
  type    = string
}

variable "dns_a_record_frontend" {
  default = "project-dev"
  type    = string
}

variable "dns_a_record_backend" {
  default = "project-dev-services"
  type    = string
}

variable "dns_a_record_composer" {
  default = "project-dev-app"
  type    = string
}
variable "dns_a_record_auth" {
  default = "project-dev-auth"
  type    = string
}
locals {
  resource_group_name   = "project-core-3"
  project               = "project-core-3"
  base_name             = "project-core3"
  name                  = "${local.base_name}-${var.stage}"
  name_network          = "${local.base_name}-network-${var.stage}"
  name_identity         = "${local.base_name}-identity-${var.stage}"
  name_network_security = "${local.base_name}-network-sec-${var.stage}"
  name_storage_upload   = "pcore3upload${var.stage}"
  name_storage_config   = "pcore3config${var.stage}"
  name_registry         = "projectcore3"
  location              = "Southeast Asia"
  subnet_kube           = "kubesubnet"
  domain                = "example.net"
  tag_product           = "project"
  tag_platform          = "core3"
  tag_module            = "survey-engine"
  tag_owner             = "project-core-3-team"
}

data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}

data "azurerm_dns_zone" "network" {
  name                = local.domain
  resource_group_name = local.resource_group_name
}

data "azuread_service_principal" "aks-enterprise-application" {
  display_name = azurerm_kubernetes_cluster.k8s.name
  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}

data "azurerm_container_registry" "acr" {
  name                = local.name_registry
  resource_group_name = data.azurerm_resource_group.rg.name
}


data "azuread_service_principal" "ad" {
  application_id = "0e65293a-20c5-4ca4-a96d-98f7d53bb9c8"
}
