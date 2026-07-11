Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-RemoteHeadBranch([string]$remoteName) {
  $output = git ls-remote --symref $remoteName HEAD 2>$null
  if ($LASTEXITCODE -ne 0) {
    return $null
  }
  foreach ($line in $output) {
    if ($line -match "ref:\s+refs/heads/([^\s]+)\s+HEAD") {
      return $Matches[1]
    }
  }
  return $null
}

function Get-MoonBitMetrics {
  $files = git ls-files | Where-Object { $_ -match "\.mbti?$" }
  $lineCount = 0
  foreach ($file in $files) {
    if (Test-Path $file) {
      $lineCount += (Get-Content $file | Measure-Object -Line).Lines
    }
  }
  [PSCustomObject]@{
    FileCount = $files.Count
    LineCount = $lineCount
  }
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot

$requiredFiles = @(
  "README.md",
  "LICENSE",
  "moon.mod",
  "moon.pkg",
  ".github/workflows/ci.yml",
  "official-requirements.md",
  "proposal-one-page.md",
  "source-attribution.md",
  "submission-status.md",
  "docs/usage-evidence.md",
  "scripts/verify_acceptance.ps1"
)

$missing = @()
foreach ($path in $requiredFiles) {
  if (-not (Test-Path $path)) {
    $missing += $path
  }
}

$metrics = Get-MoonBitMetrics
$currentBranch = git branch --show-current
$commitCount = [int](git rev-list --count HEAD)
$originHead = Get-RemoteHeadBranch "origin"
$gitlinkHead = Get-RemoteHeadBranch "gitlink"

Write-Host "MoonBio compliance summary"
Write-Host "  branch: $currentBranch"
Write-Host "  commits: $commitCount"
Write-Host "  moonbit files: $($metrics.FileCount)"
Write-Host "  moonbit lines: $($metrics.LineCount)"
Write-Host "  origin HEAD: $originHead"
Write-Host "  gitlink HEAD: $gitlinkHead"

if ($missing.Count -gt 0) {
  Write-Error ("Missing required files: " + ($missing -join ", "))
}

if ($commitCount -lt 10) {
  Write-Warning "Commit history is still shallow for a public competition repo."
}

if ($metrics.LineCount -lt 400) {
  Write-Warning "Effective MoonBit LOC is still modest; keep expanding substantive code."
}

if ($originHead -ne "main") {
  Write-Warning "GitHub default branch is not main."
}

if ($null -ne $gitlinkHead -and $gitlinkHead -ne "main") {
  Write-Warning "GitLink default branch is not main yet."
}

Pop-Location
