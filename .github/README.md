# GitHub configuration

## Workflows

| File | When it runs | What it does |
|------|----------------|---------------|
| [workflows/terraform-validate.yml](workflows/terraform-validate.yml) | Push/PR touching `terraform/**` or the workflow file; manual | Terraform `init -backend=false`, `fmt -check`, `validate` for **dev** and **prod**. |
| [workflows/helm-lint.yml](workflows/helm-lint.yml) | Push/PR touching `helm-chart/**` or the workflow; manual | Installs Helm and runs `helm lint` with `values-dev.yaml` and `values-prod.yaml`. |
| [workflows/deploy.yml](workflows/deploy.yml) | Push to `main` or manual | AWS auth, ECR login, Docker build/push for `app`, `aws eks update-kubeconfig`, `helm upgrade --install` (dev-oriented env vars in the file). |

## Deploy secrets

For [deploy.yml](workflows/deploy.yml), configure repository **Secrets**:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Prefer **OIDC** with `aws-actions/configure-aws-credentials` for production instead of long-lived keys.

Adjust workflow `env` (region, ECR repo name, EKS cluster name) to match your Terraform outputs.
