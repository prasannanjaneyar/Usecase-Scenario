variable "location" {
  default = "East US 2"
}

variable "zones" {
  description = "Availability Zones for high availability"
  type        = list(string)
  default     = ["1", "3"]
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Department  = "IT"
    Owner       = "InfraTeam"
    Schedule    = "Yes"
    Backup      = "Yes"
  }
}