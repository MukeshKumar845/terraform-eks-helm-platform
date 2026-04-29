# Architecture

At a high level: **Terraform** provisions **VPC**, **IAM**, **EKS**, **ECR**, and **monitoring** in AWS. The **app** is built as a container image, stored in **ECR**, and deployed to the cluster with **Helm** (`helm-chart/`). **GitHub Actions** validate Terraform and Helm, and optionally build, push, and upgrade the release.

Extend this page with a diagram (Mermaid, PNG under `screenshots/`, or your standard tooling) as the design stabilizes.
