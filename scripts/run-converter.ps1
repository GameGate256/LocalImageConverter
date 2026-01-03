Param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$converter = Join-Path (Join-Path $projectRoot 'app') 'local_image_converter.py'

$python = Get-Command pythonw.exe -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command python.exe -ErrorAction SilentlyContinue
}

if (-not $python) {
    Write-Error 'Python executable was not found on PATH.'
}

if (-not (Test-Path $converter)) {
    Write-Error "Converter script not found at $converter"
}

# Launch the converter using a GUI-friendly interpreter when available.
try {
    Write-Host "Launching: $($python.Source) $converter $SourcePath"
    & $python.Source "$converter" "$SourcePath"
    Write-Host "Converter execution completed"
} catch {
    Write-Host "Error: $_"
    Read-Host "Press Enter to continue"
}
