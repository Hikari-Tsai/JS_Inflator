#!/bin/bash
set -euo pipefail
# This smoke test installs/removes real bundles only on a disposable CI runner.
[[ "${GITHUB_ACTIONS:-}" == true && "${RUNNER_OS:-}" == macOS ]] || { echo 'CI runner required' >&2; exit 2; }
bundles=(
  '/Library/Audio/Plug-Ins/VST3/JS_Inflator.vst3'
  '/Library/Audio/Plug-Ins/Components/JS_Inflator.component'
  '/Library/Application Support/Avid/Audio/Plug-Ins/JS_Inflator.aaxplugin'
)
for bundle in "${bundles[@]}"; do
  [[ ! -e "$bundle" && ! -L "$bundle" ]] || { echo "Pre-existing bundle: $bundle" >&2; exit 1; }
done
work=$(mktemp -d)
mount="$work/mount"
mkdir "$mount"
trap 'hdiutil detach "$mount" >/dev/null 2>&1 || true' EXIT
hdiutil attach "$1" -readonly -nobrowse -mountpoint "$mount"
test -s "$mount/JS_Inflator.pkg"
test -x "$mount/Uninstall-JS-Inflator.command"
sentinel='/Library/Audio/Plug-Ins/VST3/JSIF-CI-Other-Plugin.txt'
sudo mkdir -p /Library/Audio/Plug-Ins/VST3
printf 'preserve\n' | sudo tee "$sentinel" >/dev/null
sudo installer -pkg "$mount/JS_Inflator.pkg" -target /
test -f "${bundles[0]}/Contents/MacOS/JS_Inflator"
test -f "${bundles[1]}/Contents/Resources/plugin.vst3/Contents/MacOS/JS_Inflator"
test ! -e "${bundles[2]}"
# Explicit AAX opt-in and upgrade over the existing VST3/AU installation.
cat > "$work/choices.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><array><dict>
<key>choiceIdentifier</key><string>aax</string>
<key>choiceAttribute</key><string>selected</string>
<key>attributeSetting</key><integer>1</integer>
</dict></array></plist>
PLIST
sudo installer -pkg "$mount/JS_Inflator.pkg" -target / -applyChoiceChangesXML "$work/choices.plist"
for bundle in "${bundles[@]}"; do codesign --verify --deep --strict "$bundle"; done
bash "$mount/Uninstall-JS-Inflator.command" --dry-run
printf 'NO\n' | bash "$mount/Uninstall-JS-Inflator.command"
for bundle in "${bundles[@]}"; do test -d "$bundle"; done
bash "$mount/Uninstall-JS-Inflator.command" --yes
bash "$mount/Uninstall-JS-Inflator.command" --yes
for bundle in "${bundles[@]}"; do test ! -e "$bundle"; done
for format in vst3 au aax; do
  if pkgutil --pkg-info "io.github.hikari-tsai.js-inflator.$format" >/dev/null 2>&1; then exit 1; fi
done
test "$(cat "$sentinel")" = preserve
sudo rm "$sentinel"
echo 'DMG mount, default install, AAX opt-in upgrade, signatures, cancellation and uninstall passed.'
