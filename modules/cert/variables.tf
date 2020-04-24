variable "aws_region" {
  description = "Used AWS Region."
  type = string
}

variable "allow_validation_record_overwrite" {
  default = true
  description = "Allow Route 53 record creation to overwrite existing records"
  type = bool
}

variable "domain_name" {
  description = "Primary certificate domain name"
  type = string
}

variable "hosted_zone_id" {
  description = "Route 53 Zone ID for DNS validation records"
  type = string
}

variable "subject_alternative_names" {
  default = []
  description = "Subject alternative domain names"
  type = list(string)
}

variable "validation_record_ttl" {
  default = 60
  description = "Route 53 time-to-live for validation records"
  type = number
}

variable "tags" {
  default = {}
  description = "Extra tags to attach to the ACM certificate"
  type = map(string)
}