# Terraform infrastructure

This directory defines AWS infrastructure for the platform using **root stacks per environment** (`dev`, `prod`) and **reusable modules** for networking, identity, Kubernetes, registry, and observability.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) **>= 1.5.0** (see `versions.tf`)
- An AWS account and credentials (environment variables, shared credentials file, or IAM role)
- Permissions to create VPC, IAM roles, EKS, ECR, and CloudWatch resources used by the modules

## Repository layout

| Path | Purpose |
|------|---------|
| `versions.tf` | Terraform version constraint for the whole tree |
| `modules/vpc/` | VPC, subnets, routing, and related networking outputs |
| `modules/iam/` | IAM roles for the EKS control plane and worker nodes |
| `modules/eks/` | EKS cluster and managed node group(s) |
| `modules/ecr/` | ECR repository for container images |
| `modules/monitoring/` | Monitoring and alerting (wired to cluster / project inputs) |
| `environments/dev/` | **Development** stack: wires modules with dev `terraform.tfvars` |
| `environments/prod/` | **Production** stack: same pattern with prod values |

Environment folders are the only places you should run `terraform init`, `plan`, and `apply` for deployments. Each environment has its own state file when using the default **local** backend.

## What each environment provisions

Both `dev` and `prod` compose the same modules in dependency order:

1. **VPC** — network foundation; subnets are passed into EKS.
2. **IAM** — cluster and node IAM roles; ARNs are passed into EKS.
3. **EKS** — cluster and node group using the VPC subnets and IAM roles.
4. **ECR** — image repository tagged for the project.
5. **Monitoring** — observability and alerts (uses cluster name and optional alert email from variables).

Inputs such as CIDRs, AZs, instance sizes, and tags are supplied via `variables.tf` + `terraform.tfvars` in each environment directory.

## Usage

Pick an environment directory, then run Terraform from that directory only.

### Development

```powershell
cd environments\dev
terraform init
terraform validate
terraform plan
terraform apply
```

### Production

```powershell
cd environments\prod
terraform init
terraform validate
terraform plan
terraform apply
```

Format all `.tf` files under `terraform/` (optional):

```powershell
cd environments\dev
terraform fmt -recursive ..\..
```


## State backend

By default each environment uses a **local** backend (`backend.tf`), so state is stored as `terraform.tfstate` inside that environment folder. No S3 bucket is required for local development.

### Moving to S3 remote state

1. Create an S3 bucket (and optional locking setup per your org standards) in the **same AWS region** you will set in the backend config. The S3 backend `region` must match the bucket’s region or initialization can fail with HTTP **301** redirects.
2. Copy `backend-s3.hcl.example` to `backend.hcl` in the same environment folder, edit bucket name, state key, and region. `backend.hcl` is listed in the repo root `.gitignore` so secrets and account-specific values are not committed.
3. In `backend.tf`, replace the `backend "local"` block with an empty S3 backend:

   ```hcl
   terraform {
     backend "s3" {}
   }
   ```

4. Reinitialize and migrate state if you already have a local state file:

   ```powershell
   terraform init -backend-config=backend.hcl -migrate-state
   ```

## Configuration reference

| File (per environment) | Role |
|----------------------|------|
| `main.tf` | Module composition and wiring |
| `variables.tf` | Variable declarations |
| `terraform.tfvars` | Environment-specific values (review before apply) |
| `providers.tf` | AWS provider; region comes from `var.aws_region` |
| `outputs.tf` | Exported values for operators or downstream tooling |
| `backend.tf` | State backend configuration |

## Important notes

- **Never commit** real `terraform.tfstate`, `.terraform/`, or sensitive `*.tfvars` if they contain secrets. The project `.gitignore` already excludes common Terraform and secret patterns.
- **Prod vs dev**: use separate state (separate directories or separate S3 keys) so production is not overwritten by development applies.
- After changing **backend** configuration, run `terraform init -reconfigure` (and use `-migrate-state` when moving from local to S3).

For the wider repository (Helm, app, CI), see the root `README.md` in the project.
