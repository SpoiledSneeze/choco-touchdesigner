$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'touchdesigner'
  fileType               = 'exe'
  url64bit               = 'https://download.derivative.ca/TouchDesignerWebInstaller.2025.33230.exe'
  checksum64             = '2bf4fddcb8c08c25b6e043e08b11a36f65ec8bcbd647793341c29a1e1ab72c49'
  checksumType64         = 'sha256'
  silentArgs             = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes         = @(0)
  softwareName           = 'TouchDesigner*'
}

Write-Host
Write-Host "For commercial use of TouchDesigner, you need a commercial or pro license." -ForegroundColor "White"
Write-Host "See: https://www.derivative.ca/shop/" -ForegroundColor "White"
Write-Host

Install-ChocolateyPackage @packageArgs
