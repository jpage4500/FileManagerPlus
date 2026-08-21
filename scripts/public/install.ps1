<#
.SYNOPSIS
    One-line installer for File Manager+ on Windows.

.DESCRIPTION
    Finds the latest release, downloads the jdeploy installer built for this CPU, and runs
    it. jdeploy takes it from there: it installs the app and auto-updates it on every launch
    afterwards, so this is only ever needed once.

    macOS and Linux use scripts/public/install.sh instead.

.EXAMPLE
    irm https://raw.githubusercontent.com/jpage4500/FileManagerPlus/main/scripts/public/install.ps1 | iex

.EXAMPLE
    # piping to iex can't pass arguments -- build a script block to do that
    & ([scriptblock]::Create((irm https://raw.githubusercontent.com/jpage4500/FileManagerPlus/main/scripts/public/install.ps1))) -Version 1.0.43

.EXAMPLE
    .\install.ps1 -DryRun
#>
param(
    # a release tag such as 1.0.43; omit for the latest release
    [string] $Version,
    # download the installer but don't run it
    [switch] $DryRun
)

$ErrorActionPreference = 'Stop'
# Invoke-WebRequest's progress bar makes a large download roughly an order of magnitude slower
$ProgressPreference = 'SilentlyContinue'

# the source repo is private; releases (and this script, synced with the README) are public
$Repo    = 'jpage4500/FileManagerPlus'
$AppName = 'File Manager+'

# Windows PowerShell 5.1 still defaults to TLS 1.0, which github.com refuses
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ---------------------------------------------------------------- which build to fetch

# a 32-bit PowerShell on a 64-bit machine reports x86 here and the real one in the W6432 copy
$machine = $env:PROCESSOR_ARCHITEW6432
if (-not $machine) { $machine = $env:PROCESSOR_ARCHITECTURE }

switch ($machine) {
    'ARM64' { $arch = 'arm64' }
    'AMD64' { $arch = 'x64' }
    default { throw "unsupported architecture: $machine (File Manager+ ships x64 and arm64 builds)" }
}

Write-Host "Installing $AppName for win-$arch..."

# ---------------------------------------------------------------- find the release

$api = if ($Version) {
    "https://api.github.com/repos/$Repo/releases/tags/$Version"
} else {
    "https://api.github.com/repos/$Repo/releases/latest"
}

try {
    $release = Invoke-RestMethod -Uri $api -Headers @{ 'User-Agent' = 'fm-install' }
} catch {
    throw "could not reach api.github.com (offline? rate limited? no release tagged '$Version'?)"
}

# jdeploy names every asset "...Installer-<os>-<arch>-<version>_<hash>.<ext>"
$asset = $release.assets | Where-Object { $_.name -like "*Installer-win-$arch-*.exe" } | Select-Object -First 1
if (-not $asset) { throw "no win-$arch installer in release $($release.tag_name)" }
Write-Host "  version $($release.tag_name)"

# ---------------------------------------------------------------- download

# kept rather than written to a directory that gets cleaned up: the installer is a GUI app
# that may hand off and return before it has finished reading its own exe
$work = Join-Path $env:TEMP 'fm-install'
New-Item -ItemType Directory -Force -Path $work | Out-Null
$exe = Join-Path $work $asset.name

Write-Host 'Downloading...'
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $exe

# clears the mark-of-the-web so SmartScreen doesn't block the installer outright
Unblock-File -Path $exe -ErrorAction SilentlyContinue

if ($DryRun) {
    Write-Host "  [dry-run] would launch: $exe"
    exit 0
}

# ---------------------------------------------------------------- run the installer

Write-Host 'Starting the installer...'
Start-Process -FilePath $exe -Wait

Write-Host ''
Write-Host "The installer window has opened -- follow it through to finish."
Write-Host "$AppName auto-updates on launch from then on."
Write-Host ''
Write-Host 'If it stops with "Cannot load app info because the app.xml file could not be found",'
Write-Host "your network inspects TLS and the installer's private JRE doesn't trust your company's"
Write-Host 'root CA. Import that root into the cacerts of the JRE under %USERPROFILE%\.jdeploy'
Write-Host 'with keytool, then run the installer again.'
