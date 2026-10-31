param(
    [string]$StorePassword = "",
    [string]$KeystorePath = ""
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

& (Join-Path $root "build-release.ps1") `
    -StorePassword $StorePassword `
    -KeystorePath $KeystorePath
& (Join-Path $root "tools\build-pc-installer.ps1")
& (Join-Path $root "tools\package-github.ps1")
