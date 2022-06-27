# $ubicacionDirectorios = Get-ChildItem $rutaArchivosToChange -Recurse -Directory | Where-Object Name -match '^[0-9][^0-9]'
# foreach ($directorio in $ubicacionDirectorios) {

#     Move-Item ($directorio.FullName) ($directorio.FullName.Replace($directorio.Name, '0' + $directorio.Name))

#     Write-Host "Directorio" ($directorio.FullName) "modificado"
# }