$fichero = "./Merchants.json"
$registros = 50000;

Write-Host ""

"[" > $fichero;
for ($i = 0; $i -lt $registros; $i++) {
    $coma = if ($i + 1 -eq $registros) { "" } else { "," }

    $jsonTemplate = '{{ "Value": "{0}", "Type": "Merchant", "_partitionKey": "Merchant"}}{1}'
    $json = $jsonTemplate -f $i.ToString("D9"), $coma
    $json >> $fichero
    
    Write-Host -NoNewline "`r$($i * 100 / $registros)%"
}

"]" >> $fichero; 