terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "=2.6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "project-core-3"
    storage_account_name = "project3terraform"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
    subscription_id      = "8c357924-1e74-xxxx-xxxx-0c87bb5f9b04"
    tenant_id            = "e739050c-2dcf-xxxx-xxxx-06577c01ba89"
  }
}

module "dev" {
  source                = "../modules"
  stage                 = "dev"
  address_space         = ["172.40.0.0/16"]
  address_prefixes_aks  = "172.40.0.0/22"
  dns_a_record_frontend = "project-core3-dev-survey"
  dns_a_record_backend  = "project-core3-dev-services"
  dns_a_record_composer = "project-core3-dev-composer"
  dns_a_record_auth     = "project-core3-dev-auth"
}
