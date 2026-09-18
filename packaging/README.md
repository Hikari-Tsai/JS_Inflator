# Installer packaging

Packaging consumes the same complete bundles as the five existing plug-in ZIPs.
It does not compile DSP code, obtain PACE authorization, sign installers or notarize.
User-facing instructions are in [INSTALL.txt](INSTALL.txt).

## Outputs

| Platform | File | Installed formats / removal |
|---|---|---|
| macOS | `JS_Inflator-macOS.dmg` | `JS_Inflator.pkg`: VST3 + AU by default; AAX opt-in. DMG includes `Uninstall-JS-Inflator.command`. |
| Windows x64 | `JS_Inflator-Windows-Setup.exe` | VST3 by default; AAX opt-in. Inno Setup registers `unins000.exe` in Settings → Apps. |
| Windows x64 | `JS_Inflator-Windows-Uninstall.zip` | Extract the CMD and PS1 together. Runs the installed uninstaller, then removes residual/ZIP-installed bundles at fixed standard paths. |

The existing ZIPs remain available. All eight output files must exist and be nonempty
before a tag-triggered release can publish. Installer artifacts upload only after
the platform's installation smoke test succeeds. A manual run never publishes a release.

## Build

After building and verifying Release bundles (including replacing the AU's external
VST3 symlink with a complete signed bundle):

```sh
python3 packaging/build_macos.py --build-dir build-macos
```

On Windows, with Inno Setup 6 installed under Program Files (x86):

```powershell
./packaging/windows/build.ps1 -BuildDir build-windows
```

macOS uses the system `pkgbuild`, `productbuild`, and `hdiutil`; Python 3.9+ is needed
for packaging, but the shipped uninstall command uses only macOS system utilities.
PKG components disable relocation and replace old bundles at their fixed destinations.
Windows packages complete bundle directories with Inno Setup. `AppId` and the
uninstaller directory must remain stable across upgrades. Unchecking a previously
installed Windows component does not remove it; uninstall before reducing formats.

Both installers carry the project GPLv3 license, installation instructions, and the
checkout's exact Git revision in `BUILD-SOURCE.txt`. The installer version is derived
from `CMakeLists.txt`, not from a tag or user-provided workflow input.

## Verification

`macos/verify-installer.sh` and `windows/verify-installer.ps1` intentionally require
`GITHUB_ACTIONS=true` and the matching `RUNNER_OS`. They install to real system plug-in
paths only on disposable CI runners and refuse pre-existing JS Inflator installations.
Do not run these installation tests on a development machine with installed plug-ins.

The smoke tests cover default format selection, upgrading with AAX selected,
cancellation and dry runs, repeated uninstall, and preservation of a neighboring file.
macOS additionally verifies mounted DMG contents, installed signatures and package
receipt removal. Windows verifies uninstall registration and manual ZIP removal.
They do not test DAW loading, all supported OS versions, Gatekeeper or SmartScreen.

Uninstallers list their fixed targets and require `REMOVE` before requesting admin
access. `--dry-run` (macOS) / `-DryRun` (PowerShell) only display targets.
`--yes` / `-Yes` is explicit non-interactive confirmation for automation.
They preserve presets, sessions, other plug-ins, and user/custom plug-in folders.
Because upstream and fork bundles share names, removal also removes upstream copies
at these paths. Redirected parent paths are rejected; the Windows tool also rejects
reparse points inside bundles before recursively removing them.
