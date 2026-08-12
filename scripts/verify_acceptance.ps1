param(
  [switch]$RequireNative
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-Step([string]$name, [scriptblock]$body) {
  Write-Host ""
  Write-Host "==> $name"
  & $body
}

function Test-CompilerAvailable {
  foreach ($command in @("cl", "gcc", "cc", "clang")) {
    if (Get-Command $command -ErrorAction SilentlyContinue) {
      return $true
    }
  }
  return $false
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot

Invoke-Step "MoonBit version" { moon version --all }
Invoke-Step "MoonBit registry update" { moon update }
Invoke-Step "Format check" { moon fmt --check }
Invoke-Step "Static check" { moon check --target all }
Invoke-Step "Test wasm" { moon test --target wasm }
Invoke-Step "Test wasm-gc" { moon test --target wasm-gc }
Invoke-Step "Test js" { moon test --target js }
Invoke-Step "Test benchmark package" { moon test src/benchmark --target wasm }
Invoke-Step "Build WASM demo" { moon build --target wasm-gc cmd/wasm }
Invoke-Step "Run CLI demo" { moon run cmd/cli }

$compilerAvailable = Test-CompilerAvailable
if ($RequireNative -or $compilerAvailable) {
  Invoke-Step "Test native" { moon test --target native }
} else {
  Write-Warning "Skipping native target because no system C compiler was detected."
}

Invoke-Step "Interface generation" { moon info }
Invoke-Step "Clean working tree check" {
  git diff --exit-code
  git diff --cached --exit-code
}
Invoke-Step "Repository compliance" { & (Join-Path $PSScriptRoot "check_repo_compliance.ps1") }

Pop-Location
