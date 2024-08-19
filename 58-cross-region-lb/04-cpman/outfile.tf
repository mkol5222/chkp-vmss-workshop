locals {
    outfile = jsonencode(
        {
            a: 20
            cpman_ip: module.cpman
        }
    )
}

resource "local_file" "reader_creds" {

  content  = local.outfile
  filename = "${path.module}/../cpman.json"
}

output "file" {
    value = "${path.module}/../cpman.json"
}