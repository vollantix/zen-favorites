$ErrorActionPreference = "Stop"

$rptDirectory = Join-Path $env:LOCALAPPDATA "Arma 3"
$latestRpt = Get-ChildItem $rptDirectory -Filter "*.rpt" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if ($null -eq $latestRpt) {
    throw "No Arma 3 RPT files found in $rptDirectory"
}

$outputDirectory = Join-Path (Get-Location) "logs"
$outputPath = Join-Path $outputDirectory "zen_filter_latest.log"

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

Select-String -Path $latestRpt.FullName -Pattern "\[ZEN Filter\]" |
    ForEach-Object { $_.Line } |
    Set-Content -Path $outputPath

Write-Host "Source RPT: $($latestRpt.FullName)"
Write-Host "Wrote: $outputPath"
