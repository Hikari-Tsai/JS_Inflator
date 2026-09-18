param([switch]$Yes, [switch]$DryRun)
$ErrorActionPreference = 'Stop'
try {
    if (![Environment]::Is64BitOperatingSystem) { throw '64-bit Windows is required.' }
    # Registry64 is independent of whether launched by 32-bit or 64-bit PowerShell.
    $machine = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', 'Registry64')
    $current = $machine.OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion')
    $common = $current.GetValue('CommonFilesDir')
    $programs = $current.GetValue('ProgramFilesDir')
    $current.Dispose()
    $machine.Dispose()
    if (!$common -or !$programs) { throw 'Unable to resolve standard installation paths.' }
    $bundles = @(
        (Join-Path $common 'VST3\JS_Inflator.vst3'),
        (Join-Path $common 'Avid\Audio\Plug-Ins\JS_Inflator.aaxplugin')
    )
    $native = Join-Path $programs 'Hikari\JS Inflator\unins000.exe'
    Write-Host 'Close all DAWs. This removes JS Inflator, including upstream copies at these paths:'
    $bundles | ForEach-Object { Write-Host "  $_" }
    Write-Host 'Presets, sessions and other plug-ins are preserved.'
    if ($DryRun) { exit 0 }
    if (!$Yes -and (Read-Host 'Type REMOVE to continue') -cne 'REMOVE') { Write-Host 'Cancelled.'; exit 0 }
    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $arguments = '-NoProfile -ExecutionPolicy Bypass -File "{0}" -Yes' -f $PSCommandPath
        $child = Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments -Wait -PassThru
        exit $child.ExitCode
    }
    # Refuse junctions/symlinks in both ancestors and bundle contents.
    function Assert-PlainPath([string]$Target) {
        $itemPath = $Target
        while ($itemPath) {
            if (Test-Path -LiteralPath $itemPath) {
                $item = Get-Item -LiteralPath $itemPath -Force
                if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Refusing redirected path: $itemPath" }
            }
            $itemPath = Split-Path -Path $itemPath -Parent
        }
    }
    foreach ($target in @($native) + $bundles) { Assert-PlainPath $target }
    foreach ($bundle in $bundles) {
        if (!(Test-Path -LiteralPath $bundle)) { continue }
        $pending = New-Object 'System.Collections.Generic.Stack[string]'
        $pending.Push($bundle)
        while ($pending.Count) {
            foreach ($item in Get-ChildItem -LiteralPath $pending.Pop() -Force) {
                if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Refusing redirected bundle content: $($item.FullName)" }
                if ($item.PSIsContainer) { $pending.Push($item.FullName) }
            }
        }
    }
    if (Test-Path -LiteralPath $native -PathType Leaf) {
        $process = Start-Process -FilePath $native -ArgumentList '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART' -Wait -PassThru
        if ($process.ExitCode -ne 0) { throw "Installer uninstaller failed: $($process.ExitCode)" }
    }
    foreach ($bundle in $bundles) {
        if (Test-Path -LiteralPath $bundle) { Remove-Item -LiteralPath $bundle -Recurse -Force }
    }
    Write-Host 'JS Inflator removed. Restart your DAW and rescan if needed.'
    exit 0
} catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
