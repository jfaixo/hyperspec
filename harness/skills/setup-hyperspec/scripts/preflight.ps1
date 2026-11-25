# PowerShell preflight checks script for Hyperspec
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$workspaceRoot = (Get-Location).Path
$configPath = Join-Path (Join-Path $workspaceRoot ".hyperspec") "hyperspec.json"

function Fail-Preflight {
    param(
        [string]$Check,
        [string]$Message
    )

    Write-Output (@{
        status = "FAILED"
        check = $Check
        error = $Message
    } | ConvertTo-Json)
    exit 1
}

function Test-IssueTrackerCli {
    param(
        [string]$Prefix,
        [string]$Label,
        [string]$Command
    )

    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        Fail-Preflight -Check "${Prefix}_cli_installed" -Message "$Label ($Command) is missing or not in PATH."
    }

    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $authOutput = & $Command auth status 2>&1
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousPreference
    }

    if ($exitCode -ne 0) {
        if ($authOutput) {
            $authOutput | ForEach-Object { [Console]::Error.WriteLine($_) }
        }
        Fail-Preflight -Check "${Prefix}_cli_ready" -Message "$Label ($Command) requires authentication. Run '$Command auth login'."
    }
}

Write-Host "[setup-hyperspec] Running preflight checks..."

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail-Preflight -Check "git_installed" -Message "git is missing or not in PATH."
}

$previousPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    $isWorkTree = (& git rev-parse --is-inside-work-tree 2>$null | Out-String).Trim()
    $gitExitCode = $LASTEXITCODE
} finally {
    $ErrorActionPreference = $previousPreference
}

if ($gitExitCode -ne 0 -or $isWorkTree -ne "true") {
    Fail-Preflight -Check "git_repository" -Message "Current directory is not a git repository."
}

if (-not (Test-Path -Path $configPath -PathType Leaf)) {
    Fail-Preflight -Check "issue_tracker_config" -Message "Missing $configPath."
}

try {
    $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json
    $prop = $config.PSObject.Properties['issue-tracker']
    $issueTracker = if ($prop) { $prop.Value } else { $null }
} catch {
    Fail-Preflight -Check "issue_tracker_config" -Message "Failed to parse ${configPath}: $($_.Exception.Message)"
}

switch ($issueTracker) {
    "github" { Test-IssueTrackerCli -Prefix "github" -Label "GitHub CLI" -Command "gh" }
    "gitlab" { Test-IssueTrackerCli -Prefix "gitlab" -Label "GitLab CLI" -Command "glab" }
    "local" { }
    "custom" { }
    default {
        Fail-Preflight -Check "issue_tracker_config" -Message "Missing or invalid 'issue-tracker' in $configPath. Expected: github, gitlab, local, or custom."
    }
}

Write-Output (@{
    status = "SUCCESS"
    issue_tracker = $issueTracker
} | ConvertTo-Json)

