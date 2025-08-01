variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type    = string
  default = "dotnetapp-rg"
}

variable "acr_name" {
  type    = string
  default = "dotnetappacr"
}

variable "aks_name" {
  type    = string
  default = "dotnetapp-aks"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "node_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

# variable "kubernetes_version" {
#   type    = string
#   default = null  # latest if null
# }
