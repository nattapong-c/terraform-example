resource "azurerm_kubernetes_cluster" "k8s" {
  name       = local.name
  location   = data.azurerm_resource_group.rg.location
  dns_prefix = "project-core-3-dns"


  resource_group_name = data.azurerm_resource_group.rg.name
  tags = {
    "project" = local.project
    "product" = local.tag_product
    "platform" = local.tag_platform
    "module"  = local.tag_module
    "owner"   = local.tag_owner
    "stage"   = var.stage
  }

  http_application_routing_enabled = false

  linux_profile {
    admin_username = var.vm_user_name

    ssh_key {
      key_data = file(var.public_ssh_key_path)
    }
  }

  default_node_pool {
    name                = "agentpool"
    node_count          = var.node_count
    min_count           = var.min_count
    max_count           = var.max_count
    enable_auto_scaling = true
    zones               = ["1", "2", "3"]
    max_pods            = var.max_pods
    vm_size             = var.vm_size
    vnet_subnet_id      = azurerm_subnet.kubesubnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_virtual_network.network]
}

resource "azurerm_role_assignment" "ra1" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.aks-enterprise-application.id
}

resource "azurerm_role_assignment" "ra2" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = data.azuread_service_principal.ad.object_id
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "cm" {
  name             = "cm"
  namespace        = kubernetes_namespace.cert_manager.metadata.0.name
  create_namespace = false
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = "v1.8.2"
  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}

resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = kubernetes_namespace.traefik.metadata.0.name
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"

  set {
    name  = "service.spec.loadBalancerIP"
    value = azurerm_public_ip.network.ip_address
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = data.azurerm_resource_group.rg.name
  }

  depends_on = [
    kubernetes_namespace.traefik
  ]
}
