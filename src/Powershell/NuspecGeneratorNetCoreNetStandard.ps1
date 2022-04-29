###########################################################################
#  Generador Archivos nuspec a traves de proyectos netstandard y netcore  #
###########################################################################

#Version del paquete nuget a generar
$versionNuget = 6.0

# Lectura de variables de configuracion
# _________________________________________

# Nombre del archivo a generar 
$rutaNuspec = Convert-Path .

$rutaNuspec += '/Garciss.Net.Libs.nuspec'

# Ruta raiz donde localizar los archivos .csproj
$rutaCSProj = '../../src/src/'
# ruta de la ubicacion de las dll, xml y pdb, se han de configurar los proyectos para que se generen en otras ubicaciones
$rutaDLL = "../PackagesCompilaciones/" 


# Declaracion de variables para el entorno de generacion
# ___________________________________________________________

## Datos del paquete Nuget
$id = "Garciss.Net.Libs"
$title = "Garciss Net Libs"
$authors = "Asier Garcia"
$owners = "Asier Garcia"
$requireLicenseAcceptance = "false"
$description = "Librerias creadas para futuros proyectos o usos"
$repository = "https://github.com/g4rc1ss/GarcissNetLibs"


$versionEntornoCarpeta = ""
$nombreProyecto = ""
$dependencias = ""
$files = ""
#####################################################################################


try {
  # En los .csproj se almacena una etiqueta padre <ItemGroup> y dentro
  # Se ubica <PackageReference Include="Newtonsoft.Json" Version="12.0.3" />
  $ubicacionArchivos = Get-ChildItem $rutaCSProj -Recurse -Filter *.csproj -Name
  foreach ($leer in $ubicacionArchivos) {
    [xml]$xmlCsproj = Get-Content -Path ($rutaCSProj + $leer)
    $nodos = $xmlCsproj | Select-xml -XPath "//PackageReference"

    if ($null -ne $nodos) {
      foreach ($add in $nodos) {
        if (!$dependencias.Contains($add.Node.Attributes[0].Value)) {
          $dependencias += "<dependency id=""" + $add.Node.Attributes[0].Value + """ version=""" + $add.Node.Attributes[1].Value + """ exclude=""Build,Analyzers"" />`n"
        }  
      }
    }

    $versionEntornoCarpeta = ($xmlCsproj | Select-Xml -XPath "//TargetFramework").Node.InnerText
    
    $nombreProyecto = $leer.Split("\")
    $nombreProyecto = $nombreProyecto[$nombreProyecto.Lenght - 1]
    $nombreProyecto = $nombreProyecto.Replace(".csproj", "")
    if ($versionEntornoCarpeta -ne "") {
      $files += "
<file src=""" + $rutaDLL + $versionEntornoCarpeta + "/" + $nombreProyecto + ".dll"" target=""lib/$versionEntornoCarpeta/"" />
<file src=""" + $rutaDLL + $versionEntornoCarpeta + "/" + $nombreProyecto + ".pdb"" target=""lib/$versionEntornoCarpeta/"" />
<file src=""" + $rutaDLL + $versionEntornoCarpeta + "/" + $nombreProyecto + ".xml"" target=""lib/$versionEntornoCarpeta/"" />"
    }
  }

  # En los nuspec las dependencias de han de agregar como 
  # <dependency id="System.Data.SQLite.Core" version="1.0.112" exclude="Build,Analyzers" />
  # version es en minuscula!!!

  $DocumentoNuspec = "<?xml version=""1.0"" encoding=""utf-8""?>
<package xmlns=""http://schemas.microsoft.com/packaging/2013/05/nuspec.xsd"">
<metadata>
<id>" + $id + "</id>
<title>" + $title + "</title>
<version>" + $versionNuget + "</version>
<authors>" + $authors + "</authors>
<owners>" + $owners + "</owners>
<requireLicenseAcceptance>" + $requireLicenseAcceptance + "</requireLicenseAcceptance>
<description>" + $description + "</description>
<repository type=""git"" url=""" + $repository + """ />
<dependencies>
$dependencias
</dependencies>
</metadata>
<files>
$files
</files>
</package>"

  $DocumentoNuspec > $rutaNuspec

  $archivoSalidaLeido = [IO.File]::ReadAllText($rutaNuspec) -replace '\s+\r\n+', "`r`n"
  $archivoSalidaLeido > $rutaNuspec

  foreach ($leerDependencias in $dependencias.Split("`n")) {
    if (!$archivoSalidaLeido.Contains($leerDependencias)) {
      Write-Error "No se ha generado el documento correctamente" -ErrorAction Stop
    }
  }
  foreach ($leerFiles in $files.Split("`n")) {
    if (!$archivoSalidaLeido.Contains($leerFiles)) {
      Write-Error "No se ha generado el documento correctamente" -ErrorAction Stop
    }
  }
  Write-Host "El documento se ha generado correctamente"
  Write-Host $archivoSalidaLeido
}
catch {
  Write-Error $_.Exception.Message
  Write-Error "No se ha podido generar el documento correctamente, abortamos" -ErrorAction Stop
}
finally {
  # Se borran todas las variables usadas en el script
  Remove-Variable * -ErrorAction SilentlyContinue
}