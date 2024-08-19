locals {
  reader_creds = jsonencode(
    {
      tenant_id : local.spfile.sp.tenant_id,
      subscription_id : local.spfile.sp.subscription_id,
      client_id : azuread_application.cgns-reader.application_id,
      client_secret : azuread_application_password.cgns-reader-key.value
    }
  )
}

resource "local_file" "reader_creds" {

  content  = local.reader_creds
  filename = "${path.module}/../reader.json"
}

output "file" {
  value = "${path.module}/../reader.json"
}