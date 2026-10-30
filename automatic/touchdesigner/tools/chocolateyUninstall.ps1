$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'touchdesigner'
  softwareName   = 'TouchDesigner*'
  fileType       = 'exe'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    # UninstallString may include surrounding quotes — strip them
    $packageArgs['file'] = $_.UninstallString -replace '^"|"$', ''
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$($packageArgs['packageName']) was not found in the uninstall registry. It may have already been uninstalled."
} else {
  Write-Warning "$($key.Count) entries found for '$($packageArgs['softwareName'])'. Please uninstall manually:"
  $key | ForEach-Object { Write-Warning "  - $($_.DisplayName) $($_.DisplayVersion)" }
}
