# Terraform EKS Helm Platform

End-to-end **infrastructure and delivery** layout for AWS: **Terraform** (VPC, IAM, EKS, ECR, monitoring), a sample **container app**, **Helm** packaging for Kubernetes, and **GitHub Actions** for validate, lint, and deploy.

## Repository layout

```text
terraform-eks-helm-platform/
├── terraform/                 # AWS infra (modules + per-env stacks)
│   ├── versions.tf
│   ├── README.md
│   ├── modules/
│   │   ├── vpc/
│   │   ├── iam/
│   │   ├── eks/
│   │   ├── ecr/
│   │   └── monitoring/
│   └── environments/
│       ├── dev/
│       └── prod/
├── app/                       # Sample workload (Docker / Python or Node)
│   ├── Dockerfile
│   ├── README.md
│   ├── requirements.txt
│   ├── app.py
│   ├── server.js
│   └── install-requirements.ps1
├── helm-chart/                # Kubernetes chart (dev / prod values)
│   ├── Chart.yaml
│   ├── values-dev.yaml
│   ├── values-prod.yaml
│   ├── README.md
│   └── templates/
├── scripts/                   # Local tooling (e.g. Helm install on Windows)
│   └── README.md
├── docs/                      # Architecture and runbooks (optional)
│   └── README.md
├── .github/workflows/         # CI/CD
│   ├── terraform-validate.yml
│   ├── helm-lint.yml
│   └── deploy.yml
└── README.md                  # This file
```

## Infrastructure components

| Area | Role | Detailed docs |
|------|------|----------------|
| **Terraform** | Provisions VPC, IAM for EKS, EKS cluster and node groups, ECR, monitoring; split **dev** / **prod** under `terraform/environments/`. | [terraform/README.md](terraform/README.md) |
| **App** | Sample HTTP API for Docker builds and Helm `image` values; Python (Flask) or Node for local run. | [app/README.md](app/README.md) |
| **Helm** | Deployment, Service, Ingress, HPA, ServiceAccount; `values-dev.yaml` vs `values-prod.yaml`. | [helm-chart/README.md](helm-chart/README.md) |
| **CI** | Terraform fmt/validate (dev + prod), Helm lint, optional deploy (build/push to ECR, `helm upgrade`). | [.github/workflows/](.github/workflows/) |
| **Scripts** | Portable Helm install for Windows under `.tools/helm/` (gitignored). | [scripts/README.md](scripts/README.md) |
| **Docs** | High-level architecture and deployment flow notes. | [docs/README.md](docs/README.md) |

## Prerequisites

- **AWS account** and credentials for Terraform and (if used) GitHub deploy.
- **Terraform** >= 1.5 (see `terraform/versions.tf`).
- **kubectl** / **Helm** when deploying to EKS (see `helm-chart/README.md` and `scripts/install-helm.ps1` on Windows).
- **Docker** for building the app image locally or in CI.

## Quick start

### 1. Provision AWS (example: dev)

```powershell
cd terraform\environments\dev
terraform init
terraform plan
terraform apply
```

Use `terraform\environments\prod` for production. Backend and variables are described in [terraform/README.md](terraform/README.md).

### 2. Build and run the app locally

```powershell
cd app
docker build -t platform-app .
```

Or run without Docker: see [app/README.md](app/README.md) (Node or Python).

### 3. Helm (lint / dry-run)

```powershell
.\scripts\install-helm.ps1
$env:PATH = "$(Resolve-Path .\.tools\helm\windows-amd64);$env:PATH"
helm lint .\helm-chart -f .\helm-chart\values-dev.yaml
```

### 4. GitHub Actions

| Workflow | Purpose |
|----------|---------|
| [terraform-validate.yml](.github/workflows/terraform-validate.yml) | `terraform init -backend=false`, `fmt -check`, `validate` for **dev** and **prod**. |
| [helm-lint.yml](.github/workflows/helm-lint.yml) | `helm lint` with dev and prod values. |
| [deploy.yml](.github/workflows/deploy.yml) | On `push` to `main` (or manual): configure AWS, ECR login, **build/push** `app` image, **helm upgrade** to the dev cluster (requires secrets and matching resource names). |

**Deploy workflow secrets:** configure `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` (or switch the workflow to OIDC). Align `AWS_REGION`, `ECR_REPOSITORY`, and EKS cluster name with your Terraform outputs.

## Naming and environments

- Keep **dev** and **prod** **state and values separate** (different `terraform/environments/*` directories and different Helm value files).
- After Terraform creates ECR and EKS, update **Helm** `image.repository` / **CI** env vars so pushes and `helm upgrade` target the correct registry and cluster.

## License / ownership

Use and adapt this scaffold under your organization’s policies; replace example names, regions, and domains before production use.
