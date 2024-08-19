data "http" "myip" {
  url = "http://ip.iol.cz/ip/"
}

output "myip" {
  value = data.http.myip.response_body
}