# Local backend by default. For S3, use partial config — see backend-s3.hcl.example.

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
