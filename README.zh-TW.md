# JS Inflator — Hikari AAX 改作版

[![繁體中文](https://img.shields.io/badge/%E7%B9%81%E9%AB%94%E4%B8%AD%E6%96%87-62B6A5?style=for-the-badge)](README.zh-TW.md)[![English](https://img.shields.io/badge/English-454B50?style=for-the-badge)](README.md)

[![下載](https://img.shields.io/badge/%E4%B8%8B%E8%BC%89-454B50?style=for-the-badge)](#downloads)[![安裝](https://img.shields.io/badge/%E5%AE%89%E8%A3%9D-454B50?style=for-the-badge)](#installation)[![架構](https://img.shields.io/badge/%E6%9E%B6%E6%A7%8B-454B50?style=for-the-badge)](#architecture)[![演算法](https://img.shields.io/badge/%E6%BC%94%E7%AE%97%E6%B3%95-454B50?style=for-the-badge)](#algorithm)[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-454B50?style=for-the-badge)](#github-actions)

![JS Inflator 操作介面：左側為 Original，右側為 Twarch 外觀](screenshots/screenshot_both.png)

*左：Original 外觀；右：Twarch 外觀。*

以 [JS Inflator](https://github.com/Kiriki-liszt/JS_Inflator) 為基礎的音訊效果器，加入 AAX 整合、macOS／Windows 建置與安裝包。核心採用 **C++、Steinberg VST3 SDK 與 VSTGUI**。

![JS Inflator 系統架構](screenshots/js-inflator-architecture.webp)

<a id="downloads"></a>
## 下載與安裝

[![AAX](https://img.shields.io/badge/AAX-662D91?style=for-the-badge&logo=protools&logoColor=FFFFFF)](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-macOS-AAX.zip)[![AU](https://img.shields.io/badge/AU-D1D1D6?style=for-the-badge&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI%2BPHBhdGggZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMUQxRDFGIiBzdHJva2Utd2lkdGg9IjIuNSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBkPSJNMyAxMHY0bTQtN3YxMG01LTE0djE4bTUtMTR2MTBtNC03djQiLz48L3N2Zz4%3D)](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-macOS-AU.zip)[![VST3](https://img.shields.io/badge/VST3-C90526?style=for-the-badge&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9Ijk3MCAwIDQyMCA1MDAiPjxwYXRoIGZpbGw9IiNGRkZGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIgZD0iTTEyMjAuMSw3LjFsODAuMiw4MC4yYy04Mi4yLDUuNi0xNDcuMSw3NC4xLTE0Ny4xLDE1Ny43YzAsODcuMSw3MC4zLDE1Ny43LDE1Ny4zLDE1OC4xbC05MC4zLDkwLjNMOTc3LDI1MC4zIEwxMjIwLjEsNy4xTDEyMjAuMSw3LjF6IE0xMjQ0LjEsMjQ1LjFjMC0zNy4xLDMwLjEtNjcuMiw2Ny4yLTY3LjJjMzcuMSwwLDY3LjIsMzAuMSw2Ny4yLDY3LjJjMCwzNy4xLTMwLjEsNjcuMi02Ny4yLDY3LjIgQzEyNzQuMSwzMTIuMiwxMjQ0LjEsMjgyLjIsMTI0NC4xLDI0NS4xTDEyNDQuMSwyNDUuMXoiLz48L3N2Zz4%3D&logoColor=FFFFFF)](#plugin-downloads)[![DMG](https://img.shields.io/badge/DMG-000000?style=for-the-badge&logo=apple&logoColor=FFFFFF)](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-macOS.dmg)

目前版本：[v2.0.3.2-hikari-beta.3](https://github.com/Hikari-Tsai/JS_Inflator/releases/tag/v2.0.3.2-hikari-beta.3)（正式 Release／Latest，保留原 Tag 名稱）。AAX、AU、DMG 按鈕下載 macOS 檔案；VST3 請依下表選擇平台。Source code 壓縮檔是原始碼。

<a id="plugin-downloads"></a>

| 平台 | 安裝程式 | 外掛 ZIP |
| --- | --- | --- |
| macOS · Intel／Apple Silicon 通用 | [DMG](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-macOS.dmg) → `JS_Inflator.pkg` | [AAX](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-macOS-AAX.zip)、[AU](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-macOS-AU.zip)、[VST3](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-macOS-VST3.zip) |
| Windows 10／11 · x64 | 手動安裝 VST3 ZIP | [VST3](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-Windows-VST3.zip) |

macOS 建置目標為 Intel 10.13+、Apple Silicon 11+；實際需求依宿主而異，未逐一驗證所有系統組合。

<a id="installation"></a>

1. **安裝前關閉 DAW。** macOS 開啟 DMG 內的 PKG，預設勾選 VST3、AU；AAX 需在「自訂」勾選。
2. **Windows 手動安裝：** 解壓後將完整 `JS_Inflator.vst3` 資料夾放入 `C:\Program Files\Common Files\VST3`。
3. **載入：** 重啟 DAW、重新掃描，在效果器中尋找 **JS Inflator**。Logic Pro／GarageBand 使用 AU；支援 VST3 的宿主使用 VST3。

<a id="aax-signing-status"></a>

**AAX 簽署：** 2026-09-27 更新後的 macOS AAX ZIP／DMG 內外掛已通過 **PACE 簽章驗證**，使用本地自簽測試憑證，並非 Apple Developer ID；尚未 notarize 或實測標準版 Pro Tools 載入。**未簽署的 Windows AAX ZIP／EXE 已下架。** 舊版 beta.1／beta.2、更新前的 beta.3 和原始 CI Artifacts 都未經 PACE 簽署；舊下載不會自動更新。詳見[各版本簽署狀態與 SHA-256](docs/INSTALLATION.zh-TW.md#aax-signing-status)。

**解除安裝：** macOS 執行 DMG 內的 `Uninstall-JS-Inflator.command`，輸入 `REMOVE` 並依提示授權；Windows 移除手動安裝的 VST3 資料夾，或使用[舊版移除工具](https://github.com/Hikari-Tsai/JS_Inflator/releases/download/v2.0.3.2-hikari-beta.3/JS_Inflator-Windows-Uninstall.zip)。請先關閉 DAW。

完整外掛路徑、舊版解除安裝與疑難排解見[安裝指南](docs/INSTALLATION.zh-TW.md)。

<a id="architecture"></a>
## 架構與功能

同一套 DSP 核心透過 Steinberg wrapper 提供 VST3、AUv2 與 AAX。r8brain 負責線性相位取樣率轉換；CI 僅從 JUCE repository 取得 Avid SDK，**外掛本身不是 JUCE 框架**。上方架構圖的建置區呈現 macOS 路徑，CI 也支援 Windows。

- Input／Output、Effect、Curve、Clip、Band Split 與旁通控制。
- 1×／2×／4×／8× oversampling，可切換相位處理。
- 雙精度音訊處理、輸入／輸出／效果電表。
- Original／Twarch 兩種介面，支援換膚與縮放。

<a id="algorithm"></a>
## 音訊演算法

![JS Inflator 音訊演算法](screenshots/js-inflator-algorithm.zh-TW.webp)

流程為 **輸入增益與限幅 → 升頻 → 波形塑形 → 降頻 → 乾濕混合與輸出**。Curve 控制非線性曲線，Effect 控制混合比例；Band Split 可將低、中、高頻分別塑形。乾聲延遲補償用於對齊升降頻延遲。

**Effect = 0% 不等於完整旁通**，Input 與前段限幅仍然有效。完整公式、過載行為與原始碼位置見[演算法說明](docs/ALGORITHM.zh-TW.md)。

<a id="github-actions"></a>
## 開發與 GitHub Actions

使用 **CMake 3.19+**，SDK 與工具鏈依 [macOS](.github/workflows/macOS%20Build.yml)／[Windows](.github/workflows/Windows%20Build.yml) workflow 的固定版本。建置 target 為 `JS_Inflator`（VST3）、`JS_Inflator-au`、`JS_Inflator-aax`。

PR、推送 `main` 或手動執行可建置；沒有 PR 的一般 `staging` 推送不觸發。新的 `v*` Tag 會在雙平台成功後自動建立 **Pre-release**。目前 CI 仍產生八份測試產物，其中 AAX 未經 PACE 簽署；現行 Release 經本地簽署及下架處理後保留六份附件，與原始 Artifacts 不同。

[建置與發布指南](docs/DEVELOPMENT.zh-TW.md) · [Actions](https://github.com/Hikari-Tsai/JS_Inflator/actions) · [測試紀錄](tests/results/aax-verification.md)

已記錄 96 項音訊回歸案例及 macOS Pro Tools Developer 的介面／控制項測試；Windows 宿主、automation 錄製、session 重開與 AudioSuite 實測仍待完成。

## 授權與致謝

專案採 **[GNU GPLv3](LICENSE)**；散布時須保留必要聲明並提供對應原始碼與建置資料。各 SDK／函式庫保留自身授權，PACE 簽署與宿主授權另行處理。

原作：[yg331／Kiriki-liszt](https://github.com/Kiriki-liszt/JS_Inflator)；介面：**Twarch**；取樣率轉換：[Aleksey Vaneev／r8brain-free-src](https://github.com/avaneev/r8brain-free-src)。本分支由 **Hikari Tsai** 維護 AAX 改作與跨平台建置。
