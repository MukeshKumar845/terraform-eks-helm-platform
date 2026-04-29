# Documentation

Use this folder for **architecture**, **runbooks**, and **diagrams** that describe how the platform fits together.

## Files in this folder

| File / folder | Content |
|----------------|--------|
| [architecture.md](architecture.md) | High-level narrative of Terraform, EKS, ECR, Helm, and CI. |
| [deployment-flow.md](deployment-flow.md) | Order of operations from infra apply to Helm release. |
| `screenshots/` | Optional images (placeholders; add PNGs as needed). |

## Related READMEs

- [Root README](../README.md) — full repo overview.
- [Terraform](../terraform/README.md) — modules, environments, backend, commands.
- [Helm chart](../helm-chart/README.md) — install Helm, lint, deploy examples.
- [App](../app/README.md) — local run and Docker.

Add or link runbooks here as the stack grows (backups, upgrades, incident response).
