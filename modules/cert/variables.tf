variable "domain_name" {
  description = "Primary certificate domain name"
  type = string
}

variable "zone_id" {
  description = "Route 53 Zone ID for DNS validation records"
  type = string
}

variable "subject_alternative_names" {
  default = []
  description = "Subject alternative domain names"
  type = list(string)
}