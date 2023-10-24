import-module au

$releases = 'https://github.com/UB-Mannheim/tesseract/wiki'

function global:au_SearchReplace {
    @{
        ".\tools\VERIFICATION.txt" = @{
          #"(?i)(\s+x32:).*"                   = "`${1} $($Latest.URL32)"
          "(?i)(\s+x64:).*"                   = "`${1} $($Latest.URL64)"
          "(?i)(Get-RemoteChecksum).*"        = "`${1} $($Latest.URL64)"
          #"(?i)(\s+checksum32:).*"            = "`${1} $($Latest.Checksum32)"
          "(?i)(\s+checksum64:).*"            = "`${1} $($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }


function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    
    $regex = '.exe$'
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href

    $version = $url -split '-|.exe' | select -Last 1 -Skip 1
    #$version = $urls[1] -split '-|.exe' | select -Last 1 -Skip 1 | % { $_.Replace('v','') }
    
    @{
        #URL32 = $urls[0]
        URL64 = $url
        #Version = "$($version.Replace('v',''))-$($alpha.Replace('.',''))"
        Version = $version
    }
}

update -ChecksumFor none
