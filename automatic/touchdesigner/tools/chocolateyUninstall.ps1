$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'touchdesigner'
  softwareName  = 'TouchDesigner*'
  fileType      = 'exe'
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $packageArgs['file'] = "$($_.UninstallString)"
    Uninstall-ChocolateyPackage @packageArgs
  }
  $uninstalled = $true
} elseif ($key.Count -eq 0) {
  Write-Warning "$($packageArgs['packageName']) was not found in the uninstall registry. Skipping uninstall."
} else {
  Write-Warning "$($key.Count) matches found for '$($packageArgs['softwareName'])'. Please uninstall manually."
  $key | ForEach-Object { Write-Warning " - $($_.DisplayName) $($_.DisplayVersion)" }
}
