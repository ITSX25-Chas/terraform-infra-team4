terraform {
  backend "gcs" {
    bucket = "itsx25-comerit-team4-tfstate" # förberedd av Comerit
    prefix = "terraform/state"
  }
}
