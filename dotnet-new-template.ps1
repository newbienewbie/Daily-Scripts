param(
    [string] $arguments = $(Read-Host "input args used by dotnet new '{{args}}'")
)


# only pattern like 2.1.402  
function Get-Latest-SDK-Version{

    $sdks= dotnet --list-sdks |  
    Where-Object{ 
        $_ -Match "^(?<MajorVer>[\d]*)\.(?<MinorVer>[\d]*)\.(?<PatchVer>[\d]*)\s" 
    } | 
    ForEach-Object{
        @{ 
            MajorVer=$matches['MajorVer']; 
            MinorVer=$matches['MinorVer']; 
            PatchVer=$matches['PatchVer']; 
        }
    } 
    return $sdks[-1]
}




$latestSdkVersion = Get-Latest-SDK-Version
$latestSdkVersionString =  $latestSdkVersion['MajorVer'] + "." + $latestSdkVersion['MinorVer'] + "." + $latestSdkVersion['PatchVer']
# add `global.json`
dotnet new globaljson --sdk-version $latestSdkVersionString


dotnet new $arguments

$wildVersion = $latestSdkVersion['MajorVer'] + "." + $latestSdkVersion['MinorVer'] + "." + '*'

# add package for code generation
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design --version $wildVersion
dotnet add package Microsoft.EntityFrameworkCore.Design --version $wildVersion # as for 2.2

# dotnet restore 