param(
    [string] $arguments = $(Read-Host "input args used by dotnet new '{{args}}'")
)


function Get-Version-Info ([string] $version)
{
    $r = $version -Match "^(?<MajorVer>[\d]*)\.(?<MinorVer>[\d]*)\.(?<PatchVer>[\d]*)" ;
    if ($r) {
        return @{ 
            MajorVer=$matches['MajorVer']; 
            MinorVer=$matches['MinorVer']; 
            PatchVer=$matches['PatchVer']; 
        }
    } 
}

function Get-Current-Version {
    $v = dotnet --version;
    Get-Version-Info $v
}

# only pattern like 2.1.402  
function Get-Latest-SDK-Version{

    $sdks= dotnet --list-sdks |  
        Where-Object{ 
            $_ -Match "^(?<MajorVer>[\d]*)\.(?<MinorVer>[\d]*)\.(?<PatchVer>[\d]*)\s" 
        } | 
        ForEach-Object{ Get-Version-Info $_ } ;
    return $sdks[-1]
}


$targetVersion = Get-Latest-SDK-Version
$targetVersionString =  $targetVersion['MajorVer'] + "." + $targetVersion['MinorVer'] + "." + $targetVersion['PatchVer']
# add a `global.json`
dotnet new globaljson --sdk-version $targetVersionString

$targetVersion = Get-Current-Version

## create the project
dotnet new $arguments

# add package for code generation
$wildVersion = $targetVersion['MajorVer'] + "." + $targetVersion['MinorVer'] + "." + '*'
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design --version $wildVersion --no-restore
dotnet add package Microsoft.EntityFrameworkCore.Design --version $wildVersion --no-restore 

## As of 3.0
if($targetVersion['MajorVer'] -ge 3){
    dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version $wildVersion --no-restore 
}

## restore
dotnet restore 