terraform {
  backend "s3" {
    bucket = "acs730-group3-final-project"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
