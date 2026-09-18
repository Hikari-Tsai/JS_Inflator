#!/usr/bin/env python3
"""Package already verified macOS bundles; never install on the build machine."""
import argparse
import plistlib
import re
import shutil
import subprocess
import tempfile
from pathlib import Path
import xml.etree.ElementTree as ET


def run(*args):
    subprocess.run([str(a) for a in args], check=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--build-dir', required=True)
    parser.add_argument('--config', default='Release')
    args = parser.parse_args()
    repo = Path(__file__).resolve().parent.parent
    build = Path(args.build_dir).resolve()
    version = re.search(r'\bVERSION\s+(\d+\.\d+\.\d+\.\d+)', (repo / 'CMakeLists.txt').read_text()).group(1)
    revision = subprocess.check_output(['git', '-C', str(repo), 'rev-parse', 'HEAD'], text=True).strip()
    formats = [
        ('vst3', 'VST3', 'JS_Inflator.vst3', 'Library/Audio/Plug-Ins/VST3', 'VST3', True),
        ('au', 'VST3', 'JS_Inflator.component', 'Library/Audio/Plug-Ins/Components', 'Audio Units (AUv2)', True),
        ('aax', 'AAXPLUGIN', 'JS_Inflator.aaxplugin', 'Library/Application Support/Avid/Audio/Plug-Ins', 'AAX - Pro Tools Developer only', False),
    ]
    with tempfile.TemporaryDirectory(prefix='jsif-package-') as temp:
        work = Path(temp)
        image = work / 'image'
        image.mkdir()
        dist = ET.Element('installer-gui-script', {'minSpecVersion': '2'})
        ET.SubElement(dist, 'title').text = 'JS Inflator (Hikari)'
        ET.SubElement(dist, 'options', {'customize': 'always', 'require-scripts': 'false', 'hostArchitectures': 'x86_64,arm64'})
        ET.SubElement(dist, 'domains', {'enable_localSystem': 'true', 'enable_currentUserHome': 'false', 'enable_anywhere': 'false'})
        ET.SubElement(dist, 'welcome', {'file': 'INSTALL.txt', 'mime-type': 'text/plain'})
        ET.SubElement(dist, 'license', {'file': 'LICENSE', 'mime-type': 'text/plain'})
        outline = ET.SubElement(dist, 'choices-outline')
        for fmt, directory, name, destination, title, selected in formats:
            bundle = build / directory / args.config / name
            if not (bundle / 'Contents/MacOS/JS_Inflator').is_file():
                raise RuntimeError(f'Missing binary: {bundle}')
            run('codesign', '--verify', '--deep', '--strict', bundle)
            run('lipo', bundle / 'Contents/MacOS/JS_Inflator', '-verify_arch', 'x86_64', 'arm64')
            if any(p.is_symlink() and not p.resolve().is_relative_to(bundle) for p in bundle.rglob('*')):
                raise RuntimeError(f'External build symlink in {bundle}')
            payload = work / f'payload-{fmt}'
            target = payload / destination / name
            target.parent.mkdir(parents=True)
            run('ditto', bundle, target)
            plist = work / f'{fmt}.plist'
            run('pkgbuild', '--analyze', '--root', payload, plist)
            components = plistlib.loads(plist.read_bytes())
            for component in components:
                component['BundleIsRelocatable'] = False
                component['BundleOverwriteAction'] = 'upgrade'
            plist.write_bytes(plistlib.dumps(components))
            identifier = f'io.github.hikari-tsai.js-inflator.{fmt}'
            package = f'{fmt}.pkg'
            run('pkgbuild', '--root', payload, '--component-plist', plist,
                '--identifier', identifier, '--version', version, '--install-location', '/', work / package)
            ET.SubElement(outline, 'line', {'choice': fmt})
            choice = ET.SubElement(dist, 'choice', {'id': fmt, 'title': title, 'start_selected': str(selected).lower()})
            ET.SubElement(choice, 'pkg-ref', {'id': identifier})
            ET.SubElement(dist, 'pkg-ref', {'id': identifier, 'version': version, 'onConclusion': 'none'}).text = package
        resources = work / 'resources'
        resources.mkdir()
        shutil.copy2(repo / 'packaging/INSTALL.txt', resources / 'INSTALL.txt')
        shutil.copy2(repo / 'LICENSE', resources / 'LICENSE')
        distribution = work / 'Distribution.xml'
        ET.ElementTree(dist).write(distribution, encoding='utf-8', xml_declaration=True)
        run('productbuild', '--distribution', distribution, '--resources', resources, '--package-path', work, image / 'JS_Inflator.pkg')
        for name in ['INSTALL.txt', 'LICENSE']:
            shutil.copy2(resources / name, image / name)
        uninstall = image / 'Uninstall-JS-Inflator.command'
        shutil.copy2(repo / 'packaging/macos/Uninstall-JS-Inflator.command', uninstall)
        uninstall.chmod(0o755)
        (image / 'BUILD-SOURCE.txt').write_text(
            f'JS Inflator {version}\nRevision: {revision}\n'
            f'https://github.com/Hikari-Tsai/JS_Inflator/tree/{revision}\n'
            'Clone with recursive submodules. SDK revisions and build commands are pinned in .github/workflows.\n')
        output = build / 'JS_Inflator-macOS.dmg'
        run('hdiutil', 'create', '-ov', '-format', 'UDZO', '-fs', 'HFS+', '-volname', 'JS Inflator', '-srcfolder', image, output)
        run('hdiutil', 'verify', output)


if __name__ == '__main__':
    main()
