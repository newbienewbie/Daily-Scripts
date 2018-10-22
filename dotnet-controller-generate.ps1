
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
$controllerName= $(Prompt-Parameter "Controller Name(without namespace)" -defaultValue "$($model)Controller")
$dcName= $(Prompt-Parameter "DbContext Name (without namespace)" -defaultValue "AppDbContext")

Write-Host "[+]set namespace:"
$rootNamespace = $( Prompt-Parameter -message "ROOT namespace" -defaultValue "App")
$controllerNamespace= $(Prompt-Parameter "namespace of Controller" -defaultValue "$rootNamespace.Controllers")
$modelNamespace = $(Prompt-Parameter "namespace of Model" -defaultValue "$rootNamespace.Models")
$dcNamespace= $(Prompt-Parameter "namespace of DbContext" -defaultValue "$rootNamespace.Data")

$modelClass = "$modelNamespace.$model"
$controllerClass = "$controllerNamespace.$controllerName"
$dcClass = "$dcNamespace.$dcName"

Write-Host $rootNameSpace
Write-Host $modelClass
Write-Host $controllerClass
Write-Host $dcClass

dotnet aspnet-codegenerator controller -m $model -dc $dcClass -name $controllerName -namespace $controllerNamespace -outDir Controllers --useDefaultLayout