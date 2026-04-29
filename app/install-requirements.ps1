# Uses "python -m pip" so you do not need a global `pip` command.
# Run:  .\install-requirements.ps1

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Test-PythonExe {
    param([string[]]$Args)
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    & @Args 1>$null 2>$null
    $ok = ($LASTEXITCODE -eq 0)
    $ErrorActionPreference = $prev
    return $ok
}

# 1) py -3 (Windows Python Launcher)
if (Get-Command py -ErrorAction SilentlyContinue) {
    if (Test-PythonExe @("py", "-3", "-c", "import sys")) {
        Write-Host "Using: py -3" -ForegroundColor Green
        & py -3 -m pip install --upgrade pip 2>$null
        & py -3 -m pip install -r requirements.txt
        exit $LASTEXITCODE
    }
}

# 2) python / python3 on PATH
foreach ($name in @("python", "python3")) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) { continue }
    $exe = (Get-Command $name).Source
    if ($exe -match "WindowsApps\\python(3)?\.exe$") {
        if (-not (Test-PythonExe @($exe, "-c", "import sys"))) { continue }
    } elseif (-not (Test-PythonExe @($exe, "-c", "import sys"))) {
        continue
    }
    Write-Host "Using: $exe" -ForegroundColor Green
    & $exe -m pip install --upgrade pip 2>$null
    & $exe -m pip install -r requirements.txt
    exit $LASTEXITCODE
}

# 3) Typical install paths when PATH was not updated
foreach ($ver in @("Python311", "Python312", "Python313")) {
    foreach ($root in @("${env:ProgramFiles}", "${env:LocalAppData}\Programs\Python")) {
        $candidate = Join-Path $root "$ver\python.exe"
        if (-not (Test-Path $candidate)) { continue }
        if (-not (Test-PythonExe @($candidate, "-c", "import sys"))) { continue }
        Write-Host "Using: $candidate" -ForegroundColor Green
        & $candidate -m pip install --upgrade pip 2>$null
        & $candidate -m pip install -r requirements.txt
        exit $LASTEXITCODE
    }
}

Write-Host @"

No working Python found. The "pip" command will not work until Python is installed.

Do this:
  1) Install from https://www.python.org/downloads/windows/
  2) Enable "Add python.exe to PATH"
  3) Close this terminal, open a new one, then:
       cd $PSScriptRoot
       .\install-requirements.ps1
  Or after install:
       python -m pip install -r requirements.txt

Without Python, run the Node sample:
       node server.js

"@ -ForegroundColor Yellow
exit 1
