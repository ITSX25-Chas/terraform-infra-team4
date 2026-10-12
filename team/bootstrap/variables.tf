variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "team_id" {
  description = "The team ID"
  type        = number
}

variable "team_members" {
  description = "Chas Academy-mailadresser för lagmedlemmar med läsrätt till Terraform state"
  type        = list(string)
}

variable "github_repository_id" {
  description = "Numeriskt id för GitHub-repot som får autentisera via WIF (gh api repos/OWNER/REPO --jq .id)"
  type        = string
}
