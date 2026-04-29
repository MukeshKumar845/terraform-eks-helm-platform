# Scripts

Small helpers used **locally** (not required in CI, which installs its own tools).

## `install-helm.ps1`

Downloads a **portable Helm** binary for Windows into **`.tools/helm/windows-amd64/`** (ignored by git).

From the **repository root**:

```powershell
.\scripts\install-helm.ps1
$env:PATH = "$(Resolve-Path .\.tools\helm\windows-amd64);$env:PATH"
helm version
```

Options:

- `-UseWinget` — install via `winget` (`Helm.Helm`) instead of the zip download.
- `-Version x.y.z` — pin another Helm release from [get.helm.sh](https://github.com/helm/helm/releases).
- `-AddToUserPath` — append the portable directory to your **user** `PATH`.

See also [helm-chart/README.md](../helm-chart/README.md).
