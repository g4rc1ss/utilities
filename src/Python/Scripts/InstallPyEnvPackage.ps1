$Global:CurrentPath = Split-Path $MyInvocation.MyCommand.Path

Set-Location $CurrentPath
Import-Module ".\FilterSearch.ps1"


#Nos posicionamos en la carpeta anterior a Scripts
Set-Location ..


$ubicacionActivate = SearchWithFilter -path '.\' -wordToMatch 'Activate.ps1'

if ($null -eq $ubicacionActivate) {
    Write-Error "No se encuentra el Activate en el entorno virtual, crea primero la Virtual Environment"
    exit
}

Invoke-Expression "$($ubicacionActivate.FullName)"
[bool]$isDone = $false
while (!$isDone) {
    Write-Host "Teclea el nombre del paquete que quieres instalar"
    $packageName = Read-Host

    Invoke-Expression "pip install $packageName"

    Write-Host "Quieres seguir instalando paquetes? S/n"
    $continue = Read-Host
    if ($continue.ToUpper() -ne "S") {
        $isDone = $true
    }
}

$ubicacionRequirements = SearchWithFilter -path '.\' -wordToMatch 'requirements.txt'

if ($null -eq $ubicacionRequirements) {
    Write-Host "No hay se encuentra un archivo requirements, se creara uno en la raiz"
    "" > .\requirements.txt
    $ubicacionRequirements = SearchWithFilter -path '.\' -wordToMatch 'requirements.txt'
}

foreach ($requirementsPath in $ubicacionRequirements) {
    Invoke-Expression "pip freeze > $($requirementsPath.FullName)"
}