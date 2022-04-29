$SolutionName = "Advent-of-code-2015.sln"

# Delete the existing solution if it exists
if (Test-Path $SolutionName)
{
    Remove-Item $SolutionName
}

# Create the new solution
dotnet new sln --name $([System.IO.Path]::GetFileNameWithoutExtension($SolutionName))

# Populate it with all *\$type\*.csproj projects
foreach ($f in Get-ChildItem -Recurse -Filter *.csproj)
{
    dotnet sln $SolutionName add --in-root $f.FullName
}