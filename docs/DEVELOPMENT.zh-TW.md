# 建置、CI 與發布

[English](DEVELOPMENT.md) · [返回 README](../README.zh-TW.md)

## 本地建置

使用 CMake 3.19 以上，並取得 submodules：

```sh
git clone --recurse-submodules https://github.com/Hikari-Tsai/JS_Inflator.git
cd JS_Inflator
```

依平台 workflow 執行依賴下載與 configure 步驟；檔案內的固定版本與 SDK 路徑是重現建置的依據，完成設定後才能執行 target。

| 平台 | 工具鏈／SDK | Workflow |
| --- | --- | --- |
| macOS Universal | Xcode 16.2；VST3 SDK 3.7.12；AudioUnitSDK 1.3.0；AAX SDK 2.9.0 | [macOS Build.yml](../.github/workflows/macOS%20Build.yml) |
| Windows x64 | Visual Studio 2022；VST3 SDK 3.7.12；AAX SDK 2.9.0 | [Windows Build.yml](../.github/workflows/Windows%20Build.yml) |

AAX SDK 從 JUCE repository 的固定 revision 取得，採用其 GPLv3 授權選項，沒有連結 JUCE 模組。完整 dependency commit 與 CMake 選項請見 workflow。

| Target | 產物 |
| --- | --- |
| `JS_Inflator` | `.vst3` |
| `JS_Inflator-au` | macOS `.component`；需要 AudioUnitSDK 與 `SMTG_ENABLE_AUV2_BUILDS=ON` |
| `JS_Inflator-aax` | `.aaxplugin`；需要 `SMTG_AAX_SDK_PATH` 與 VSTGUI |

設定完成後執行 `cmake --build <build-directory> --config Release --target <target>`。要散布 AU，須沿用 workflow 的 VST3 內嵌與簽章步驟，不能保留外部開發捷徑。Bundle 版本由 `CMakeLists.txt` 設定，不會隨 Git Tag 改名。

## Actions

[Mac Build.yml](../.github/workflows/Mac%20Build.yml) 在 Actions 顯示為 **Build plug-ins**，並行呼叫兩個平台的 workflow。

| 觸發方式 | 建置／Artifacts | 自動 Release |
| --- | --- | --- |
| Pull Request 更新 | 是 | 否 |
| 推送 `main` | 是 | 否 |
| 沒有 PR 的一般 `staging` 推送 | 否 | 否 |
| 手動執行 | 是 | 否 |
| 推送新的 `v*` Tag | 是 | 雙平台成功後建立 Pre-release |

macOS 檢查通用架構與程式碼簽章，將 VST3 內嵌 AU，使用 `ditto` 打包；Windows 檢查完整 bundle 路徑與 x64 PE 標頭。兩個平台都會製作安裝包，並在一次性的 runner 執行安裝／移除測試。這些檢查不取代 DAW 功能測試，詳見[測試涵蓋範圍](../tests/results/aax-verification.md)與[安裝包驗證](../tests/results/installer-verification.md)。

CI 產生五份外掛 ZIP、macOS DMG、Windows Setup EXE、Windows Uninstall ZIP，共八份檔案。產物位於 `build-macos/` 或 `build-windows/`，上傳為 `JS_Inflator-<platform>-<format>-<commit>` Artifacts。在 [Actions](https://github.com/Hikari-Tsai/JS_Inflator/actions) → 執行紀錄 → **Artifacts** 下載；外層壓縮檔內可能還有一層 ZIP。

**CI 不執行 PACE 簽署或 Apple notarization。** 現行 beta.3 Release 與 CI 不同：macOS AAX ZIP／DMG 在本地簽署後已替換，未簽署的 Windows AAX ZIP／Setup EXE 已下架，剩六份附件。詳見[簽署狀態與校驗碼](INSTALLATION.zh-TW.md#aax-signing-status)。

## 發布

新的 `v*` Tag 選定原始碼 commit。雙平台成功後，Release job 下載同一次執行的 Artifacts，要求八份檔案齊全且非空，再以 `gh release create --verify-tag --prerelease --latest=false` 發布並套用固定文案；文案不會自動依 commit 整理更新紀錄。

任一平台失敗／取消或缺少附件都會停止發布。workflow 不會覆寫既有 Release；發布失敗可能留下部分附件，重試前應先檢查。修改原始碼通常需要新的 commit 與 Tag。將 Release 設為 **Latest** 不會簽署檔案；beta.3 是事後手動轉為正式發布。

**下次發布前，需處理本地 AAX 簽署與未簽署安裝包的下架。** 目前 workflow 仍會發布八份原始 CI 檔案；換上已簽署 AAX 時，必須一併重新打包內含該外掛的安裝程式，並保留原始碼 revision、簽章及檔案雜湊紀錄。

完成 `gh auth login` 後可使用：

```sh
gh workflow run 'Mac Build.yml' --ref staging
gh workflow run 'macOS Build.yml' --ref staging
gh workflow run 'Windows Build.yml' --ref staging
gh run list --branch staging
```

以 `gh run view <run-id> --log-failed` 檢查失敗，或用 `gh run download <run-id> --dir downloaded-artifacts` 下載產物。要發布版本時，在選定的 commit 建立尚未使用的 annotated `v*` Tag，再推送該 Tag；不要重用 beta.3。

## PR Agent

[PR Agent](../.github/workflows/pr-agent.yml) 獨立於編譯流程，在 PR 開啟／重開／更新／ready 時執行，略過 Bot，且新評論工作會取消同 PR 的舊工作。需要 repository secret `OPENAI_KEY`；編譯不使用此金鑰。Fork PR 可能無法取得評論所需的 secret／寫入權限。

設定見 [.pr_agent.toml](../.pr_agent.toml)。workflow 設定 `auto_improve: false`，但 config 為 `true`，是否產生建議需看 Action 實際解析的設定。PR Agent 失敗不代表編譯失敗。

建置工作僅有 repository 讀取權限；Release job 使用 `contents: write`；PR Agent 需要 PR／issue 寫入權限。Release 上傳使用內建 GitHub token，沒有另外設定 PAT。
