# Local backend: `terraform init` works without creating an S3 bucket first.
# For S3, switch the block to `backend "s3" {}`, add a gitignored `backend.hcl`
# (see backend-s3.hcl.example), then:
#   terraform init -backend-config=backend.hcl -reconfigure
# S3 `region` must match the bucket's real region or you get HTTP 301 errors.

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
