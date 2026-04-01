terraform {
  backend "s3" {
    bucket = "acs730-group3-final-project"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}