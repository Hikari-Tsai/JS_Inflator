#!/bin/bash
set -euo pipefail
# Only the system-wide JS Inflator bundles are removed; presets and sessions stay.
mode="${1:-}"
case "$mode" in ''|--yes|--dry-run) ;; *) echo "Usage: $0 [--dry-run|--yes]"; exit 2;; esac
bundles=(
  '/Library/Audio/Plug-Ins/VST3/JS_Inflator.vst3'
  '/Library/Audio/Plug-Ins/Components/JS_Inflator.component'
  '/Library/Application Support/Avid/Audio/Plug-Ins/JS_Inflator.aaxplugin'
)
echo 'Close all DAWs before uninstalling JS Inflator.'
echo 'This removes these bundles, including any upstream version at the same paths:'
printf '  %s\n' "${bundles[@]}"
echo 'Presets, sessions, and other plug-ins are preserved.'
if [[ "$mode" == --dry-run ]]; then exit 0; fi
if [[ "$mode" != --yes ]]; then
  read -r -p 'Remove JS Inflator? Type REMOVE to continue: ' reply
  [[ "$reply" == REMOVE ]] || { echo 'Cancelled.'; exit 0; }
fi
# Reject redirected parent directories before obtaining privileges or deleting.
for bundle in "${bundles[@]}"; do
  parent="$(dirname "$bundle")"
  while [[ "$parent" != / ]]; do
    [[ ! -L "$parent" ]] || { echo "Refusing symlink parent: $parent" >&2; exit 1; }
    parent="$(dirname "$parent")"
  done
done
sudo -v
for bundle in "${bundles[@]}"; do
  if [[ -e "$bundle" || -L "$bundle" ]]; then sudo rm -rf -- "$bundle"; fi
done
for format in vst3 au aax; do
  receipt="io.github.hikari-tsai.js-inflator.${format}"
  if pkgutil --pkg-info "$receipt" >/dev/null 2>&1; then sudo pkgutil --forget "$receipt" >/dev/null; fi
done
echo 'JS Inflator removed. Restart your DAW and rescan plug-ins if needed.'
