param([Parameter(Mandatory)][string]$BuildDir)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$build = (Resolve-Path $BuildDir).Path
$cmake = Get-Content (Join-Path $repo 'CMakeLists.txt') -Raw
if ($cmake -notmatch '\bVERSION\s+(\d+\.\d+\.\d+\.\d+)') { throw 'Missing project version' }
$version = $Matches[1]
$revision = & git -C $repo rev-parse HEAD
if ($LASTEXITCODE -ne 0) { throw 'Cannot identify source revision' }
@"
JS Inflator $version
Revision: $revision
https://github.com/Hikari-Tsai/JS_Inflator/tree/$revision
Clone with recursive submodules. SDK revisions and build commands are pinned in .github/workflows.
"@ | Set-Content (Join-Path $build 'BUILD-SOURCE.txt')
$compiler = Join-Path ${env:ProgramFiles(x86)} 'Inno Setup 6\ISCC.exe'
if (!(Test-Path $compiler)) { throw 'Inno Setup 6 compiler is required' }
& $compiler "/DPluginVersion=$version" "/DBuildDir=$build" "/DRepoDir=$repo" (Join-Path $PSScriptRoot 'installer.iss')
if ($LASTEXITCODE -ne 0) { throw "Installer compiler failed: $LASTEXITCODE" }
$files = @(
    (Join-Path $PSScriptRoot 'Uninstall-JS-Inflator.cmd'),
    (Join-Path $PSScriptRoot 'Uninstall-JS-Inflator.ps1'),
    (Join-Path $repo 'packaging\INSTALL.txt'),
    (Join-Path $repo 'LICENSE'),
    (Join-Path $build 'BUILD-SOURCE.txt')
)
Compress-Archive -LiteralPath $files -DestinationPath (Join-Path $build 'JS_Inflator-Windows-Uninstall.zip') -Force
