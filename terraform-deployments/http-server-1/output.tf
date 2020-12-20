output "nginx_staging_internal_endpoint" {
  value = module.nginx_staging.internal_endpoint
}
output "nginx_staging_external_endpoint" {
  value = module.nginx_staging.external_endpoint
}

output "nginx_prod_internal_endpoint" {
  value = module.nginx_prod.internal_endpoint
}
output "nginx_prod_external_endpoint" {
  value = module.nginx_prod.external_endpoint
}
