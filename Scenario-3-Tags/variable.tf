variable "default_tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Department  = "IT"
    Owner       = "InfraTeam"
    CostCenter  = "CC9999"
    Project     = "TerraformOnboarding"
  }
}
variable "operation_tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Department  = "IT"
    Owner       = "InfraTeam"
    Schedule = "Yes"
    Backup = "Yes"
  }
}