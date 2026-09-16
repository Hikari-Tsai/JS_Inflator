# JS Inflator — AAX Fork

> **AAX adaptation — currently in testing.** This repository is a fork of [JS Inflator](https://github.com/Kiriki-liszt/JS_Inflator) focused on AAX support and Pro Tools integration. It is an experimental development version, not a stable AAX release. Current AAX testing uses Pro Tools Developer; the build has not completed Avid/PACE signing for standard Pro Tools. See the [test report](tests/results/aax-verification.md) for verified behavior and remaining test coverage.

[English](README.md) | [繁體中文](README.zh-TW.md)

![JS Inflator system architecture: hosts, AAX wrapper, audio processing, VSTGUI, and build outputs](screenshots/js-inflator-architecture.webp)

JS Inflator is a copy of Sonox Inflator.  
Runs in double precision 64-bit internal processing.  
Also double precision input / output if supported.  

The release/download badges and donation link below refer to the upstream project, not an AAX release from this fork.

[![GitHub Release](https://img.shields.io/github/v/release/kiriki-liszt/JS_Inflator?style=flat-square&label=Get%20latest%20Release)](https://github.com/Kiriki-liszt/JS_Inflator/releases/latest)
[![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/kiriki-liszt/JS_Inflator/total?style=flat-square&label=total%20downloads&color=blue)](https://tooomm.github.io/github-release-stats/?username=Kiriki-liszt&repository=JS_Inflator)  

[![Static Badge](https://img.shields.io/badge/coffee%20maybe%3F%20%3D%5D%20-gray?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/kirikiaris)

<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/screenshot_both.png"  width="600"/>  

Comes in two GUIs. The alternative GUI is made by Twarch.  

### Compatibility

VST3, AUv2, AAX Native / AudioSuite

### System Requirements

Audio Units
* Mac OS X 10.13 or later on Intel
* macOS 11.0 or later on Apple Silicon

VST3
* Mac OS X 10.13 or later on Intel
* macOS 11.0 or later on Apple Silicon
* Windows 10 or later

AAX Native / AudioSuite
* Mac OS X 10.13 or later on Intel
* macOS 11.0 or later on Apple Silicon

### Supported DAW

Cubase, Ableton Live, Logic Pro, Cakewalk by Bandlab, Bitwig are tested as working.  

## How to use  

### Windows  

Unzip Windows version from latest Release and copy to "C:\Program Files\Common Files\VST3".  

### MacOS  

Unzip macOS version from latest Release and copy vst3 to "/Library/Audio/Plug-Ins/VST3" and component to "/Library/Audio/Plug-Ins/Components".  

> If it doesn't go well, CodeSign plugins in console as  
>
> ``` console  
> sudo xattr -r -d com.apple.quarantine /Library/Audio/Plug-Ins/VST3/JS_Inflator.vst3  
> sudo xattr -r -d com.apple.quarantine /Library/Audio/Plug-Ins/Components/JS_Inflator.component
>
> sudo codesign --force --sign - /Library/Audio/Plug-Ins/VST3/JS_Inflator.vst3  
> sudo codesign --force --sign - /Library/Audio/Plug-Ins/Components/JS_Inflator.component  
> ```  
>
> tested by @jonasborneland [here](https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/issues/12#issuecomment-1616671177)

### Version upgrade from v1.x.x to v2.x.x  

Just delete old one and use new one!  
Any DAW with steinberg standard will automatically replace old plugins while opening project.  
Settings are also transfered automatically.  

Also, after plugin version change, do not open projects directly.  
Please open a blank project first, and let DAW scan plugins and change from v1 to v2,
and then we can safely open previous projects.  

Tested as working are;

1. Cubase 12(Windows), plugin v1.7.0 -> v2.0.0  
2. Cubase 12(macOS), plugin v1.7.0 -> v2.0.0  
3. Cubase 12(Windows), plugin v1.7.0 -> Cubase 12(macOS), plugin v2.0.0  
4. Logic 10, plugin v1.7.0 -> v2.0.0
5. Ableton 12(Windows), plugin v1.7.0 -> v2.0.0
6. Ableton 12(macOS), plugin v1.7.0 -> v2.0.0
7. Ableton 12(Windows), plugin v1.7.0 -> Ableton 12(macOS), plugin v2.0.0  

## Licensing

JS Inflator and this derivative are licensed under **GNU GPLv3**; see [LICENSE](LICENSE). You may use, modify, and sell copies. When distributing a modified version or binary, retain the required copyright/license notices, identify modifications, and provide the complete corresponding source under GPLv3, including the required build material. Private modifications do not have to be published. Using the plug-in to process your own audio does not normally place that audio under GPL. See the [GNU GPL FAQ](https://www.gnu.org/licenses/gpl-faq.en.html).

Dependencies retain their own licenses:

* **r8brain-free-src:** MIT; retain its copyright and license notice.
* **VSTGUI:** BSD 3-Clause; retain its notices and disclaimer and follow its non-endorsement condition.
* **AudioUnitSDK:** Apache 2.0; retain applicable notices and identify modifications.
* **VST3 SDK 3.7.12 used by this build:** Steinberg commercial license or GPLv3, with file-specific licenses where stated. Newer MIT-licensed VST SDK versions are available, but changing SDK versions does not remove this project's GPL obligations. See [Steinberg's licensing FAQ](https://steinbergmedia.github.io/vst3_dev_portal/pages/FAQ/Licensing.html).
* **AAX SDK 2.9.0:** its `LICENSE.txt` and source headers explicitly offer commercial or GPLv3 licensing. Apply the selected license and any file-specific terms; the SDK is not categorically prohibited from redistribution under its GPLv3 option. This repository does not bundle the SDK.

AAX SDK licensing, authorization to run Pro Tools Developer, and AAX binary signing are separate matters. The Developer authorization does not itself authorize a product release. Standard Pro Tools requires Avid/PACE-signed AAX binaries; local macOS ad-hoc signing is not a substitute. For commercialization, contact `audiosdk@avid.com` about the required tools and license, as directed by [Avid's AAX developer page](https://developer.avid.com/aax/). SDK source licensing does not automatically cover separately supplied Pro Tools binaries or signing tools.

These software licenses do not automatically grant rights to third-party trademarks or artwork beyond the applicable rights holder's license.

<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/VST_Compatible_Logo_Steinberg_with_TM.png"  width="200"/>

## Current Build Support

This repository builds the same audio-processing algorithm in the following plug-in formats:

* VST3
* AUv2 through Steinberg's VST3-to-AUv2 wrapper
* AAX Native and AudioSuite through Steinberg's VST3-to-AAX wrapper

The macOS targets are universal binaries containing Intel `x86_64` and Apple Silicon `arm64` slices. All macOS targets use a deployment target of macOS 10.13. Intel slices support macOS 10.13 or later, while Apple Silicon slices require macOS 11.0 or later.

The project and bundle version is `2.0.3.2`. The AU `AudioComponent` version is `2.0.3` because Apple's `0xMMMMmmDD` component-version field cannot represent a fourth version component.

### Required Toolchain

The following versions are currently used or verified:

* CMake 3.19 or later
* Xcode 16.2 / AppleClang 16
* VST3 SDK 3.7.12
* VSTGUI 4.14
* AudioUnitSDK 1.3.0 for macOS 10.13-compatible AUv2 builds
* AAX SDK 2.9.0 for AAX builds

AudioUnitSDK 1.4.0 requires C++23 and macOS 11.0, so it cannot be used while preserving macOS 10.13 AUv2 compatibility.

### macOS Build

Configure an Xcode build with the required SDK paths:

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

Build each plug-in format:

```console
cmake --build build --config Release --target JS_Inflator
cmake --build build --config Release --target JS_Inflator-au
cmake --build build --config Release --target JS_Inflator-aax
```

The AAX target is only generated when `SMTG_AAX_SDK_PATH` points to a valid AAX SDK. See [How_to_build.md](How_to_build.md) for additional build details.

### Validation Status

The current macOS builds have been verified as follows:

* VST3 validator: 47 tests passed, 0 failed
* Apple `auval`: validation succeeded
* AAX: universal bundle build, required AAX/ACF symbols, and bundle loading verified
* AAX Native in Pro Tools Developer 2025.6 on Apple Silicon: manual controls, live metering, skin switching, and zoom checked
* Processor regression tests: 96 audio cases passed; mono/stereo meter transport and editor resize/zoom integration passed
* Intel `x86_64` Mach-O minimum system version: macOS 10.13 for VST3, AUv2, and AAX

The AAX version remains in testing. Recorded host automation, session save/reload, and AudioSuite processing have not been verified in this test pass; see the [test report](tests/results/aax-verification.md). Builds without Avid/PACE signing require Pro Tools Developer for testing and cannot load in standard Pro Tools. Redistribution rights depend on the applicable licenses, separately from this loading restriction. The wrapper target supports Native and AudioSuite processing, not AAX DSP.

Windows and Linux VST3 builds continue to follow the supported platforms and toolchains of the VST3 SDK.

### GitHub Actions macOS Build

The `Mac Build` workflow automatically builds **both VST3 and AAX** for pull requests and pushes to `main`. It can also be run manually without selecting an AAX option. Both formats contain Intel `x86_64` and Apple Silicon `arm64` slices, built using Xcode 16.2.

CI downloads AAX SDK 2.9.0 from [JUCE's public SDK copy](https://github.com/juce-framework/JUCE/tree/72782788ce18c2d4d760b28e0921d6ffc6431102/modules/juce_audio_plugin_client/AAX/SDK), pinned to commit `72782788ce18c2d4d760b28e0921d6ffc6431102`, and uses its GPLv3 license option. Only the SDK is used; JUCE modules are not linked into the plug-in. No `AAX_SDK_REPOSITORY` or `AAX_SDK_TOKEN` secret is required, including for fork PRs.

Each successful run uploads VST3 and AAX artifacts. The AAX bundle receives a local ad-hoc signature and is packaged as `JS_Inflator-macOS-AAX.zip` to preserve executable permissions. This is a development build for Pro Tools Developer; ad-hoc signing does not provide the Avid/PACE signature required by standard Pro Tools. Redistribution must comply with GPLv3 and the applicable SDK terms. Both formats are uploaded as ZIP files. The workflow does not run Pro Tools GUI tests.

### Automatic pre-releases

Pushing a version tag matching `v*` triggers `Mac Build`. After both builds, architecture checks, signing/package checks, and artifact uploads succeed, a separate job publishes a **GitHub Pre-release** with:

* `JS_Inflator-macOS-VST3.zip`
* `JS_Inflator-macOS-AAX.zip`

PRs, branch pushes, and manual runs only upload Artifacts. Version tags must point to a commit containing this workflow. For example, after choosing the release commit and an unused version:

```console
git tag v2.0.3.3-aax-beta.1
git push origin v2.0.3.3-aax-beta.1
```

The tag above is an example, not an already published release. Releases remain marked as pre-releases while AAX is in testing. The release job uses GitHub's built-in token, so no extra secret is needed. An existing release with the same tag is not overwritten; use a new version tag for a new release.

## Version logs

v1.0.0: intial try.  

v1.1.0: VuPPM meter change(mono -> stereo, continuous to discrete), but not complete!  

v1.2.0: VuPPM meter corrected!  

v1.2.1: Channel configuration corrected. probably a bug fix for crashing sometimes.  

v1.3.0: Curve knob fixed!!! and 32FP dither by airwindows.  

v1.4.0: Oversampling up to x8 now works! DPC works.  

v1.5.0: Band Split added.  

v1.5.1: macOS build added. Intel x86 & Apple silicon tested.  

v1.6.0rc: FX meter(Effect Meter) is added. Original GUI is now on high definition.  

v1.6.0rc1: Linear phase Oversampling is now added.  

v1.6.0: Linear knob mode is now specified, and GUI size flinching fixed.  

v1.7.0.beta + beta 2

1. AUv2 build added. VSTSDK update to 3.7.9. Xcode 15.2, OSX 14.2 build.  
2. Changed oversampling method from whole buff resample to each sample resample, for less crashes.  
3. hiir min-phase resampler is no longer used, and implememted my own FIR resampler with SSE2 optimization.
4. Fir filter is now hardwired.
5. Bypass latency compensated.

v1.7.0: Fir using Kaiser-Bessel window, label change from 'Lin' to 'Max'.  

v2.0.0  

* Rename 'InflatorPackage' into 'JS Inflator'.  
* AUv2: Controller state was overwriting Processor state. Fixed.  
* Ctrl-Z: VU meter was using parameter to send data to Controller, and it caued 'undo history' to be filled with meter changes. Fixed.  
* Meters are now following envelope detector with time contants.  

v2.0.1: Fix for Crash for Ableton, and fix for VU meter in Twarch GUI.  

v2.0.2: Two GUIs are now integrated to one plugin.  

v2.0.2.1: GUI recall state corrected(Bitwig).  

v2.0.2.2: Re-structure how GUI switching works to more safe way.  

v2.0.3: Error in Apple Silicon Native build fixed.  

v2.0.3.1: Fixed issue with Cubase 13. It was caused by 'DataExchange' method so fixed by reverting to lagacy method(sendMesseage).  

v2.0.3.2: Fixed issue with Cakewalk by Bandlab. It was caused by 'setDirty' in VuMeters so deleted it.  

## What I've learned

* Volumefader  

For someone like me, wondering how to use volume fader;  
Use a RangeParameter!  
param as normalized parameter[0.0, 1.0],  
dB as Plain value,  
gain as multiplier of each samples.  
For normParam to gain, check ~process.cpp  

ex)  
| param  | dB   | gain  |
|------- |----- |------ |
| 0.0    | -12  | 0.25  |
| 0.5    | 0    | 1     |
| 1.0    | +12  | 4     |  

| param  | dB   | gain  |
|------- |----- |------ |
| 0.0    | -12  | 0.25  |
| 0.5    | -6   | 0.5   |
| 1.0    | 0    | 1     |  

* Resampling  

Generally, the process goes as:  

1. doubling samples  
2. LP Filtering  
3. ProcessAudio  
4. LP Filtering  
5. reducing samples  

* Linear Phase  

HIIR resampling is Min-phase resampler, meaning phase disorder at high freqs.  
For more natural high frequency hearing, Linear resampling such as r8brain-free-src designed by Aleksey Vaneev of Voxengo is recomanded.  
About weird choices for x4 and x8 - these resamplers have asynchronous latencies so downsampling starts little before upsampling starts.  
To fix it, I just changed Transition band for x4 and 24-bit for x8.  
Now it is free of Phase issuses.

* Comparisons  
1x  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_1x_Min.png"  width="400"/>  

2x Min-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_2x_Min.png"  width="400"/>  

2x Lin-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_2x_Lin.png"  width="400"/>  

4x Min-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_4x_Min.png"  width="400"/>  

4x Lin-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_4x_Lin.png"  width="400"/>  

8x Min-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_8x_Min.png"  width="400"/>  

8x Lin-phase  
<img src="https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/raw/main/screenshots/OS_8x_Lin.png"  width="400"/>  

* SIMD optimization

To my surprise, manual SSE2 SIMD optimization was slower then compiler's O3 maximum optimization.  
The compiler's vectorization was more efficient than mine... 
Anyone trying to do so, check and compare!  

* Latency change reporting  

Restarting plugin should be from Contorller side.  
One example would be using 'sendTextMessage' and 'receiveText' pair, so when Processor detects parameter change related to latency, it sends textMessage and Controller receives it and restarts.  

However, In AUv2, the restartComponent should call setupProcess, but it does not...  
Due to this, we should move any initializing into new custom function, and call it in setupProcess and process both, with checking if that new function is called.  

[https://forums.steinberg.net/t/reporting-latency-change/201601](https://forums.steinberg.net/t/reporting-latency-change/201601)  
[https://forums.steinberg.net/t/how-to-use-restartcomponent-and-which-flags-are-the-right-one-when-changing-all-characteristics-parameters-except-size/202031](https://forums.steinberg.net/t/how-to-use-restartcomponent-and-which-flags-are-the-right-one-when-changing-all-characteristics-parameters-except-size/202031)  
[https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical+Documentation/Workflow+Diagrams/Audio+Processor+Call+Sequence.html](https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical+Documentation/Workflow+Diagrams/Audio+Processor+Call+Sequence.html)  

* Knob Modes

Specifying knob modes at 'createView' in 'controller.cpp' makes knobs work in selected mode.  

``` c++
setKnobMode(Steinberg::Vst::KnobModes::kLinearMode);
```

[https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/blob/v1.6.0/source/InflatorPackagecontroller.cpp#L339](https://github.com/Kiriki-liszt/JS_Inflator_to_VST2_VST3/blob/v1.6.0/source/InflatorPackagecontroller.cpp#L339)  

* How VSTSDK identifies each plugins  

It uses "Steinberg::FUID kProcessorUID" in cid header to identify plugin.  
So, if ProcessorUID is kept same, host will see it as same plugin.  
In example, project using v1.7.0 'InflatorPackage' will automatically replace it with v2.0.0 'JS Inflator', with same settings.  

However, ParamIDs should be same as before while replacing old plugin with new one.  
If else, one should use Vst::IRemapParamID introduced in VSTSDK v3.7.11.  

* About AUv2  

While using AUv2 wrapper of VSTSDK, one should save Controller state also.  
IDK why, but in AUv2 wrapper overwrites values set from state to default UI values.  

The version number in plist is converted from hex to decimal.  
For example, v1.7.2 -> 0x010702 -> 67330.  

* VSTSDK with apple ARM Release setting  

By default, VSTSDK sets Release setting with -O3 and -ffast-math.  
It caused std::sqrt(1.0 - (i\*i)/(n\*n)) to return NaN instead of 0.0, when i == n.  

## references

1. RC Inflator  
<https://forum.cockos.com/showthread.php?t=256286>  
<https://github.com/ReaTeam/JSFX/tree/master/Distortion>  

2. HIIR resampling codes by 'Laurent De Soras'.  
<http://ldesoras.free.fr/index.html>  

3. r8brain-free-src - Sample rate converter designed by Aleksey Vaneev of Voxengo  
<https://github.com/avaneev/r8brain-free-src>  
Modified for my need: Fractional resampling, Interpolation parts are deleted.  

## Todo

* [ ] GUI : double click to enter value.
* [ ] Double click to reset to default.
* [ ] Bypass automation flag.
