$ErrorActionPreference = 'Stop'

$baseKey = 'HKCU:\Software\Classes\SystemFileAssociations\image\shell\LocalImageConverter'
if (Test-Path $baseKey) {
    Remove-Item -Path $baseKey -Recurse -Force
    Write-Host 'Context menu removed.'
} else {
    Write-Host 'Context menu entry was not found.'
}
