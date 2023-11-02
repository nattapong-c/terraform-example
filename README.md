If install traefik timeout, try to apply again

```
terraform apply -target=helm_release.traefik
```

or

```
terraform apply -target=module.dev.azurerm_dns_a_record.network_auth
```
