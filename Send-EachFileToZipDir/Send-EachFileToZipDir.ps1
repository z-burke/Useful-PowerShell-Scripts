

# USER DEFINED VARIABLES
$DIR_PATH = Split-Path -Path ($MyInvocation.MyCommand.Path)
$FILTER = "asf*"

# MAIN
function Compress-FilesInPath {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $Path,

        [Parameter(Mandatory=$False)]
        [String]
        $Filter,

        [Parameter(Mandatory=$False)]
        [Switch]
        $Separate
    )
    $OriginalFiles = Get-ChildItem -Path $DIR_PATH -Filter $FILTER -Recurse
    if ($Separate) {
        $OriginalFiles | ForEach-Object { 
            $FileDir = Split-Path $_.FullName
            $DestinationPath = Join-Path $FileDir "$($_.BaseName)"
            Compress-Archive -Path $_.FullName -DestinationPath $DestinationPath -CompressionLevel Optimal -Force
            Remove-Item $_.FullName
        }
    } else {
        Compress-Archive -Path $_.FullName -DestinationPath $DestinationPath -CompressionLevel Optimal
    }
}

Compress-FilesInPath -Path $DIR_PATH -Filter $FILTER -Separate

