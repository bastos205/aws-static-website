variable "project_id" {
  type        = string
  description = "project id - must be unique"
}

variable "stack" {
  type        = string
  description = "environment index (t,q,p)"
}

variable "domain_name" {
  type        = string
  description = "domain name for the static website"
}

variable "tags" {
  type = map(string)
}

variable "sns_subscriber_email" {
  type = string
}
