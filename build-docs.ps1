$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

$dotnet = Get-Command dotnet -ErrorAction Stop
$dotnetInfo = & $dotnet.Source --info
$basePathLine = $dotnetInfo | Where-Object { $_ -match '^\s*Base Path:\s+(.+)$' } | Select-Object -First 1

if (-not $basePathLine) {
    throw "Could not find the .NET SDK base path from 'dotnet --info'."
}

$basePath = ($basePathLine -replace '^\s*Base Path:\s+', '').Trim()
$dotnetRoot = [IO.Path]::GetFullPath((Join-Path $basePath (Join-Path '..' '..')))
$refPackRoot = Join-Path (Join-Path $dotnetRoot 'packs') 'Microsoft.NETCore.App.Ref'

if (-not (Test-Path -LiteralPath $refPackRoot)) {
    throw "Could not find Microsoft.NETCore.App.Ref under '$dotnetRoot'. Ensure a .NET 10 SDK is available."
}

$net10RefPack = Get-ChildItem -LiteralPath $refPackRoot -Directory |
    Where-Object { $_.Name -like '10.*' -and (Test-Path -LiteralPath (Join-Path (Join-Path $_.FullName 'ref') 'net10.0')) } |
    Sort-Object { [version]$_.Name } -Descending |
    Select-Object -First 1

if (-not $net10RefPack) {
    throw "Could not find a .NET 10 reference pack under '$refPackRoot'. Ensure a .NET 10 SDK is available."
}

$env:DOCFX_NETCORE_APP_REF = $net10RefPack.FullName

Push-Location $scriptRoot
try {
    docfx ./docfx.json
}
finally {
    Pop-Location
}
