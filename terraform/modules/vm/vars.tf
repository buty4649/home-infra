variable "name" {
  type = string
}

variable "target_node" {
  type = string
}

variable "domain" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "memory" {
  type = number
}

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
  type = string
}

variable "pve_verify_ssl" {
  type    = bool
  default = false
}
