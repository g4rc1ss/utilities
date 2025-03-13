using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Diagnostics;
using System.Text;
using System.Text.RegularExpressions;
using ListadoDependencias;

var browser = new Browser();
var path = await browser.GetFilePath("/");

await Process.Start("powershell.exe", $"dotnet build \"{path}\"").WaitForExitAsync();

var directoryPath = Path.GetDirectoryName(path);
var fileName = Path.GetFileNameWithoutExtension(path);

var assetsPath = $"{directoryPath}/obj/project.assets.json";
var assetsJson = await File.ReadAllTextAsync(assetsPath);
var projectAssets = JsonConvert.DeserializeObject<JObject>(assetsJson);

var dependencyList = new Dictionary<string, List<string>>();
var targets = projectAssets["targets"];


foreach (var nodes in targets.Values())
{
    var dictDependencyKey = Regex.Replace(((dynamic)nodes.Parent).Name, @"[^a-zA-Z0-9]", "");

    var listOfDependencies = new List<string>();

    foreach (var libs in nodes)
    {
        var name = ((string)((dynamic)libs).Name).Split("/");

        listOfDependencies.Add($"<!-- Dependencia: -->");
        listOfDependencies.Add($"<package id=\"{name.First()}\" version=\"{name.Last()}\" />");

        if (libs.Values("dependencies").Children().Any())
        {
            listOfDependencies.Add($"<!-- Subdependencias: -->");
            foreach (var item in libs.Values("dependencies").Children())
            {
                listOfDependencies.Add(
                    $"<package id=\"{((dynamic)item).Name}\" version=\"{((dynamic)item).Value}\" />");
            }
        }

        listOfDependencies.Add($"<!-- ============================================================= -->");
        listOfDependencies.Add(string.Empty);
    }

    dependencyList.Add(dictDependencyKey, listOfDependencies);
}

foreach (var item in dependencyList)
{
    var list = new StringBuilder();
    list.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
    list.AppendLine("<packages>");
    foreach (var dependency in item.Value)
    {
        list.AppendLine(dependency);
    }

    list.AppendLine("</packages>");

    await File.WriteAllTextAsync(
        $"{Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)}/Downloads/{fileName}.dependencies.{item.Key}.xml",
        list.ToString());
}
