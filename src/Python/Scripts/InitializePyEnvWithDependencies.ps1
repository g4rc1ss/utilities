$Global:CurrentPath = Split-Path $MyInvocation.MyCommand.Path

Set-Location $CurrentPath
Import-Module ".\FilterSearch.ps1"


#Nos posicionamos en la carpeta anterior a Scripts
Set-Location ..


$ubicacionActivate = SearchWithFilter -path '.\' -wordToMatch 'Activate.ps1'
$ubicacionRequirements = SearchWithFilter -path '.\' -wordToMatch 'requirements.txt'

if ($null -eq $ubicacionActivate) {
    Write-Error "No se encuentra el pip en una maquina virtual, crea primero la Virtual Environment"

    Write-Output "Quieres crear la maquina virtual? [S]i o [N]o (por defecto es S):"
    $opcionVM = Read-Host
    if ('' -eq $opcionVM -or $opcionVM.ToUpper().Contains('S')) {
        python -m venv "env"
        $ubicacionActivate = SearchWithFilter -path '.\' -wordToMatch 'Activate.ps1'
    }
    else {
        exit
    }
}

if ($null -eq $ubicacionRequirements) {
    Write-Error "No se encuentra el archivo requirements.txt"
    exit
}


Invoke-Expression "$($ubicacionActivate.FullName)"

foreach ($requirementsPath in $ubicacionRequirements) {
    Invoke-Expression "pip install -r $($requirementsPath.FullName)"
}