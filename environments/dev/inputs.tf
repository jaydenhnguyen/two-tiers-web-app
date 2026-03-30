variable "project_name" {
  description = "Project or group name used in resource names"
  type        = string
}

variable "team_name" {
  description = "Team name shown on the webpage"
  type        = string
}

variable "team_members" {
  description = "Team members shown on the webpage"
  type        = list(string)
}

variable "additional_tags" {
  description = "Additional tags applied to tag-aware resources"
  type        = map(string)
}
