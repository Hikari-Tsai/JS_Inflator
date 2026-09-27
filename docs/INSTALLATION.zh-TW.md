# 安裝與 AAX 簽署

## 使用安裝程式與解除安裝

先關閉所有 DAW。macOS 掛載 DMG 後開啟 `JS_Inflator.pkg`，預設勾選 VST3 與 AU；在 **Customize／自訂** 勾選 AAX。Windows Setup EXE 已下架，請依下方 ZIP 方法安裝 VST3。先前下載的未簽署 Windows AAX 仍需要已授權的 Pro Tools Developer；macOS AAX 請先確認[簽署狀態](#aax-signing-status)，目前已簽署版的標準版 Pro Tools 載入仍待實測。

- **macOS 解除安裝：** 執行 DMG 內的 `Uninstall-JS-Inflator.command`，輸入 `REMOVE` 確認，再輸入管理員密碼。若執行權限遺失，可改用 `bash /path/to/Uninstall-JS-Inflator.command`。工具會刪除系統路徑內三種 JS Inflator bundle，以及本安裝程式的 package receipts。
- **Windows 解除安裝：** 使用「**設定 → 應用程式 → JS Inflator (Hikari)**」，或執行 `C:\Program Files\Hikari\JS Inflator\unins000.exe`（需保留旁邊的 `.dat`）。之前使用 ZIP 安裝者，可解壓 Uninstall ZIP，保留 `.cmd` 與 `.ps1` 在同一目錄，執行 `Uninstall-JS-Inflator.cmd`，輸入 `REMOVE` 並同意管理員提示；若存在 EXE 安裝紀錄，工具也會先執行其解除安裝程式。

安裝會取代標準路徑內同名的 JS Inflator，包括上游版本；需要保留舊版時請先備份 bundle。解除安裝會保留其他外掛、預設檔與 Session，不掃描使用者個人或自訂外掛目錄。PKG／DMG 與 Windows 安裝程式未簽章，macOS 套件尚未 notarize，系統安全檢查可能阻擋啟動；打包不會增加 PACE 簽章。[CI 安裝包說明](../packaging/INSTALL.txt)適用於 workflow 原始產物；beta.3 更新後的 macOS DMG 另附本地簽署說明。

## macOS — 手動 ZIP 安裝

1. 關閉 DAW，解壓縮所需格式的 ZIP。
2. 在 Finder 選擇「**前往 → 前往檔案夾⋯**」，開啟下表目的地，將解壓後的完整 bundle 複製進去；系統可能要求管理員密碼。
3. 重啟 DAW，必要時重新掃描外掛，再於音軌或 bus 插入 **JS Inflator**。AU 可能列在製造商 **yg331** 下。

| 要複製的 bundle | 目的資料夾 |
|---|---|
| `JS_Inflator.vst3` | `/Library/Audio/Plug-Ins/VST3/` |
| `JS_Inflator.component` | `/Library/Audio/Plug-Ins/Components/` |
| `JS_Inflator.aaxplugin` | `/Library/Application Support/Avid/Audio/Plug-Ins/` |

AU 下載檔已在 `.component` 內嵌入 VST3 實作，**不需另外安裝 VST3**，請保留整個 bundle。macOS VST3／AU 採 ad-hoc 簽章；AAX 簽署依[版本](#aax-signing-status)而異，目前都尚未 notarize。若被 macOS 攔截，回報問題時請附上完整錯誤訊息；一般 macOS 簽章不等於 PACE 簽章。

## Windows — 手動 ZIP 安裝

1. 關閉 DAW，解壓縮 Windows ZIP。
2. 將完整 `JS_Inflator.vst3` **資料夾**，連同其中的 `Contents`，複製到下表 VST3 目的地；可能需要管理員權限。
3. 重啟 64 位元 DAW，必要時重新掃描外掛，插入 **JS Inflator**。下表 AAX 路徑僅供既有安裝參考；目前 Release 不再提供 Windows AAX，其舊檔仍需 Pro Tools Developer。

| 要複製的資料夾 | 目的資料夾 |
|---|---|
| `JS_Inflator.vst3` | `C:\Program Files\Common Files\VST3\` |
| `JS_Inflator.aaxplugin` | `C:\Program Files\Common Files\Avid\Audio\Plug-Ins\` |

不要只複製 `Contents/x86_64-win/` 或 `Contents/x64/` 內最深層的二進位檔。下載提供的是完整外掛 bundle，不是安裝程式；Windows 二進位尚未簽章。

安裝位置依據 [Steinberg VST3 文件](https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical%2BDocumentation/Locations%2BFormat/Plugin%2BLocations.html)、[Apple AU 文件](https://support.apple.com/en-ie/102239)及 [Avid AAX 文件](https://learn-cdn.avid.com/AAX_SDK_2p1p1/Documentation/Doxygen/output/html/a00274.html)。

## 更新與問題排查

替換版本前，先備份舊外掛與重要 session，並用測試專案確認新版。移除時先關閉宿主，再刪除已安裝的 bundle。

- **宿主找不到外掛：** 確認作業系統／格式、安裝路徑、bundle 是否完整，以及宿主的掃描結果。先對照[簽署狀態表](#aax-signing-status)：未經 PACE 簽署的 AAX 需要 Developer 版；已簽署的 macOS 更新檔尚未完成標準版 Pro Tools 實測。
- **介面能開，但電表沒有動：** 確認音軌／bus 有音訊輸入，檢查宿主路由、播放狀態與 bypass。這是效果器，不會自行產生聲音。
- **旋鈕似乎無效：** `Effect = 0` 時，`Curve` 不會改變音訊；`OS = 1x` 時，`Phase` 不會改變音訊。

請在 [Issues](https://github.com/Hikari-Tsai/JS_Inflator/issues) 附上版本 Tag、作業系統版本、CPU、宿主與版本、外掛格式、取樣率及重現步驟。

<a id="aax-signing-status"></a>
## 各版本 AAX 簽署狀態

**下表的「PACE 簽署」指 AAX 外掛簽章，不代表 Apple Developer ID 簽章或 notarization。** 狀態核對日期：2026-09-27（UTC+8）。

| 版本／下載來源 | macOS AAX | Windows AAX |
|---|---|---|
| [v2.0.3.2-hikari-beta.3](https://github.com/Hikari-Tsai/JS_Inflator/releases/tag/v2.0.3.2-hikari-beta.3) — 2026-09-27 更新後的現行 Release 下載檔 | **已 PACE 簽署**：`JS_Inflator-macOS-AAX.zip`，以及 `JS_Inflator-macOS.dmg` 內的 AAX | **未 PACE 簽署，已下架**：Windows AAX ZIP 與包含 AAX 的 Setup EXE |
| beta.3 — 簽署更新前已下載的原始檔 | **未 PACE 簽署**：原始 AAX ZIP／DMG | **未 PACE 簽署** |
| `v2.0.3.2-hikari-beta.2`（Release 已不存在） | 原 AAX ZIP **未 PACE 簽署** | 原 AAX ZIP **未 PACE 簽署** |
| `v2.0.3.2-hikari-beta.1`（Release 已不存在） | 原 AAX ZIP **未 PACE 簽署** | 未提供此平台版本 |
| 目前 Actions workflow 直接產生的 Artifacts | **未 PACE 簽署** | **未 PACE 簽署** |

beta.3 的 macOS 更新檔由 **Hikari Music** 使用 PACE wraptool 6.0.1 簽署；ZIP 與安裝包解出後，PACE 及 macOS 嚴格簽章檢查均通過，並保留 Intel／Apple Silicon 雙架構。macOS 簽署身分為**自簽測試憑證** `AAX Local Test 100Y 2026-09-27`，不是 Apple Developer ID。**此已簽署版本尚未實測標準版 Pro Tools 載入。** DMG／PKG 本身仍未簽章、未 notarize；macOS VST3／AU 維持 ad-hoc 簽章。Windows AAX 及包含它的 EXE 已下架；先前下載的 Windows AAX 仍未簽署，需搭配已授權的 **Pro Tools Developer**。

這次替換兩份 macOS Release 檔案時，Tag 與檔名都沒有變更。**若持有原始 beta.3 舊檔，請重新下載現行 Release 檔案。** 本地舊檔與 Actions Artifacts 不會自動更新；將 Release 設為 **Latest** 也不會替其他檔案補上簽章。

<details>
<summary>更新後 macOS Release 下載檔的 SHA-256</summary>

```text
c44e33ca499e2bbf588f50f66c62462f3d784b0594f63663ee1474325036c752  JS_Inflator-macOS-AAX.zip
b6305881ea56143fd4a573c77a5112bfd91d80391a7a87d70f19defd3bdaa95f  JS_Inflator-macOS.dmg
```

</details>

[← 返回 README](../README.zh-TW.md)
