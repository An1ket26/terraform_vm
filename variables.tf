variable "resource_group_name" {
  type    = string
  default = "rg1"
}
variable "resource_grp_location" {
  type    = string
  default = "eastUS"
}
variable "frontend_vm_name" {
  type    = string
  default = "vmfrontend"
}
variable "backend_vm_name" {
  type    = string
  default = "vmbackend"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "vnet_name" {
  type    = string
  default = "vnet1"
}
variable "app_gateway_name" {
  type    = string
  default = "appgateway"
}