# PowerShell deterministic setup script for Hyperspec
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Standard,
    [Parameter(Position = 1)]
    [string]$IssueTracker
)

$ErrorActionPreference = "Stop"

$workspaceRoot = (Get-Location).Path
$hyperspecDir = Join-Path $workspaceRoot ".hyperspec"
$configPath = Join-Path $hyperspecDir "hyperspec.json"
$scriptDir = $PSScriptRoot
$standardsDir = Join-Path $scriptDir "..\assets\standards"
$issueTrackersDir = Join-Path $scriptDir "..\assets\issue-trackers"

Write-Host "[setup-hyperspec] Initializing Hyperspec..."

if (-not (Test-Path -Path $standardsDir -PathType Container)) {
    Write-Output (@{
        status = "FAILED"
        error = "Standards directory not found at $standardsDir"
    } | ConvertTo-Json)
    exit 1
}

$availableStandards = @(Get-ChildItem -Path $standardsDir -Directory | Select-Object -ExpandProperty Name | Sort-Object)
if ($availableStandards.Count -eq 0) {
    Write-Output (@{
        status = "FAILED"
        error = "No standards found in $standardsDir"
    } | ConvertTo-Json)
    exit 1
}

$hasDefault = $availableStandards -contains "default"
$selectedStandard = $null

if (-not [string]::IsNullOrWhiteSpace($Standard)) {
    if ($availableStandards -notcontains $Standard) {
        Write-Output (@{
            status = "FAILED"
            error = "Standard '$Standard' not found in $standardsDir"
        } | ConvertTo-Json)
        exit 1
    }
    $selectedStandard = $Standard
} elseif ($availableStandards.Count -eq 1 -and $hasDefault) {
    $selectedStandard = "default"
} else {
    Write-Host "Available standards:"
    for ($i = 0; $i -lt $availableStandards.Count; $i++) {
        Write-Host "  $($i + 1)) $($availableStandards[$i])"
    }

    while (-not $selectedStandard) {
        $promptText = if ($hasDefault) {
            "Select a standard (number or name) [default]"
        } else {
            "Select a standard (number or name)"
        }

        $choice = Read-Host $promptText
        if ([string]::IsNullOrWhiteSpace($choice)) {
            if ($hasDefault) {
                $selectedStandard = "default"
                break
            }
        } elseif ($choice -match '^\d+$') {
            $idx = [int]$choice
            if ($idx -ge 1 -and $idx -le $availableStandards.Count) {
                $selectedStandard = $availableStandards[$idx - 1]
                break
            }
        } elseif ($availableStandards -contains $choice) {
            $selectedStandard = $choice
            break
        }

        Write-Host "Invalid selection: '$choice'" -ForegroundColor Red
    }
}

$sourceAssetsDir = Join-Path $standardsDir $selectedStandard

if (-not (Test-Path -Path $hyperspecDir)) {
    New-Item -ItemType Directory -Path $hyperspecDir -Force | Out-Null
}

Get-ChildItem -Path $sourceAssetsDir -Force | Copy-Item -Destination $hyperspecDir -Recurse -Force
Write-Host "[setup-hyperspec] Installed standard '$selectedStandard' to $hyperspecDir"

if (-not [string]::IsNullOrWhiteSpace($IssueTracker)) {
    $trackerFile = switch ($IssueTracker) {
        "github" { "github-cli.md" }
        "gitlab" { "gitlab-cli.md" }
        "local"  { "local.md" }
        "custom" { $null }
        default {
            Write-Output (@{
                status = "FAILED"
                error = "Invalid issue tracker: $IssueTracker. Expected: github, gitlab, local, or custom."
            } | ConvertTo-Json)
            exit 1
        }
    }

    if ($trackerFile) {
        $sourceTracker = Join-Path $issueTrackersDir $trackerFile
        if (-not (Test-Path -Path $sourceTracker -PathType Leaf)) {
            Write-Output (@{
                status = "FAILED"
                error = "Issue tracker manual not found at $sourceTracker"
            } | ConvertTo-Json)
            exit 1
        }
        Copy-Item -Path $sourceTracker -Destination (Join-Path $hyperspecDir "issue-tracker-manual.md") -Force
        Write-Host "[setup-hyperspec] Installed issue tracker manual '$IssueTracker' to $(Join-Path $hyperspecDir 'issue-tracker-manual.md')"
    }
}

Write-Output (@{
    status = "SUCCESS"
    version = "0.3.0"
    standard = $selectedStandard
    issue_tracker = $IssueTracker
    configPath = $configPath
} | ConvertTo-Json)

