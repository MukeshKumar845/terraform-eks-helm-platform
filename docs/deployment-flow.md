# Deployment flow

1. **Infrastructure:** Apply Terraform from `terraform/environments/<env>` so VPC, EKS, ECR, and related resources exist.
2. **Image:** Build the `app` Docker image and push it to the ECR repository Terraform created (manually, or via `deploy.yml`).
3. **Kubernetes:** Run `helm upgrade --install` with `values-dev.yaml` or `values-prod.yaml`, setting `image.repository` and `image.tag` to the pushed image.
4. **Ingress / DNS:** When ingress is enabled in values, point DNS at your load balancer or ingress controller and configure TLS secrets as needed.

Document environment-specific approvals and rollback steps here for your team.
