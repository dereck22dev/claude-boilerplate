# Bootstrap a new Claude Code project from this boilerplate.
# Usage:
#   .\new-project.ps1 -Path my-app -Name "My App"
#   .\new-project.ps1 -Path my-app -Name "My App" -Categories core,mobile -InitGit
#   .\new-project.ps1 -Path my-app -Name "My App" -SkipSkills

param(
    [Parameter(Mandatory=$true)] [string]   $Path,
    [Parameter(Mandatory=$true)] [string]   $Name,
    [string[]] $Categories = @("core","dev","design"),
    [switch]   $SkipSkills,
    [switch]   $InitGit
)

$ErrorActionPreference = "Stop"
$boilerplate = $PSScriptRoot
$templates = Join-Path $boilerplate "templates"

if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
}

$resolved = (Resolve-Path $Path).Path
Write-Host "Bootstrapping project at $resolved" -ForegroundColor Cyan

# --- Root-level files (with templating). Force UTF8 to preserve em-dashes etc. on PS 5.1. ---
$claudeMd = (Get-Content (Join-Path $boilerplate "CLAUDE.md") -Raw -Encoding UTF8) -replace "\{\{PROJECT_NAME\}\}", $Name
Set-Content -Path (Join-Path $resolved "CLAUDE.md") -Value $claudeMd -Encoding UTF8 -NoNewline

$claudeLocalMd = (Get-Content (Join-Path $templates "CLAUDE.local.md") -Raw -Encoding UTF8) -replace "\{\{PROJECT_NAME\}\}", $Name
Set-Content -Path (Join-Path $resolved "CLAUDE.local.md") -Value $claudeLocalMd -Encoding UTF8 -NoNewline

Copy-Item (Join-Path $boilerplate "WORKFLOW.md") (Join-Path $resolved "WORKFLOW.md")
Copy-Item (Join-Path $boilerplate "plugins.txt") (Join-Path $resolved "plugins.txt")
Copy-Item (Join-Path $templates ".gitignore") (Join-Path $resolved ".gitignore")

# --- docs/ scaffolding ---
$docsSolutions = Join-Path $resolved "docs\solutions"
New-Item -ItemType Directory -Force -Path $docsSolutions | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $resolved "docs\specs") | Out-Null
Copy-Item (Join-Path $templates "docs\solutions\INDEX.md") (Join-Path $docsSolutions "INDEX.md")

# --- .claude/ ---
$claudeDir = Join-Path $resolved ".claude"
New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
Copy-Item (Join-Path $templates "settings.json") (Join-Path $claudeDir "settings.json")
Copy-Item (Join-Path $templates "settings.local.json") (Join-Path $claudeDir "settings.local.json")

# --- .claude/commands/ (custom slash commands) ---
$commandsSrc = Join-Path $templates "commands"
$commandsDst = Join-Path $claudeDir "commands"
New-Item -ItemType Directory -Force -Path $commandsDst | Out-Null
Get-ChildItem $commandsSrc -File | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $commandsDst $_.Name)
}

# --- Optional: git init ---
if ($InitGit) {
    Push-Location $resolved
    try {
        git init | Out-Null
        Write-Host "Initialized git repo" -ForegroundColor DarkGray
    } finally {
        Pop-Location
    }
}

# --- Skills install (filtered by Categories) ---
if (-not $SkipSkills) {
    Write-Host ""
    Write-Host "Installing skills + agents (categories: $($Categories -join ','))..." -ForegroundColor Cyan
    Push-Location $resolved
    try {
        & (Join-Path $boilerplate "install-skills.ps1") -Categories $Categories
    } finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "Project ready at $resolved" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Edit CLAUDE.md - fill in stack, verification commands, gotchas"
Write-Host "  2. Edit CLAUDE.local.md (gitignored) - your personal context"
Write-Host "  3. Open Claude Code in $resolved"
Write-Host "  4. On first launch, click 'Trust' when prompted for the 3 marketplaces"
Write-Host "     (compound-engineering, superpowers, claude-code-skills) - pre-declared"
Write-Host "     in .claude/settings.json. Optional plugins live in plugins.txt."
Write-Host "  5. Run: /start-feature <feature-slug>  (or /fast for trivial fixes)"
