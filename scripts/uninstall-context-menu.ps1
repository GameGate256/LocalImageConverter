$ErrorActionPreference = 'Stop'

$baseKey = 'HKCU:\Software\Classes\SystemFileAssociations\image\shell\LocalImageConverter'
if (Test-Path $baseKey) {
    Remove-Item -Path $baseKey -Recurse -Force
    Write-Host 'Image context menu removed.'
} else {
    Write-Host 'Image context menu entry was not found.'
}

$icoBaseKey = 'HKCU:\Software\Classes\SystemFileAssociations\.ico\shell\LocalImageConverter'
if (Test-Path $icoBaseKey) {
    Remove-Item -Path $icoBaseKey -Recurse -Force
    Write-Host 'ICO context menu removed.'
} else {
    Write-Host 'ICO context menu entry was not found.'
}

$webpBaseKey = 'HKCU:\Software\Classes\SystemFileAssociations\.webp\shell\LocalImageConverter'
if (Test-Path $webpBaseKey) {
    Remove-Item -Path $webpBaseKey -Recurse -Force
    Write-Host 'WebP context menu removed.'
} else {
    Write-Host 'WebP context menu entry was not found.'
}
