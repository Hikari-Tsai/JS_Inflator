# JS Inflator

[English](README.md) | [繁體中文](README.zh-TW.md)

JS Inflator 是 Sonox Inflator 的仿製版本。  
內部採用雙精度 64 位元處理。  
若宿主支援，也可使用雙精度輸入／輸出。  

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

> 問：我想在 GitHub 或其他平台分享 VST 3 外掛／宿主的原始碼。
>
> * 你可以選擇 GPLv3 授權，並自由分享包含或引用 VST 3 SDK 原始碼的外掛／宿主原始碼。
> * **你也可以提供外掛／宿主的二進位版本，前提是同時以 GPLv3 提供其原始碼。**
> * 請遵循 Steinberg VST 使用規範。
>
> <https://steinbergmedia.github.io/vst3_dev_portal/pages/FAQ/Licensing.html>

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
* VST3、AUv2 與 AAX 的 Intel `x86_64` Mach-O 最低系統版本均為 macOS 10.13

AAX 開發版本未經 Avid/PACE 簽章，無法散布，也無法在公開版 Pro Tools 中載入。測試未簽章 AAX 需要 Pro Tools developer build。目前的 AAX wrapper target 支援 Native 與 AudioSuite 處理，不支援 AAX DSP。

Windows 與 Linux VST3 build 仍遵循 VST3 SDK 支援的平台與工具鏈。

### GitHub Actions macOS 建置

`Mac Build` workflow 使用 Xcode 16.2 建置並上傳 universal macOS VST3 artifact。它會在 pull request 與推送至 `main` 時自動執行。

AAX SDK 為專有 SDK，無法包含在此公開 repository 中。若要在 GitHub Actions 建置 AAX：

1. 將 AAX SDK 放在私有 GitHub repository 的根目錄。
2. 新增 repository secret `AAX_SDK_REPOSITORY`，內容為 `owner/private-aax-sdk-repository`。
3. 新增 repository secret `AAX_SDK_TOKEN`，內容為具有該私有 repository 讀取權限的 fine-grained token。
4. 手動執行 `Mac Build` workflow，並啟用 `build_aax` input。

產生的 AAX artifact 為開發版本，正式散布前仍需要 Avid/PACE 簽章。

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
