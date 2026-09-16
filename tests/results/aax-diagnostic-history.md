# AAX 驗證紀錄

日期：2026-09-15。主機：Pro Tools Developer 2025.6.0，Apple Silicon。

## 自動音訊測試

`parameter-audio.txt`：96 項通過，0 失敗。實際 processor 的 mono/stereo，
44.1/48/96 kHz，對比參數變更前後的輸出樣本，並檢查有限值。
這是 processor 測試，不等同於 Pro Tools 內的音訊或 automation 驗證。

| 項目 | 結果／條件 |
| --- | --- |
| Input、Output、Effect | 輸出樣本隨參數改變 |
| Curve | Effect 啟用時改變；Effect=0 時不變 |
| Clip | 超過 full scale 的輸入可測到變化 |
| Split、In、Bypass | 輸出樣本隨切換改變 |
| OS | x2、x4、x8 分別與 x1 比較 |
| Phase | x2、x4、x8 均有變化；x1 不變 |

`aax-meter-smoke.cpp`：mono/stereo 均通過。audio worker thread 經由
AAX wrapper 所用的 ConnectionProxy 將非零 PPM 資料送達主執行緒；
主執行緒 event loop 尚未執行前，不可收到 UI 更新。
原版 processor 的音訊非零，但兩種聲道配置均沒有收到 meter 更新。

## Pro Tools 介面實測

第一輪：JSIF_AAX_Verification 的 Aux 1，無音訊來源。
以 GUI 操作後的 Pro Tools accessibility 參數值核對：

| 控制 | 主機觀察結果 |
| --- | --- |
| Original Input | 0 → +3.29 dB |
| Original Output | 0 → −3.07 dB |
| Original Effect | 0 → 40% |
| Original Curve | 0 → +30 |
| In | On → Off |
| Split、Clip | Off → On |
| OS | 已觀察 x1、x2、x4、x8 |
| Phase | Min → Max |
| Original → Twarch | 主機值保留；50% 視窗完整可見 |
| Twarch Effect | 主機 40 → 70%；文字仍錯誤停留在 0 |

第一輪換膚後仍有局部重繪問題，已保留
`twarch-before-redraw-fix.jpg`。不能將這一輪列為 GUI 通過。

## 已實作的修正

- AAX meter 和 latency 通知從 audio thread 移至主執行緒 timer。
- GUI idle interval 由會截斷成 0 的小數改為整數毫秒。
- 建立 editor 時採用目前的 zoom 參數。
- 切換到較高的 Twarch 版面時回到 50%，讓底部控制可見。
- macOS AAX 的 GUI timer 在畫面有 dirty 內容時請求整個 frame 重繪，
  修復局部更新留下的舊文字與滑桿殘影。此項仍待新版主機重測。

新版 AAX 已 build、ad-hoc codesign、安裝並驗證：
`/Library/Application Support/Avid/Audio/Plug-Ins/JS_Inflator.aaxplugin`。
安裝前版本備份於 `build-aax-sdk/backups/20260915-221954/`。

## 尚待完成

新版主機內的完整畫面重繪、Twarch 全部控制、換膚往返與 zoom 保留；
有 Signal Generator 的主機 PPM／音訊測試；主機 Bypass 實測。
Pro Tools Developer 明確顯示 SAVING IS DISABLED，無法驗證存檔重開。

重啟狀態：22:21:48 主機在 Dashboard 階段發生 Access Violation；
尚未載入測試 Session，不能據此判定新版外掛成功或失敗。已再次啟動主機。
第二次啟動也在 Dashboard 階段發生 Access Violation（22:22:03 啟動記錄）。
目前主機已退出，GUI 新修正與有訊號的主機測試仍未完成。

## 後續啟動診斷

2026-09-15 22:37 的 crash report，以及 22:22、22:23 的報告，
主執行緒均經過 QtWebEngineCore → QtGui
`avid::QAccessibleBridgeUtils::accessibleId` → AppKit accessibility 讀取。
未見 JS Inflator 出現在上述 faulting stack。

22:38:48 啟動後，避開電腦控制的介面觀察，主機成功進入 Dashboard。
直接送 Escape 被電腦控制工具拒絕：需先讀取 app state 才能操作；
而讀取該 Dashboard state 是目前的崩潰觸發條件。
下一步需使用者手動關閉 Dashboard，才能恢復介面實測。

## 有訊號主機複測與後續修正（23:04 build）

使用者建立 Signal Generator → JS Inflator（Aux 1 Insert b）。Original 的
IN／OUT／FX 表已有反應；四個連續控制、Twarch 的四個連續控制、
In／Split／Clip、OS x4、Phase Max、主機 Bypass 均送達正確主機值。
細節見 `host-controls-before-final-refresh.txt`。

Twarch 換膚後局部畫面仍舊，縮放 75% 再回 50% 可恢復正確數值與 PPM；
因此原先依賴 isDirty 的修正判定失敗。追查 SDK 發現 VST3Editor::init
設定 CView::kDirtyCallAlwaysOnMainThread=true，setDirty 立即清掉旗標。
現改為 macOS AAX 開啟 editor 時以約 30 Hz 整體重繪，避免依賴此旗標。
另外加入 onZoomChanged，同步右鍵 UI Zoom 與 private Zoom 參數。

新 build 已簽署、安裝並驗證，備份 `build-aax-sdk/backups/20260915-230406/`。
音訊 96 項與 mono/stereo PPM transport 再次通過。新版 GUI 仍須 host 重測。

為避免 Developer 版無法儲存測試 Session，已將內建 tutorial session 複製至
`build-aax-sdk/host-verification-session/` 作可重開的測試基礎。

23:11 後：成功由 Finder 直接開啟路由範本副本
`build-aax-sdk/host-routing-verification/session.ptx`，避開 Dashboard。
未啟用 Atmos renderer；範本缺少 Dolby LTC Generator，已保持 inactive。
新增 Stereo Aux 1；工具可建立軌道，但原生 Insert selector/assignment
的 AX、座標、double-click 均無反應。需要使用者在此 Aux 插入測試外掛。
目前 Aux output 為範本的 7.1.2 Bed.Stereo，尚未改為實體 stereo output。
新版 GUI 尚未重新 instantiate，不能宣稱重繪／縮放修正已在主機通過。
