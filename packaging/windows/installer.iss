; Paths and version are passed by build.ps1; installers remain unsigned.
[Setup]
AppId=Hikari.JSInflator
AppName=JS Inflator (Hikari)
AppVersion={#PluginVersion}
AppPublisher=Hikari Tsai
AppPublisherURL=https://github.com/Hikari-Tsai/JS_Inflator
DefaultDirName={autopf}\Hikari\JS Inflator
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=admin
ArchitecturesAllowed=x64os
ArchitecturesInstallIn64BitMode=x64os
MinVersion=10.0
OutputDir={#BuildDir}
OutputBaseFilename=JS_Inflator-Windows-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
LicenseFile={#RepoDir}\LICENSE
InfoBeforeFile={#RepoDir}\packaging\INSTALL.txt
UninstallDisplayName=JS Inflator (Hikari)
UninstallFilesDir={app}
CloseApplications=yes
RestartApplications=no
SetupLogging=yes

[Types]
Name: "standard"; Description: "VST3 (recommended)"
Name: "full"; Description: "VST3 + AAX (Pro Tools Developer only)"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "vst3"; Description: "VST3"; Types: standard full
Name: "aax"; Description: "AAX - licensed Pro Tools Developer required"; Types: full

[Files]
Source: "{#BuildDir}\VST3\Release\JS_Inflator.vst3\*"; DestDir: "{commoncf64}\VST3\JS_Inflator.vst3"; Components: vst3; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#BuildDir}\AAXPLUGIN\Release\JS_Inflator.aaxplugin\*"; DestDir: "{commoncf64}\Avid\Audio\Plug-Ins\JS_Inflator.aaxplugin"; Components: aax; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#RepoDir}\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RepoDir}\packaging\INSTALL.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\BUILD-SOURCE.txt"; DestDir: "{app}"; Flags: ignoreversion
