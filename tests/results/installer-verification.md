# Installer packaging verification

Date: 2026-09-18

- [Successful macOS and Windows packaging run](https://github.com/Hikari-Tsai/JS_Inflator/actions/runs/35350559156)
- Packaging snapshot: `8c1f1697b7debc905d4be1a50596b57ee4591d58` (temporary verification branch).
- Input plug-ins: the five published `v2.0.3.2-hikari-beta.2` ZIP assets.
- Test scope: rebuild installers from those verified bundles, then install and uninstall on disposable native runners. DSP was not recompiled for this run. The unchanged packaging scripts and smoke tests are also called after compilation in the production workflows.
- An earlier full build run (`35350160212`) was cancelled in favor of this focused packaging check; it is not reported as passed.

## macOS (`macos-15`)

Passed DMG creation and checksum verification; read-only mount; executable uninstall command; PKG installation with VST3/AU defaults and AAX initially absent; opt-in AAX upgrade; installed bundle signature verification; uninstall dry run and cancellation; actual uninstall; repeated uninstall; removal of this installer's three receipts; preservation of a neighboring sentinel file.

Output: `JS_Inflator-macOS.dmg`, containing `JS_Inflator.pkg`, `Uninstall-JS-Inflator.command`, `INSTALL.txt`, `LICENSE`, and `BUILD-SOURCE.txt`.

## Windows (`windows-2022`, Inno Setup 6.7.1)

Passed EXE compilation; VST3-only default installation; uninstall executable and registry entry creation; upgrade with AAX selected; extraction of standalone CMD/PowerShell uninstall tool; dry run and cancellation; registered installer uninstall; removal of manual ZIP installations; repeated uninstall; preservation of a neighboring sentinel file.

Outputs: `JS_Inflator-Windows-Setup.exe` and `JS_Inflator-Windows-Uninstall.zip`.

## Release and documentation

The production release shell script was exercised locally with fixture files and a fake `gh` executable. All eight asset paths were passed to release creation; making each expected asset empty independently prevented the call. No release was published by this test.

Workflow YAML parsed successfully; shell/Python syntax checks and `git diff --check` passed. Both READMEs rendered with GitHub's Markdown API. Existing beta.2 ZIP download links remain valid and no nonexistent installer download links were added to that release.

## Limits

This verifies unattended installation/removal, not installer UI interaction, DAW loading, all supported OS versions, file-in-use recovery, or Gatekeeper/SmartScreen acceptance. macOS PKG/DMG and Windows installers are unsigned; macOS plug-in bundles remain ad-hoc signed. AAX still requires licensed Pro Tools Developer. No local installed plug-ins were changed during verification.
