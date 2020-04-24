data "http" "discover-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  accessing_computer_ip = chomp(data.http.discover-external-ip.body)
}