# App

Sample workload for the Terraform EKS Helm platform: Docker images, Kubernetes / Helm, and CI/CD. It is a small HTTP service for local development and container builds (EKS / Helm).

## Why `pip install -r requirements.txt` fails

Typical messages:

- **`pip` is not recognized** — there is no `pip` on your PATH. That usually means **Python is not installed** (or only the Microsoft Store **stub** exists under `WindowsApps`).
- **`python` was not found`** — same root cause: install real Python from python.org.

**Easiest on Windows (uses `python -m pip`, not bare `pip`):**

```powershell
cd C:\Users\MarioKumar\Desktop\terraform-eks-helm-platform\app
.\install-requirements.ps1
```

If that prints “No working Python found”, install Python first (step 1 below).

**Fix (pick one):**

1. **Install Python 3.11+** from [python.org/downloads](https://www.python.org/downloads/windows/). During setup, enable **“Add python.exe to PATH”**. Open a **new** terminal, then:

   ```powershell
   cd C:\Users\MarioKumar\Desktop\terraform-eks-helm-platform\app
   python -m pip install -r requirements.txt
   python app.py
   ```

   Prefer **`python -m pip`** over **`pip`** so the same interpreter is used every time.

2. **If the Store stub opens instead of real Python:** Settings → Apps → Advanced app settings → **App execution aliases** → turn off aliases for `python.exe` / `python3.exe`, then install Python from python.org as above.

## Run without Python (Node)

This folder includes a zero-dependency Node sample (no `npm install` required):

```powershell
cd C:\Users\MarioKumar\Desktop\terraform-eks-helm-platform\app
node server.js
```

Listening on `http://localhost:8080`.

## Docker

From the `app` directory:

```powershell
docker build -t platform-app .
docker run --rm -p 5000:5000 platform-app
```

The image installs dependencies from `requirements.txt` and runs the app with **gunicorn** on port **5000**.
