variable "pve_host" {
  type = string
}

variable "pve_user" {
  type = string
}

variable "pve_api_token_name" {
  type = string
}

variable "pve_api_token_secret" {
  type      = string
  sensitive = true
}

variable "pve_tls_insecure" {
  type    = bool
  default = true
}
