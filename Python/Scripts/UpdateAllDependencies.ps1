$Global:CurrentPath = Split-Path $MyInvocation.MyCommand.Path

Set-Location $CurrentPath
Import-Module ".\FilterSearch.ps1"


#Nos posicionamos en la carpeta anterior a Scripts
Set-Location ..

$ubicacionActivate = SearchWithFilter -path '.\' -wordToMatch 'Activate.ps1'
Invoke-Expression "$($ubicacionActivate.FullName)"

$ubicacionRequirements = SearchWithFilter -path '.\' -wordToMatch 'requirements.txt'


if ($null -eq $ubicacionRequirements) {
    Write-Error "No se encuentra el archivo requirements.txt"
    exit
}

foreach ($requirementsPath in $ubicacionRequirements) {
    $textoRequirements = [IO.FILE]::ReadAllText($requirementsPath.FullName);

    $dependenciesToUpdate = $textoRequirements.Split("`n")
    foreach ($package in $dependenciesToUpdate) {
        Invoke-Expression "pip install -U $($package.Split("==")[0])"
    }
    Invoke-Expression "pip freeze > $($requirementsPath.FullName)"
}