
param (
    [string]$model = $(Read-Host "Model Name(without namespace)")
)

if( [string]::IsNullOrEmpty($model) ) {
    Write-Host "you need specify the model name (without a namespace)"
    exit
}

function Prompt-Parameter{
    param (
        [Parameter(Mandatory=$true)] [string] $message,
        $defaultValue
    )

    $result = Read-Host "Press enter $message (default value ['$defaultValue'])" 
    if([String]::IsNullOrEmpty($result) )
    {
        $result = $defaultValue
    }

    return $result
}

Write-Host "[+]set class name:"

$dcName= $(Prompt-Parameter "DbContext Name (without namespace)" -defaultValue "AppDbContext")


Write-Host "[+]set namespace:"

$rootNamespace = $(Prompt-Parameter -message "ROOT namespace" -defaultValue "App")
$modelNamespace = $(Prompt-Parameter "namespace of Model" -defaultValue "$rootNamespace.Models")
$modelClass = "$modelNamespace.$model"

$dcNamespace= $(Prompt-Parameter "namespace of DbContext" -defaultValue "$rootNamespace.Data")
$modelClass = "$modelNamespace.$model"
$controllerClass = "$controllerNamespace.$controllerName"
$dcClass = "$dcNamespace.$dcName"
$pageModelNamespace= $(Prompt-Parameter "namespace of PageModel" -defaultValue "$rootNamespace.Pages.$model")

Write-Host $rootNameSpace
Write-Host $modelClass
Write-Host $dcClass


Write-Host "[+]set out dir:"

$defaultOutDir = $("Pages\" + $model)
$outDir= $(Prompt-Parameter "OutDir Path(relative to project folder, use '\' instead '/' as separator)" -defaultValue $defaultOutDir )

dotnet aspnet-codegenerator razorpage -m $model -dc $dcClass --useDefaultLayout -outDir $outDir --namespaceName $pageModelNamespace
