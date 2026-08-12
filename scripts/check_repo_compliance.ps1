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
  $files = Get-ChildItem -Path . -Recurse -File -Filter *.mbt |
    Where-Object { $_.FullName -notmatch "[\\/](_build|\.git)[\\/]" }
  $implementationFiles = @($files | Where-Object { $_.Name -notmatch "_test\.mbt$" })
  $testFiles = @($files | Where-Object { $_.Name -match "_test\.mbt$" })
  $implementationLines = 0
  $totalLines = 0
  foreach ($file in $files) {
    $count = (Get-Content -LiteralPath $file.FullName | Measure-Object -Line).Lines
    $totalLines += $count
    if ($file.Name -notmatch "_test\.mbt$") {
      $implementationLines += $count
    }
  }
  [PSCustomObject]@{
    FileCount = @($files).Count
    TestFileCount = $testFiles.Count
    PackageCount = @(Get-ChildItem -Path . -Recurse -File -Filter moon.pkg |
      Where-Object { $_.FullName -notmatch "[\\/](_build|\.git)[\\/]" }).Count
    ImplementationFileCount = $implementationFiles.Count
    ImplementationLines = $implementationLines
    TotalLines = $totalLines
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
  "docs/benchmarks.md",
  "docs/data/reference_sequences.fasta",
  "docs/data/reference_reads.fastq",
  "scripts/verify_acceptance.ps1"
)

$missing = @()
foreach ($path in $requiredFiles) {
  if (-not (Test-Path -LiteralPath $path)) {
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
Write-Host "  test files: $($metrics.TestFileCount)"
Write-Host "  packages: $($metrics.PackageCount)"
Write-Host "  implementation files: $($metrics.ImplementationFileCount)"
Write-Host "  implementation lines: $($metrics.ImplementationLines)"
Write-Host "  total MoonBit lines: $($metrics.TotalLines)"
Write-Host "  origin HEAD: $originHead"
Write-Host "  gitlink HEAD: $gitlinkHead"

if ($missing.Count -gt 0) {
  throw ("Missing required files: " + ($missing -join ", "))
}

$licenseText = Get-Content -Raw -Encoding utf8 LICENSE
if ($licenseText -notmatch "MIT License") {
  throw "LICENSE does not identify the MIT License."
}

if ($metrics.ImplementationLines -lt 3500) {
  throw "Implementation MoonBit LOC is $($metrics.ImplementationLines), below the 3500-line acceptance threshold."
}

if ($metrics.PackageCount -lt 7) {
  throw "Expected at least 7 MoonBit packages, found $($metrics.PackageCount)."
}

if ($commitCount -lt 10) {
  Write-Warning "Commit history is still shallow for a public competition repo."
}

if ($originHead -ne $null -and $originHead -ne "main") {
  Write-Warning "GitHub default branch is not main."
}

if ($gitlinkHead -ne $null -and $gitlinkHead -ne "main") {
  Write-Warning "GitLink default branch is not main yet."
}

Pop-Location
