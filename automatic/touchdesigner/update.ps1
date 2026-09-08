import-module au

function global:au_SearchReplace {
  @{
    "tools\chocolateyInstall.ps1" = @{
      "(?i)^(\s*[$]?url64bit\s*=\s*)('.*')"       = "`$1'$($Latest.URL64)'"
      "(?i)^(\s*[$]?checksum64\s*=\s*)('.*')"     = "`$1'$(Get-RemoteChecksum $Latest.URL64)'"
      "(?i)^(\s*[$]?packageName\s*=\s*)'.*'"      = "`$1'$($Latest.PackageName)'"
      "(?i)^(\s*[$]?softwareName\s*=\s*)'.*'"     = "`$1'$($Latest.SoftwareName)'"
    }
    "touchdesigner.nuspec" = @{
      "(?i)(<version>)(.*?)(</version>)" = "`$1$($Latest.Version)`$3"
    }
  }
}

function global:au_GetLatest {
  # Scrape the main download page to ensure we get the absolute latest official release
  # We look for the WebInstaller specifically since it is much smaller for Chocolatey to handle
  $releases = 'https://derivative.ca/download/archive'
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  
  # Find the first WebInstaller link
  $url64 = $download_page.Links | Where-Object href -match 'TouchDesignerWebInstaller\.([0-9]{4}\.[0-9]+)\.exe' | Select-Object -ExpandProperty href -First 1
  
  # Extract the version number
  $version64 = $url64 -replace '.*TouchDesignerWebInstaller\.([0-9]{4}\.[0-9]+)\.exe.*', '$1'

  @{
    SoftwareName = 'TouchDesigner*'
    Version      = $version64
    URL64        = $url64
  }
}

update -ChecksumFor none
