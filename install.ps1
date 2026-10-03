<#
  ouu-shiit installer for PowerShell 7+ (also works on Windows PowerShell 5.1).

  Built on the skills CLI from vercel-labs - https://skills.sh
  Installs ouu-shiit, plus the design skills it is designed to be used with.

    ./install.ps1                    install everything, for Claude Code, globally
    ./install.ps1 -Agent '*'         install for every agent detected on the machine
    ./install.ps1 -Agent cursor      install for Cursor only
    ./install.ps1 -Scope project     install into the current project instead of ~/
    ./install.ps1 -Skill 0           skip the companion skills, install ouu-shiit only
    ./install.ps1 -Video 0           skip HyperFrames, the video and deck toolchain

  The same knobs are read from the environment when the parameters are omitted,
  so the shell installer's interface keeps working:

    $env:AGENT = 'cursor'; ./install.ps1

  One divergence from install.sh: an empty SCOPE means "current project" there,
  but PowerShell cannot hold an empty environment variable (assigning '' removes
  it). Use -Scope project or $env:SCOPE = 'project' instead.

  Non-interactive one-liner:

    irm https://raw.githubusercontent.com/asterxsk/ouu-shiit/main/install.ps1 | iex
#>

[CmdletBinding()]
param(
  [string]$Agent = $(if ($env:AGENT) { $env:AGENT } else { 'claude-code' }),
  [string]$Scope = $(if ($env:SCOPE) { $env:SCOPE } else { '-g' }),
  [string]$Skill = $(if ($env:SKILL) { $env:SKILL } else { '1' }),
  [string]$Video = $(if ($env:VIDEO) { $env:VIDEO } else { '1' })
)

$ErrorActionPreference = 'Stop'

# '-g' / 'global' / '' -> global; anything else ('project', 'p', '-p', '.') -> project.
$scopeFlag = if ($Scope -in @('-g', 'global')) { '-g' } else { $null }
$scopeLabel = if ($scopeFlag) { 'global' } else { 'project' }

if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
  Write-Error 'npx not found. Install Node.js 18 or newer first: https://nodejs.org'
  exit 1
}

function Add-Skill {
  param([string]$Repo, [string]$Name)

  $cliArgs = @('-y', 'skills', 'add', $Repo, '--skill', $Name)
  if ($scopeFlag) { $cliArgs += $scopeFlag }
  $cliArgs += @('-a', $Agent, '-y')

  Write-Host ''
  Write-Host "-> npx $($cliArgs -join ' ')" -ForegroundColor Cyan
  & npx @cliArgs
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host ''
Write-Host 'ouu-shiit' -NoNewline
Write-Host ' - effects, motion, and video for any surface'
Write-Host "agent: $Agent   scope: $scopeLabel"

Add-Skill asterxsk/ouu-shiit ouu-shiit

if ($Skill -ne '0') {
  # The design skills this one pairs with. Each is a separate upstream repo.
  Add-Skill pbakaus/impeccable impeccable
  Add-Skill Leonxlnx/taste-skill design-taste-frontend
  Add-Skill vercel-labs/agent-skills web-design-guidelines
}

if ($Video -ne '0') {
  # HyperFrames - video, motion graphics, and decks. Its own repo, its own
  # router skill, and it keeps itself updated.
  #
  # Only the router is added here. Naming the skill explicitly is what keeps a
  # scripted run off the interactive picker: an agent or non-interactive
  # "skills add" without --skill installs all 21 published skills. The router
  # installs each creation workflow on demand from there, and
  # "npx hyperframes skills update" pulls the rest of the core set.
  Add-Skill heygen-com/hyperframes hyperframes
}

Write-Host ''
Write-Host '------------------------------------------------------------------'
Write-Host 'Done.'
Write-Host ''
Write-Host '  ouu-shiit              the effect layer (this repo)'

if ($Skill -ne '0') {
  Write-Host '  impeccable             visual direction and craft'
  Write-Host '  design-taste-frontend  brief inference, motion budget, pre-flight check'
  Write-Host '  web-design-guidelines  interface audit'
}

if ($Video -ne '0') {
  Write-Host '  HyperFrames            video, motion graphics, and decks (the /hyperframes router)'
}

Write-Host ''
Write-Host 'Optional, not installable - it is reference material, not a skill:'
Write-Host ''
Write-Host '  awesome-design-md      74 analysed brand DESIGN.md systems'
Write-Host ''
Write-Host '    git clone --depth 1 https://github.com/VoltAgent/awesome-design-md'
Write-Host ''
Write-Host '  Copy a single brand file into a project root when a brief names one.'
Write-Host '  See skills/ouu-shiit/reference/design-references.md.'

if ($Video -ne '0') {
  Write-Host ''
  Write-Host 'HyperFrames renders video locally with headless Chrome and FFmpeg. It needs'
  Write-Host 'Node.js 22 or newer and ffmpeg on your PATH - run "npx hyperframes doctor"'
  Write-Host 'to check. Local rendering is free (Apache-2.0); only "hyperframes cloud'
  Write-Host 'render" bills per minute.'
  Write-Host ''
  Write-Host 'This installer adds the /hyperframes router. Run "npx hyperframes skills'
  Write-Host 'update" to pull the rest of the core set (the domain skills and media-use);'
  Write-Host 'the router installs each creation workflow on demand from there. Installing'
  Write-Host 'the router rather than all 21 skills is deliberate - the picker is'
  Write-Host 'interactive-only, so a scripted "skills add" without --skill would pull the'
  Write-Host 'entire catalog.'
  Write-Host ''
  Write-Host '  See skills/ouu-shiit/reference/hyperframes.md.'
}

Write-Host ''
Write-Host 'Restart your agent so the new skills are picked up.'
Write-Host ''
Write-Host 'Docs:  https://skills.sh'
