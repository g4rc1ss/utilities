$ubicacionDirectorios = Get-ChildItem . -Recurse -Directory | Select-Object FullName |
    Where-Object { $_.FullName -match '.*\\(bin|obj)$' } |
    Sort-Object { $_.FullName.Length } -Descending
    Select-Object FullName

$i = 0
Write-Host "$($ubicacionDirectorios.Count) Carpetas a eliminar"

foreach ($directorio in $ubicacionDirectorios) {
    if ($directorio.FullName.Contains("bin") -or $directorio.FullName.Contains("obj")) {
        Remove-Item -Recurse -Force $directorio.FullName
    }

    $i += 1
    Write-Host -NoNewline "`r$($i * 100 / $ubicacionDirectorios.Count)%"
}