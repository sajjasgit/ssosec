output "acr_repo_url" {
  value = module.azure-deploy.acr_repo_url
}

output "azure_vm_public_ip" {
  value = module.azure-deploy.azure_vm_publicip
}

output "azure_vm_private_key" {
  value = tls_private_key.this.private_key_pem
}