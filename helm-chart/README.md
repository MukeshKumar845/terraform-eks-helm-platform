# Helm chart

Kubernetes manifests for the sample app, with separate value files for **dev** and **prod**.

## Install Helm (Windows, in this repo)

From the repository root:

```powershell
.\scripts\install-helm.ps1
```

Then add the portable binary to your current session:

```powershell
$env:PATH = "$(Resolve-Path .\.tools\helm\windows-amd64);$env:PATH"
helm version
```

Optional:

- Machine-wide via winget: `.\scripts\install-helm.ps1 -UseWinget` (then open a new terminal).
- Append the portable folder to your user PATH: `.\scripts\install-helm.ps1 -AddToUserPath` (new terminals only).

Other versions: `.\scripts\install-helm.ps1 -Version 3.15.4`

## Lint and template

```powershell
cd helm-chart
helm lint . -f values-dev.yaml
helm lint . -f values-prod.yaml
helm template test-release . -f values-dev.yaml
```

## Deploy (example)

```powershell
helm upgrade --install my-release . -f values-dev.yaml -n default --create-namespace
```

Replace `values-dev.yaml` with `values-prod.yaml` and set `image.repository` / ingress hosts to match your ECR and DNS.
