$path = '/'

$ubicacionArchivos = Get-ChildItem $path -Recurse -File | Sort-Object -Property LastWriteTime | Select-Object FullName, Name

$counter = 0;
foreach ($archivo in $ubicacionArchivos) {
    
    Move-Item ($archivo.FullName) ($archivo.FullName.Replace($archivo.Name, "$counter.JPG"))
    
    Write-Host "Archivo" ($archivo.FullName) "modificado"
    $counter = $counter + 1
}