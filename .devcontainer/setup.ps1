function ReplaceInFile {
    Param ([string] $filename, [string] $oldText, [string] $newText)
    Write-Host("filename = $filename")
    (Get-Content -Path $filename) -replace "$oldText", "$newText" | Set-Content $filename
}

# clone the latest sample
$workspaceDir = (Get-ChildItem Env:PWD).Value

git clone https://github.com/microsoft/botframework-solutions.git $workspaceDir/va_src

git checkout deploy-skill

copy-item -Path $workspaceDir/va_src/samples/csharp/skill/SkillSample -Destination $workspaceDir/va_skill -Recurse

# update the sample scripts to run the locally installed dispatch tool
$deployCogModelScript = "$workspaceDir/va_skill/Deployment/Scripts/deploy_cognitive_models.ps1"
ReplaceInFile $deployCogModelScript 'dispatch create' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll create'
ReplaceInFile $deployCogModelScript 'dispatch init' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll init'
ReplaceInFile $deployCogModelScript 'dispatch add' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll add'
ReplaceInFile $deployCogModelScript 'dispatch refresh' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll refresh'

$updateCogModelScript = "$workspaceDir/va_skill/Deployment/Scripts/update_cognitive_models.ps1"
ReplaceInFile $updateCogModelScript 'dispatch create' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll create'
ReplaceInFile $updateCogModelScript 'dispatch init' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll init'
ReplaceInFile $updateCogModelScript 'dispatch add' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll add'
ReplaceInFile $updateCogModelScript 'dispatch refresh' 'dotnet /node_modules/botdispatch/bin/netcoreapp2.1/Dispatch.dll refresh'

$publishScript = "$workspaceDir/va_skill/Deployment/Scripts/publish.ps1"
ReplaceInFile $publishScript 'bin\\Release\\netcoreapp3.0' 'bin\\release\\netcoreapp3.0'

# prevent the telemetry prompt the first time bf cli is used
"Y" | bf