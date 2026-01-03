$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$runner = Join-Path $PSScriptRoot 'run-converter.ps1'

if (-not (Test-Path $runner)) {
    Write-Error "run-converter.ps1 not found at $runner"
}

$iconPath = Join-Path (Join-Path $projectRoot 'app') 'icon.ico'
$command = "powershell.exe -ExecutionPolicy Bypass -File `"$runner`" `"%1`""

# Apply to all image file types detected by Explorer.
$baseKey = 'HKCU:\Software\Classes\SystemFileAssociations\image\shell\LocalImageConverter'

New-Item -Path $baseKey -Force | Out-Null
Set-ItemProperty -Path $baseKey -Name 'MUIVerb' -Value 'LocalImageConverter' -Force
Set-ItemProperty -Path $baseKey -Name 'SubCommands' -Value '' -Force
if (Test-Path $iconPath) {
    Set-ItemProperty -Path $baseKey -Name 'Icon' -Value $iconPath -Force
} elseif (Get-ItemProperty -Path $baseKey -Name 'Icon' -ErrorAction SilentlyContinue) {
    Remove-ItemProperty -Path $baseKey -Name 'Icon' -ErrorAction SilentlyContinue
}

$convertKey = "$baseKey\shell\ConvertToICO"
New-Item -Path $convertKey -Force | Out-Null
Set-ItemProperty -Path $convertKey -Name 'MUIVerb' -Value 'Convert to ICO...' -Force

$commandKey = "$convertKey\command"
New-Item -Path $commandKey -Force | Out-Null
Set-ItemProperty -Path $commandKey -Name '(Default)' -Value $command -Force

# Add context menu for ICO files specifically (Convert to PNG)
$icoBaseKey = 'HKCU:\Software\Classes\SystemFileAssociations\.ico\shell\LocalImageConverter'

New-Item -Path $icoBaseKey -Force | Out-Null
Set-ItemProperty -Path $icoBaseKey -Name 'MUIVerb' -Value 'LocalImageConverter' -Force
Set-ItemProperty -Path $icoBaseKey -Name 'SubCommands' -Value '' -Force
if (Test-Path $iconPath) {
    Set-ItemProperty -Path $icoBaseKey -Name 'Icon' -Value $iconPath -Force
}

$icoConvertKey = "$icoBaseKey\shell\ConvertToPNG"
New-Item -Path $icoConvertKey -Force | Out-Null
Set-ItemProperty -Path $icoConvertKey -Name 'MUIVerb' -Value 'Convert to PNG...' -Force

$icoCommandKey = "$icoConvertKey\command"
New-Item -Path $icoCommandKey -Force | Out-Null
Set-ItemProperty -Path $icoCommandKey -Name '(Default)' -Value $command -Force

# Add context menu for WebP files specifically (Convert to PNG)
$webpBaseKey = 'HKCU:\Software\Classes\SystemFileAssociations\.webp\shell\LocalImageConverter'

New-Item -Path $webpBaseKey -Force | Out-Null
Set-ItemProperty -Path $webpBaseKey -Name 'MUIVerb' -Value 'LocalImageConverter' -Force
Set-ItemProperty -Path $webpBaseKey -Name 'SubCommands' -Value '' -Force
if (Test-Path $iconPath) {
    Set-ItemProperty -Path $webpBaseKey -Name 'Icon' -Value $iconPath -Force
}

$webpConvertKey = "$webpBaseKey\shell\ConvertToPNG"
New-Item -Path $webpConvertKey -Force | Out-Null
Set-ItemProperty -Path $webpConvertKey -Name 'MUIVerb' -Value 'Convert to PNG...' -Force

$webpCommandKey = "$webpConvertKey\command"
New-Item -Path $webpCommandKey -Force | Out-Null
Set-ItemProperty -Path $webpCommandKey -Name '(Default)' -Value $command -Force

Write-Host "Context menu installed. Restart Explorer if the menu does not appear."
