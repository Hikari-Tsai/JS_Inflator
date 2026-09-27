# Installation and AAX signing

## Installers and uninstalling

Quit all DAWs first. On macOS, mount the DMG and open `JS_Inflator.pkg`; VST3 and AU are selected by default. Use **Customize** to opt into AAX. The Windows Setup EXE has been withdrawn; install VST3 using the ZIP instructions below. Previously downloaded Windows AAX requires licensed Pro Tools Developer. Check the [macOS AAX signing status](#aax-signing-status); standard Pro Tools loading remains untested for the signed update.

- **macOS uninstall:** run `Uninstall-JS-Inflator.command` inside the DMG, type `REMOVE` and enter the administrator password. If executable permissions were lost, run `bash /path/to/Uninstall-JS-Inflator.command`. It removes the three system-wide JS Inflator bundles and this installer's package receipts.
- **Windows uninstall:** use **Settings → Apps → JS Inflator (Hikari)**, or `C:\Program Files\Hikari\JS Inflator\unins000.exe` (keep its accompanying `.dat`). For manual ZIP installs, extract the Uninstall ZIP and run `Uninstall-JS-Inflator.cmd` with the `.ps1` beside it; confirm with `REMOVE` and accept the administrator prompt. This tool also invokes the installed EXE uninstaller when present.

Installers replace JS Inflator at the standard paths, including upstream copies with the same bundle names. Back up an older bundle if needed. Removal preserves other plug-ins, presets and sessions; user-specific or custom plug-in folders are not scanned. PKG/DMG and Windows installers are unsigned and macOS packages are not notarized, so OS security checks may block launch. Packaging does not add PACE signing. [CI installer instructions](../packaging/INSTALL.txt) describe the original workflow output; the updated beta.3 macOS DMG includes its own local-signing notes.

## macOS — manual ZIP installation

1. Quit your DAW and extract the ZIP for the format you need.
2. In Finder, choose **Go → Go to Folder…** and open the destination below. Copy the entire extracted bundle there; an administrator password may be required.
3. Restart the DAW, rescan plug-ins if necessary, and insert **JS Inflator** on an audio track or bus. AU may appear under manufacturer **yg331**.

| Copy this bundle | Into this folder |
|---|---|
| `JS_Inflator.vst3` | `/Library/Audio/Plug-Ins/VST3/` |
| `JS_Inflator.component` | `/Library/Audio/Plug-Ins/Components/` |
| `JS_Inflator.aaxplugin` | `/Library/Application Support/Avid/Audio/Plug-Ins/` |

The AU download includes its VST3 implementation inside the `.component`; it does **not** need a separately installed VST3. Keep the bundle intact. macOS VST3/AU are ad-hoc signed; AAX signing varies by [version](#aax-signing-status). None are notarized. If macOS blocks loading, record the exact message when reporting the issue; a macOS code signature alone is not a PACE signature.

## Windows — manual ZIP installation

1. Quit your DAW and extract the Windows ZIP.
2. Copy the entire `JS_Inflator.vst3` **folder**, including `Contents`, to the VST3 destination below. Administrator permission may be required.
3. Restart your 64-bit DAW, rescan plug-ins if necessary, and insert **JS Inflator**. The AAX path below is a reference for existing installations only: Windows AAX is no longer offered in the Release, and earlier copies still require Pro Tools Developer.

| Copy this folder | Into this folder |
|---|---|
| `JS_Inflator.vst3` | `C:\Program Files\Common Files\VST3\` |
| `JS_Inflator.aaxplugin` | `C:\Program Files\Common Files\Avid\Audio\Plug-Ins\` |

Do not install only the binary inside `Contents/x86_64-win/` or `Contents/x64/`. These are complete plug-in bundles, not installers, and the Windows binaries are unsigned.

Installation paths follow the [Steinberg VST3 locations](https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical%2BDocumentation/Locations%2BFormat/Plugin%2BLocations.html), [Apple AU locations](https://support.apple.com/en-ie/102239), and [Avid AAX locations](https://learn-cdn.avid.com/AAX_SDK_2p1p1/Documentation/Doxygen/output/html/a00274.html).

## Updating or troubleshooting

Back up the previous plug-in and important sessions before replacing a build; verify the replacement in a test session first. To uninstall, quit the host and remove the installed bundle.

- **Not listed in the host:** check the OS/format, install location, complete bundle structure, and host scan results. Check the [signing status table](#aax-signing-status): AAX without PACE signing requires Developer builds; the signed macOS update has not yet been tested in standard Pro Tools.
- **Interface opens but meters do not move:** feed audio into the track/bus and check the host's routing, playback and bypass state. This is an effect, not a sound generator.
- **A control seems inactive:** `Curve` does not change audio at `Effect = 0`; `Phase` does not change audio at `OS = 1x`.

Report issues with the release tag, OS version, CPU, host/version, plug-in format, sample rate and reproduction steps in [Issues](https://github.com/Hikari-Tsai/JS_Inflator/issues).

<a id="aax-signing-status"></a>
## AAX signing status by version

**“PACE-signed” below refers to the AAX plug-in, not Apple Developer ID signing or notarization.** Status checked on 2026-09-27 (UTC+8).

| Release / download | macOS AAX | Windows AAX |
|---|---|---|
| [v2.0.3.2-hikari-beta.3](https://github.com/Hikari-Tsai/JS_Inflator/releases/tag/v2.0.3.2-hikari-beta.3) — current Release downloads, updated 2026-09-27 | **PACE-signed**: `JS_Inflator-macOS-AAX.zip` and the AAX inside `JS_Inflator-macOS.dmg` | **Not PACE-signed; removed**: Windows AAX ZIP and the Setup EXE containing AAX |
| beta.3 — original files downloaded before the signing update | **Not PACE-signed**: original AAX ZIP / DMG | **Not PACE-signed** |
| `v2.0.3.2-hikari-beta.2` (Release no longer exists) | Original AAX ZIP **not PACE-signed** | Original AAX ZIP **not PACE-signed** |
| `v2.0.3.2-hikari-beta.1` (Release no longer exists) | Original AAX ZIP **not PACE-signed** | Not released |
| Artifacts produced by the current Actions workflows | **Not PACE-signed** | **Not PACE-signed** |

The beta.3 macOS update was signed by **Hikari Music** using PACE wraptool 6.0.1. PACE verification and strict macOS code-signature checks passed after ZIP and installer payload extraction; Intel and Apple Silicon slices are present. The macOS identity is the **self-signed test certificate** `AAX Local Test 100Y 2026-09-27`, not Apple Developer ID. **Standard Pro Tools loading has not been tested for this signed build.** The DMG/PKG themselves remain unsigned and not notarized; macOS VST3/AU retain their ad-hoc signatures. Windows AAX and its containing EXE have been withdrawn; earlier Windows AAX downloads remain unsigned and require licensed **Pro Tools Developer**.

The Tag and filenames did not change when the two macOS Release assets were replaced. **Re-download the current Release assets if you have the original beta.3 files.** Local copies and Actions Artifacts do not update automatically. Promoting the Release to **Latest** does not sign any other files.

<details>
<summary>SHA-256 of the updated macOS Release downloads</summary>

```text
c44e33ca499e2bbf588f50f66c62462f3d784b0594f63663ee1474325036c752  JS_Inflator-macOS-AAX.zip
b6305881ea56143fd4a573c77a5112bfd91d80391a7a87d70f19defd3bdaa95f  JS_Inflator-macOS.dmg
```

</details>

[← Back to README](../README.md)
