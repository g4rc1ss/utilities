$ubicacionDirectorios = Get-ChildItem . -Recurse -Directory | Select-Object FullName

foreach ($directorio in $ubicacionDirectorios) {
    $directory = Get-ChildItem -Hidden $directorio.FullName -Filter ".git" | Select-Object Name, FullName

    if ($directory.Name -eq ".git") {
        Write-Host $directory.FullName
        Remove-Item -Recurse -Force $directory.FullName
    }
}