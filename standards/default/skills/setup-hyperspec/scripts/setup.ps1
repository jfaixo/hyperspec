# PowerShell deterministic setup script for Hyperspec
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$workspaceRoot = (Get-Location).Path
$hyperspecDir = Join-Path $workspaceRoot ".hyperspec"
$configPath = Join-Path $hyperspecDir "hyperspec.json"
$scriptDir = $PSScriptRoot
$sourceAssetsDir = Join-Path $scriptDir "..\assets\.hyperspec"

Write-Host "[setup-hyperspec] Initializing Hyperspec v0.3.0..."

# 1. Ensure destination directory exists
if (-not (Test-Path -Path $hyperspecDir)) {
    New-Item -ItemType Directory -Path $hyperspecDir -Force | Out-Null
}

# 2. Mirror assets/.hyperspec (hyperspec.json, specs-organization.md, templates/) to destination
if (-not (Test-Path -Path $sourceAssetsDir)) {
    Write-Output (@{
        status = "FAILED"
        error = "Source assets not found at $sourceAssetsDir"
    } | ConvertTo-Json)
    exit 1
}

Copy-Item -Path "$sourceAssetsDir\*" -Destination $hyperspecDir -Recurse -Force
Write-Host "[setup-hyperspec] Installed configuration, templates, and specs-organization.md to $hyperspecDir"

Write-Output (@{
    status = "SUCCESS"
    version = "0.3.0"
    configPath = $configPath
} | ConvertTo-Json)

