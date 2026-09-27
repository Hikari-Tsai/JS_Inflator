# Build, CI and release

[繁體中文](DEVELOPMENT.zh-TW.md) · [Back to README](../README.md)

## Local build

Use CMake 3.19+ and clone with submodules:

```sh
git clone --recurse-submodules https://github.com/Hikari-Tsai/JS_Inflator.git
cd JS_Inflator
```

Follow the dependency checkout and configure steps in the platform workflow. They are the source of truth for a reproducible build; CMake configuration needs the SDK paths before invoking a target.

| Platform | Toolchain / SDKs | Workflow |
| --- | --- | --- |
| macOS Universal | Xcode 16.2; VST3 SDK 3.7.12; AudioUnitSDK 1.3.0; AAX SDK 2.9.0 | [macOS Build.yml](../.github/workflows/macOS%20Build.yml) |
| Windows x64 | Visual Studio 2022; VST3 SDK 3.7.12; AAX SDK 2.9.0 | [Windows Build.yml](../.github/workflows/Windows%20Build.yml) |

AAX SDK is fetched from a pinned JUCE repository revision under its GPLv3 option. No JUCE modules are linked. Exact dependency commits and CMake options are in the workflows.

| Target | Bundle |
| --- | --- |
| `JS_Inflator` | `.vst3` |
| `JS_Inflator-au` | macOS `.component`; requires AudioUnitSDK and `SMTG_ENABLE_AUV2_BUILDS=ON` |
| `JS_Inflator-aax` | `.aaxplugin`; requires `SMTG_AAX_SDK_PATH` and VSTGUI |

After configuration, use `cmake --build <build-directory> --config Release --target <target>`. Distributable AU bundles need the workflow's VST3 embedding/signing steps; an external development symlink is not portable. Bundle version is set in `CMakeLists.txt`, independently of the Git Tag.

## Actions

[Mac Build.yml](../.github/workflows/Mac%20Build.yml), displayed as **Build plug-ins**, calls the two platform workflows in parallel.

| Trigger | Build / Artifacts | Automatic Release |
| --- | --- | --- |
| Pull request updates | Yes | No |
| Push to `main` | Yes | No |
| Ordinary `staging` push without a PR | No | No |
| Manual dispatch | Yes | No |
| Push a new `v*` Tag | Yes | Pre-release after both platforms succeed |

macOS checks universal architectures and code signatures, embeds VST3 inside AU, and packages with `ditto`. Windows checks complete bundle paths and x64 PE headers. Both build installers and run install/uninstall smoke tests on disposable runners. These checks do not replace DAW functional tests; see [test coverage](../tests/results/aax-verification.md) and [installer verification](../tests/results/installer-verification.md).

CI produces five plug-in ZIPs, a macOS DMG, Windows Setup EXE and Windows Uninstall ZIP. Files live in `build-macos/` or `build-windows/` and are uploaded as `JS_Inflator-<platform>-<format>-<commit>` Artifacts. Download via [Actions](https://github.com/Hikari-Tsai/JS_Inflator/actions) → run → **Artifacts**; the outer download archive may contain another ZIP.

**CI does not perform PACE signing or Apple notarization.** The current beta.3 Release differs from CI: its macOS AAX ZIP / DMG were replaced after local signing, and its unsigned Windows AAX ZIP / Setup EXE were removed. Six Release assets remain. See [signing status and checksums](INSTALLATION.md#aax-signing-status).

## Publishing

A new `v*` Tag selects a source commit. After both builds succeed, the release job downloads artifacts from that same run, requires eight nonempty files, then runs `gh release create --verify-tag --prerelease --latest=false` with the configured notes template. That template does not generate a changelog from commits.

Failed/cancelled platform jobs or missing assets prevent publication. An existing Release is not overwritten by this workflow; a failed publication may leave partial uploads, so inspect it before retrying. New source fixes normally require a new commit and Tag. Signing does not happen by marking a Release **Latest**; beta.3 was promoted manually.

**Before publishing another version, account for local AAX signing and removal of unsigned packages.** The present workflow still publishes all eight original CI files. Uploading signed AAX requires rebuilding any installer that contains it; preserve the source revision, signatures and hashes.

Useful commands after `gh auth login`:

```sh
gh workflow run 'Mac Build.yml' --ref staging
gh workflow run 'macOS Build.yml' --ref staging
gh workflow run 'Windows Build.yml' --ref staging
gh run list --branch staging
```

Use `gh run view <run-id> --log-failed` to inspect failures and `gh run download <run-id> --dir downloaded-artifacts` to fetch files. For a release, create an unused annotated `v*` Tag on the intended commit and push that Tag. Do not reuse beta.3.

## PR Agent

[PR Agent](../.github/workflows/pr-agent.yml) runs independently on PR open/reopen/update/ready events, skips bot senders and cancels older reviews for the same PR. It needs repository secret `OPENAI_KEY`; build jobs do not. PRs from forks may lack the secrets/write permissions needed for review.

Settings live in [.pr_agent.toml](../.pr_agent.toml). The workflow sets `auto_improve: false`, while the config sets it to `true`; consult the action's resolved settings before assuming suggestions are disabled. A PR Agent failure is separate from a build failure.

Build jobs have read-only repository access. The release job uses `contents: write`; PR Agent requests PR/issue write access. The built-in GitHub token handles release uploads; no extra PAT is configured.
