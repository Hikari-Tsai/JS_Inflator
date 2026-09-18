param([Parameter(Mandatory)][string]$BuildDir)
$ErrorActionPreference = 'Stop'
if ($env:GITHUB_ACTIONS -ne 'true' -or $env:RUNNER_OS -ne 'Windows') { throw 'Disposable CI runner required' }
$build = (Resolve-Path $BuildDir).Path
$common = [Environment]::GetFolderPath('CommonProgramFiles')
$vst = Join-Path $common 'VST3\JS_Inflator.vst3'
$aax = Join-Path $common 'Avid\Audio\Plug-Ins\JS_Inflator.aaxplugin'
$app = Join-Path $env:ProgramFiles 'Hikari\JS Inflator'
$registry = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Hikari.JSInflator_is1'
foreach ($path in @($vst, $aax, $app, $registry)) {
    if (Test-Path -LiteralPath $path) { throw "Pre-existing install: $path" }
}
$sentinel = Join-Path $common 'VST3\JSIF-CI-Other-Plugin.txt'
New-Item -ItemType Directory -Path (Split-Path $sentinel) -Force | Out-Null
Set-Content $sentinel 'preserve'
$setup = Join-Path $build 'JS_Inflator-Windows-Setup.exe'
function Install-Plugin([string]$Type) {
    $process = Start-Process $setup -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /TYPE=$Type" -Wait -PassThru
    if ($process.ExitCode -ne 0) { throw "Installer failed: $($process.ExitCode)" }
}
Install-Plugin 'standard'
if (!(Test-Path "$vst\Contents\x86_64-win\JS_Inflator.vst3") -or (Test-Path $aax)) { throw 'Default component selection is wrong' }
if (!(Test-Path "$app\unins000.exe") -or !(Test-Path $registry)) { throw 'Missing registered uninstaller' }
Install-Plugin 'full'
if (!(Test-Path "$aax\Contents\x64\JS_Inflator.aaxplugin")) { throw 'AAX opt-in failed' }
$unpack = Join-Path $build 'uninstall-smoke'
Expand-Archive (Join-Path $build 'JS_Inflator-Windows-Uninstall.zip') $unpack -Force
$script = Join-Path $unpack 'Uninstall-JS-Inflator.ps1'
if (!(Test-Path (Join-Path $unpack 'Uninstall-JS-Inflator.cmd'))) { throw 'Missing CMD launcher' }
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script -DryRun
if ($LASTEXITCODE -ne 0) { throw 'Uninstall dry run failed' }
'NO' | & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script
if ($LASTEXITCODE -ne 0 -or !(Test-Path $vst)) { throw 'Cancellation failed' }
function Remove-Plugin {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script -Yes
    if ($LASTEXITCODE -ne 0) { throw 'Uninstall failed' }
    foreach ($path in @($vst, $aax, $registry)) {
        if (Test-Path -LiteralPath $path) { throw "Uninstall left $path" }
    }
    if ((Get-Content $sentinel) -ne 'preserve') { throw 'Other plug-in was affected' }
}
Remove-Plugin
# Earlier ZIP installations do not have an Inno Setup uninstall record.
foreach ($entry in @(@('VST3',$vst), @('AAX',$aax))) {
    Expand-Archive (Join-Path $build "JS_Inflator-Windows-$($entry[0]).zip") (Split-Path $entry[1]) -Force
}
Remove-Plugin
Remove-Plugin
Remove-Item $sentinel
Write-Host 'EXE install, AAX opt-in upgrade, registered/ZIP uninstall, cancellation and idempotence passed.'
