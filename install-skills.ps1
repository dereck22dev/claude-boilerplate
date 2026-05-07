# Reads claude-boilerplate/skills.txt, filters by -Categories, installs into ./.claude/.
# Usage:
#   .\install-skills.ps1                                  # default: core,dev,design
#   .\install-skills.ps1 -Categories all
#   .\install-skills.ps1 -Categories core,mobile

param(
    [string[]] $Categories = @("core","dev","design")
)

$ErrorActionPreference = "Stop"
$skillsFile = Join-Path $PSScriptRoot "skills.txt"

if (-not (Test-Path $skillsFile)) {
    Write-Error "skills.txt not found at $skillsFile"
    exit 1
}

# Normalise: comma-separated single string also accepted
$catSet = ($Categories -join ',') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
$installAll = $catSet -contains "all"

$entries = Get-Content $skillsFile -Encoding UTF8 | ForEach-Object {
    $line = ($_ -split '#', 2)[0].Trim()
    if ($line -eq "") { return }
    $parts = $line -split '\s+', 3
    if ($parts.Count -ne 3) { return }
    [PSCustomObject]@{ Category = $parts[0]; Kind = $parts[1]; Name = $parts[2] }
}

$selected = $entries | Where-Object {
    $installAll -or ($catSet -contains $_.Category)
}

$skills = @($selected | Where-Object { $_.Kind -eq "skill" })
$agents = @($selected | Where-Object { $_.Kind -eq "agent" })

Write-Host ""
Write-Host "Categories : $($catSet -join ', ')" -ForegroundColor DarkGray
Write-Host "Source     : $skillsFile" -ForegroundColor DarkGray
Write-Host "Working dir: $(Get-Location)" -ForegroundColor DarkGray
Write-Host "Installing $($skills.Count) skills + $($agents.Count) agents into .claude/" -ForegroundColor Cyan
Write-Host ""

if (($skills.Count + $agents.Count) -eq 0) {
    Write-Warning "No skills/agents matched categories: $($catSet -join ',')"
    Write-Warning "Available categories: $((($entries | Select-Object -ExpandProperty Category | Sort-Object -Unique) -join ', '))"
    exit 1
}

foreach ($s in $skills) {
    Write-Host "[skill] $($s.Name)" -ForegroundColor Yellow
    npx --yes claude-code-templates@latest --skill $s.Name
}

foreach ($a in $agents) {
    Write-Host "[agent] $($a.Name)" -ForegroundColor Magenta
    npx --yes claude-code-templates@latest --agent $a.Name
}

Write-Host ""
Write-Host "Done. Open Claude Code in this directory and type / to see the new commands." -ForegroundColor Green
