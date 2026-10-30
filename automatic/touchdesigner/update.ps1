import-module au

function global:au_SearchReplace {
  @{
    "tools\chocolateyInstall.ps1" = @{
      "(?i)^(\s*[$]?url64bit\s*=\s*)('.*')"   = "`${1}'$($Latest.URL64)'"
      "(?i)^(\s*[$]?checksum64\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum64)'"
    }
    "touchdesigner.nuspec" = @{
      "(?i)(<version>)(.*)(</version>)" = "`${1}$($Latest.Version)`$3"
    }
  }
}

function global:au_GetLatest {
  $releases = 'https://derivative.ca/download/archive'
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $url64 = $download_page.Links |
    Where-Object href -match 'TouchDesignerWebInstaller\.([0-9]{4}\.[0-9]+)\.exe' |
    Select-Object -ExpandProperty href -First 1

  if (!$url64) { throw 'Could not find TouchDesignerWebInstaller download URL on the archive page.' }

  $version64 = $url64 -replace '.*TouchDesignerWebInstaller\.([0-9]{4}\.[0-9]+)\.exe.*', '${1}'

  @{
    SoftwareName = 'TouchDesigner*'
    Version      = $version64
    URL64        = $url64
  }
}

# Let AU natively download and calculate the hash
update -ChecksumFor 64
