# JS Inflator — AAX 改作版

> **這是 AAX 改作版本，目前尚在測試中。** 本 repository 以 [JS Inflator](https://github.com/Kiriki-liszt/JS_Inflator) 為基礎，針對 AAX 支援與 Pro Tools 整合進行改作，屬於實驗性開發版本，尚非穩定的 AAX 正式版本。目前使用 Pro Tools Developer 測試，尚未完成標準版 Pro Tools 所需的 Avid/PACE 簽章。已驗證項目與尚未涵蓋的測試範圍請見[測試紀錄](tests/results/aax-verification.md)。

[English](README.md) | [繁體中文](README.zh-TW.md)

JS Inflator 是 Sonox Inflator 的仿製版本。  
內部採用雙精度 64 位元處理。  
若宿主支援，也可使用雙精度輸入／輸出。  

以下版本／下載徽章與贊助連結指向上游專案，不代表此改作版已發布 AAX 正式版本。

[![GitHub Release](https://img.shields.io/github/v/release/kiriki-liszt/JS_Inflator?style=flat-square&label=Get%20latest%20Release)](https://github.com/Kiriki-liszt/JS_Inflator/releases/latest)
[![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/kiriki-liszt/JS_Inflator/total?style=flat-square&label=total%20downloads&color=blue)](https://tooomm.github.io/github-release-stats/?username=Kiriki-liszt&repository=JS_Inflator)  

[![Static Badge](https://img.shields.io/badge/coffee%20maybe%3F%20%3D%5D%20-gray?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/kirikiaris)

<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/screenshot_both.png" width="600"/>

提供兩種 GUI。替代版 GUI 由 Twarch 製作。

### 相容格式

VST3、AUv2、AAX Native／AudioSuite

### 系統需求

Audio Units

* Intel：Mac OS X 10.13 或更新版本
* Apple Silicon：macOS 11.0 或更新版本

VST3

* Intel：Mac OS X 10.13 或更新版本
* Apple Silicon：macOS 11.0 或更新版本
* Windows 10 或更新版本

AAX Native／AudioSuite

* Intel：Mac OS X 10.13 或更新版本
* Apple Silicon：macOS 11.0 或更新版本

### 已測試 DAW

已確認可在 Cubase、Ableton Live、Logic Pro、Cakewalk by Bandlab 與 Bitwig 中運作。

## 使用方式

### Windows

從最新 Release 解壓縮 Windows 版本，並複製到 `C:\Program Files\Common Files\VST3`。

### macOS

從最新 Release 解壓縮 macOS 版本，將 VST3 複製到 `/Library/Audio/Plug-Ins/VST3`，並將 component 複製到 `/Library/Audio/Plug-Ins/Components`。

> 若無法正常運作，可在終端機中為外掛重新簽章：
>
> ```console
> sudo xattr -r -d com.apple.quarantine /Library/Audio/Plug-Ins/VST3/JS_Inflator.vst3
> sudo xattr -r -d com.apple.quarantine /Library/Audio/Plug-Ins/Components/JS_Inflator.component
>
> sudo codesign --force --sign - /Library/Audio/Plug-Ins/VST3/JS_Inflator.vst3
> sudo codesign --force --sign - /Library/Audio/Plug-Ins/Components/JS_Inflator.component
> ```
>
> 由 @jonasborneland 於[此處](https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/issues/12#issuecomment-1616671177)完成測試。

### 從 v1.x.x 升級至 v2.x.x

刪除舊版本並使用新版本即可。  
任何遵循 Steinberg 標準的 DAW，開啟專案時都會自動替換舊外掛，設定也會自動移轉。

外掛版本變更後，請勿直接開啟既有專案。請先開啟空白專案，讓 DAW 掃描外掛並完成從 v1 到 v2 的更新，再開啟舊專案。

已測試以下升級情境：

1. Cubase 12（Windows），外掛 v1.7.0 -> v2.0.0
2. Cubase 12（macOS），外掛 v1.7.0 -> v2.0.0
3. Cubase 12（Windows），外掛 v1.7.0 -> Cubase 12（macOS），外掛 v2.0.0
4. Logic 10，外掛 v1.7.0 -> v2.0.0
5. Ableton 12（Windows），外掛 v1.7.0 -> v2.0.0
6. Ableton 12（macOS），外掛 v1.7.0 -> v2.0.0
7. Ableton 12（Windows），外掛 v1.7.0 -> Ableton 12（macOS），外掛 v2.0.0

## 授權

JS Inflator 與此改作版本採用 **GNU GPLv3**，詳見 [LICENSE](LICENSE)。可以使用、修改與販售副本。散布修改版或二進位版本時，須保留必要的版權及授權聲明、標明修改，並依 GPLv3 提供完整對應原始碼，包含必要建置資料。私人修改不必公開；使用外掛處理自己的音訊，通常不會使音訊作品受 GPL 約束。詳見 [GNU GPL 官方常見問題](https://www.gnu.org/licenses/gpl-faq.en.html)。

第三方依賴各自保留其授權：

* **r8brain-free-src：** MIT；須保留版權與授權聲明。
* **VSTGUI：** BSD 三條款；須保留聲明及免責條款，並遵守不得擅用作者名義背書的條件。
* **AudioUnitSDK：** Apache 2.0；須保留適用聲明並標明修改。
* **目前建置使用的 VST3 SDK 3.7.12：** Steinberg 商業授權或 GPLv3，另有個別檔案自己的授權。新版已有採用 MIT 的 VST SDK，但更換 SDK 不會解除本專案的 GPL 義務。詳見 [Steinberg 授權說明](https://steinbergmedia.github.io/vst3_dev_portal/pages/FAQ/Licensing.html)。
* **AAX SDK 2.9.0：** 其 `LICENSE.txt` 與原始碼標頭明確提供商業授權或 GPLv3 選項。應遵循所選授權及個別檔案條款，不能一概認定 GPLv3 選項下的 SDK 禁止再散布。本 repository 未附帶 SDK。

AAX SDK 授權、Pro Tools Developer 的使用授權，以及 AAX 二進位簽章是不同事項。取得 Developer 使用授權不等於完成產品發布授權。標準版 Pro Tools 需要經 Avid/PACE 簽章的 AAX；本機 macOS ad-hoc 簽章無法取代它。若要商業化，請依 [Avid 官方 AAX 開發頁面](https://developer.avid.com/aax/) 指示，聯絡 `audiosdk@avid.com` 確認所需工具與授權。SDK 原始碼授權不會自動涵蓋另外提供的 Pro Tools 執行檔或簽章工具。

上述軟體授權不會自動授予超出各權利人授權範圍的第三方商標或美術素材權利。

<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/VST_Compatible_Logo_Steinberg_with_TM.png" width="200"/>

## 目前建置支援

此 repository 可將相同的音訊處理演算法建置為以下外掛格式：

* VST3
* 透過 Steinberg VST3-to-AUv2 wrapper 建置的 AUv2
* 透過 Steinberg VST3-to-AAX wrapper 建置的 AAX Native 與 AudioSuite

macOS 目標為同時包含 Intel `x86_64` 與 Apple Silicon `arm64` 的 universal binary。所有 macOS 目標的 deployment target 均設為 macOS 10.13。Intel binary 支援 macOS 10.13 或更新版本；Apple Silicon binary 則需要 macOS 11.0 或更新版本。

專案與 bundle 版本為 `2.0.3.2`。AU `AudioComponent` 版本為 `2.0.3`，因為 Apple 的 `0xMMMMmmDD` component version 欄位無法表示第四段版本號。

### 必要工具鏈

目前使用或已驗證的版本：

* CMake 3.19 或更新版本
* Xcode 16.2／AppleClang 16
* VST3 SDK 3.7.12
* VSTGUI 4.14
* AudioUnitSDK 1.3.0，用於相容 macOS 10.13 的 AUv2 建置
* AAX SDK 2.9.0，用於 AAX 建置

AudioUnitSDK 1.4.0 需要 C++23 與 macOS 11.0，因此無法在保留 macOS 10.13 AUv2 相容性的情況下使用。

### macOS 建置

使用必要的 SDK 路徑設定 Xcode build：

```console
cmake -S . -B build -G Xcode \
  -DSMTG_MAC=ON \
  -DGITHUB_ACTIONS=ON \
  -DSMTG_AUDIOUNIT_SDK_PATH=/absolute/path/to/AudioUnitSDK-1.3.0 \
  -DSMTG_AAX_SDK_PATH=/absolute/path/to/aax-sdk-2-9-0 \
  -DSMTG_ENABLE_AUV2_BUILDS=ON \
  -DSMTG_CODE_SIGN_IDENTITY_MAC=- \
  -DSMTG_ENABLE_VST3_PLUGIN_EXAMPLES=OFF \
  -DSMTG_ENABLE_VST3_HOSTING_EXAMPLES=OFF
```

建置各外掛格式：

```console
cmake --build build --config Release --target JS_Inflator
cmake --build build --config Release --target JS_Inflator-au
cmake --build build --config Release --target JS_Inflator-aax
```

只有在 `SMTG_AAX_SDK_PATH` 指向有效 AAX SDK 時，才會產生 AAX target。其他建置細節請參閱 [How_to_build.md](How_to_build.md)。

### 驗證狀態

目前 macOS build 已完成以下驗證：

* VST3 validator：47 項測試通過，0 項失敗
* Apple `auval`：驗證成功
* AAX：已驗證 universal bundle build、必要 AAX／ACF symbols 與 bundle 載入
* Apple Silicon 上的 Pro Tools Developer 2025.6／AAX Native：已實測手動控制、即時電表、換膚及縮放
* Processor 回歸測試：96 項音訊案例通過；單／雙聲道電表傳遞與 editor 尺寸／縮放整合測試通過
* VST3、AUv2 與 AAX 的 Intel `x86_64` Mach-O 最低系統版本均為 macOS 10.13

AAX 版本仍在測試中。本輪尚未驗證主機 automation 錄製、session 儲存／重開，以及 AudioSuite 處理，詳見[測試紀錄](tests/results/aax-verification.md)。未經 Avid/PACE 簽章的 build 需使用 Pro Tools Developer 測試，無法在標準版 Pro Tools 載入。能否再散布取決於適用授權，與此載入限制分開判斷。目前 wrapper target 支援 Native 與 AudioSuite 處理，不支援 AAX DSP。

Windows 與 Linux VST3 build 仍遵循 VST3 SDK 支援的平台與工具鏈。

### GitHub Actions macOS 建置

`Mac Build` workflow 會在 pull request 與推送至 `main` 時，自動建置 **VST3 與 AAX**。也可手動執行，不必另外勾選 AAX。兩種格式均使用 Xcode 16.2 建置，包含 Intel `x86_64` 與 Apple Silicon `arm64`。

CI 從 [JUCE 公開提供的 SDK 副本](https://github.com/juce-framework/JUCE/tree/72782788ce18c2d4d760b28e0921d6ffc6431102/modules/juce_audio_plugin_client/AAX/SDK) 下載 AAX SDK 2.9.0，固定在 commit `72782788ce18c2d4d760b28e0921d6ffc6431102`，並採用其 GPLv3 授權選項。僅使用 SDK，不會將 JUCE 模組連結至外掛。不需要 `AAX_SDK_REPOSITORY` 或 `AAX_SDK_TOKEN` secret，因此 fork PR 也能建置。

每次成功執行都會上傳 VST3 與 AAX artifact。AAX bundle 會加上本機 ad-hoc 簽章，再打包為 `JS_Inflator-macOS-AAX.zip`，保留執行檔權限。這是供 Pro Tools Developer 使用的開發版本；ad-hoc 簽章無法取代標準版 Pro Tools 所需的 Avid/PACE 簽章。再散布須遵守 GPLv3 與適用的 SDK 條款。兩種格式均以 ZIP 檔保存於 Artifacts。此 workflow 不會執行 Pro Tools 介面測試。

### 自動發布預發行版

推送符合 `v*` 的版本標籤會觸發 `Mac Build`。兩種格式都完成編譯、架構檢查、簽章／打包檢查與 artifact 上傳後，獨立的發布 job 會建立 **GitHub Pre-release**，附上：

* `JS_Inflator-macOS-VST3.zip`
* `JS_Inflator-macOS-AAX.zip`

PR、分支推送及手動執行只上傳 Artifacts。版本標籤必須指向包含此 workflow 的 commit。例如，選定要發布的 commit 與尚未使用的版本號後：

```console
git tag v2.0.3.3-aax-beta.1
git push origin v2.0.3.3-aax-beta.1
```

上述標籤只是範例，不代表已發布此版本。AAX 測試期間會標示為預發行版。發布 job 使用 GitHub 內建 token，不需新增 secret。同名標籤若已有 Release，流程不會覆寫；發布新版本請使用新標籤。

## 版本紀錄

v1.0.0：初次嘗試。

v1.1.0：變更 VU PPM meter（mono -> stereo、continuous -> discrete），但尚未完成。

v1.2.0：修正 VU PPM meter。

v1.2.1：修正 channel configuration，可能也修正了偶發 crash。

v1.3.0：修正 Curve knob，並加入 airwindows 的 32FP dither。

v1.4.0：oversampling 現在可使用至 x8，DPC 可正常運作。

v1.5.0：加入 Band Split。

v1.5.1：加入 macOS build，已測試 Intel x86 與 Apple Silicon。

v1.6.0rc：加入 FX meter（Effect Meter），原始 GUI 改為高解析度。

v1.6.0rc1：加入 linear phase oversampling。

v1.6.0：指定 linear knob mode，並修正 GUI 尺寸閃動。

v1.7.0.beta + beta 2

1. 加入 AUv2 build。VSTSDK 更新至 3.7.9。使用 Xcode 15.2、OSX 14.2 build。
2. 將 oversampling 方法從整個 buffer resample 改為逐 sample resample，以減少 crash。
3. 不再使用 hiir minimum-phase resampler，改為實作具有 SSE2 最佳化的 FIR resampler。
4. FIR filter 改為 hardwired。
5. 加入 bypass latency compensation。

v1.7.0：FIR 改用 Kaiser-Bessel window，label 從 `Lin` 改為 `Max`。

v2.0.0

* 將 `InflatorPackage` 更名為 `JS Inflator`。
* AUv2：修正 Controller state 覆寫 Processor state 的問題。
* Ctrl-Z：VU meter 原本使用 parameter 將資料送至 Controller，導致 undo history 被 meter change 填滿，現已修正。
* Meter 現在會依照具有 time constant 的 envelope detector 運作。

v2.0.1：修正 Ableton crash，以及 Twarch GUI 的 VU meter。

v2.0.2：將兩種 GUI 整合至單一外掛。

v2.0.2.1：修正 GUI recall state（Bitwig）。

v2.0.2.2：重構 GUI switching，使其更安全。

v2.0.3：修正 Apple Silicon native build 錯誤。

v2.0.3.1：修正 Cubase 13 問題。問題由 `DataExchange` 方法造成，因此改回舊版方法 `sendMesseage`。

v2.0.3.2：修正 Cakewalk by Bandlab 問題。問題由 VuMeters 中的 `setDirty` 造成，因此將其移除。

## 開發心得

### Volume fader

對於和我一樣正在研究 volume fader 使用方式的人：請使用 `RangeParameter`。

* param：normalized parameter `[0.0, 1.0]`
* dB：plain value
* gain：每個 sample 的乘數

如需從 normParam 轉換至 gain，請查看 `process.cpp`。

範例：

| param | dB | gain |
|---|---|---|
| 0.0 | -12 | 0.25 |
| 0.5 | 0 | 1 |
| 1.0 | +12 | 4 |

| param | dB | gain |
|---|---|---|
| 0.0 | -12 | 0.25 |
| 0.5 | -6 | 0.5 |
| 1.0 | 0 | 1 |

### Resampling

一般處理流程如下：

1. 將 samples 加倍
2. LP filtering
3. ProcessAudio
4. LP filtering
5. 減少 samples

### Linear Phase

HIIR resampling 是 minimum-phase resampler，表示高頻會出現 phase disorder。若希望高頻聽感更自然，可使用 linear resampling，例如由 Voxengo 的 Aleksey Vaneev 設計的 r8brain-free-src。

x4 與 x8 的特殊選擇是因為這些 resampler 具有 asynchronous latency，導致 downsampling 會略早於 upsampling 開始。為修正此問題，我調整了 x4 的 transition band，以及 x8 的 24-bit 設定。現在已沒有 phase 問題。

### 比較

1x  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_1x_Min.png" width="400"/>

2x Min-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_2x_Min.png" width="400"/>

2x Lin-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_2x_Lin.png" width="400"/>

4x Min-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_4x_Min.png" width="400"/>

4x Lin-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_4x_Lin.png" width="400"/>

8x Min-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_8x_Min.png" width="400"/>

8x Lin-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_8x_Lin.png" width="400"/>

### SIMD 最佳化

出乎意料的是，手動 SSE2 SIMD 最佳化比編譯器的 O3 最大最佳化更慢。編譯器的 vectorization 比我的實作更有效率。若要嘗試，請務必進行檢查與比較。

### Latency change reporting

重新啟動外掛應從 Controller 端執行。一個做法是使用 `sendTextMessage` 與 `receiveText`：當 Processor 偵測到與 latency 有關的 parameter change 時，送出 text message；Controller 收到後再重新啟動。

然而在 AUv2 中，`restartComponent` 應呼叫 `setupProcess`，但實際上不會。因此應將初始化移至新的自訂函式，並在 `setupProcess` 與 `process` 中檢查後呼叫該函式。

<https://forums.steinberg.net/t/reporting-latency-change/201601>  
<https://forums.steinberg.net/t/how-to-use-restartcomponent-and-which-flags-are-the-right-one-when-changing-all-characteristics-parameters-except-size/202031>  
<https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical+Documentation/Workflow+Diagrams/Audio+Processor+Call+Sequence.html>

### Knob Modes

在 `controller.cpp` 的 `createView` 中指定 knob mode，即可讓 knob 以所選模式運作。

```c++
setKnobMode(Steinberg::Vst::KnobModes::kLinearMode);
```

<https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/blob/v1.6.0/source/InflatorPackagecontroller.cpp#L339>

### VSTSDK 如何識別外掛

VSTSDK 使用 CID header 中的 `Steinberg::FUID kProcessorUID` 識別外掛。只要 ProcessorUID 維持不變，宿主就會將其視為相同外掛。例如，使用 v1.7.0 `InflatorPackage` 的專案，會自動以相同設定替換為 v2.0.0 `JS Inflator`。

但替換舊外掛時，ParamID 也必須維持不變。否則應使用 VSTSDK v3.7.11 引入的 `Vst::IRemapParamID`。

### 關於 AUv2

使用 VSTSDK 的 AUv2 wrapper 時，也應儲存 Controller state。原因不明，但 AUv2 wrapper 會以預設 UI value 覆寫從 state 設定的值。

plist 中的版本號會從十六進位轉換為十進位。例如 v1.7.2 -> `0x010702` -> `67330`。

### VSTSDK 與 Apple ARM Release 設定

VSTSDK 預設會為 Release 設定 `-O3` 與 `-ffast-math`。當 `i == n` 時，這會導致 `std::sqrt(1.0 - (i*i)/(n*n))` 回傳 NaN，而不是 0.0。

## 參考資料

1. RC Inflator  
   <https://forum.cockos.com/showthread.php?t=256286>  
   <https://github.com/ReaTeam/JSFX/tree/master/Distortion>

2. Laurent De Soras 的 HIIR resampling 程式碼  
   <http://ldesoras.free.fr/index.html>

3. r8brain-free-src，由 Voxengo 的 Aleksey Vaneev 設計的 sample rate converter  
   <https://github.com/avaneev/r8brain-free-src>  
   已依需求修改：移除 fractional resampling 與 interpolation 部分。

## 待辦事項

* [ ] GUI：雙擊輸入數值。
* [ ] 雙擊重設為預設值。
* [ ] Bypass automation flag。
