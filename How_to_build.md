# How to build  

Following guide is based on VSTSDK v3.7.12, where Windows bundle build is fixed and AudioUnit SDK is supported.  

CMake 3.19 or later is required by VSTSDK 3.7.12.

All macOS plug-in targets are built with macOS 10.13 as the minimum deployment
target. Apple Silicon binaries require macOS 11.0 or later because that is the
first macOS release supporting Apple Silicon.

## 0. Set VSTSDK  

Download or clone VSTSDK and place it where you're least likely to move/rename/etc.  

### macOS - Check AudioUnit SDK Path  

To build the AUv2 plug-in with macOS 10.13 support, use official AudioUnitSDK
1.3.0 and set `SMTG_AUDIOUNIT_SDK_PATH`. AudioUnitSDK 1.4.0 requires macOS
11.0 and cannot be used for a 10.13-compatible build.
Repo : [https://github.com/apple/AudioUnitSDK](https://github.com/apple/AudioUnitSDK)  

Clone the repo right next to vst3sdk folder so it looks like this;  

``` console
git -C AudioUnitSDK checkout AudioUnitSDK-1.3.0
```

![Clone this repo using VS Code](screenshots/Guide/0-1.png)  

## 1. Clone this repo

![Clone this repo using VS Code](screenshots/Guide/1-1.png)  
![Clone this repo using VS Code](screenshots/Guide/1-2.png)  

Use any method you like. I used VS Code.  

## 2. Recursivly clone submodules

![Clone this repo using VS Code](screenshots/Guide/2-1.png)  

Clone all submodules in this repo.  
Use following command in Terminal in VS Code.  

``` git
git submodule init
git submodule update
```

## 3. Configure CMake

![Clone this repo using VS Code](screenshots/Guide/3-1.png)  

Set source code directory.  

![Clone this repo using VS Code](screenshots/Guide/3-2.png)  

Set build directory. It doesn't exiest by default, so make one.  

![Clone this repo using VS Code](screenshots/Guide/3-3.png)  
![Clone this repo using VS Code](screenshots/Guide/3-4.png)  

Add CMake entry by your OS - SMTG_MAC / SMTG_WIN - and set it true.  

![Clone this repo using VS Code](screenshots/Guide/3-5.png)  

Start cofigure and set IDE you like.  

![Clone this repo using VS Code](screenshots/Guide/3-6.png)  

Now, all SMTG entries appeared.  

![Clone this repo using VS Code](screenshots/Guide/3-7.png)  
![Clone this repo using VS Code](screenshots/Guide/3-8.png)  

Turn OFF these entries, as we don't use them here;

- SMTG_ENABLE_VST3_PLUGIN_EXAMPLES
- SMTG_ENABLE_VST3_HOSTING_EXAMPLES
- SMTG_MDA_VST3_VST2_COMPATIBLE

Click configure again to be sure.  

### Windows - Build plugin as file, not folder  

Turn OFF next entry to build as file;  

- SMTG_CREATE_BUNDLE_FOR_WINDOWS

When turned on, it will create plugin as 'bundle', which is standard in macOS and Linux.  
BUT, I still prefer single file plugin.  

## 4. Generate and Open Peoject  

![Clone this repo using VS Code](screenshots/Guide/4-1.png)  

Done!

## AAX Native / AudioSuite

The AAX build uses Steinberg's VST3-to-AAX wrapper. It supports the existing
VST3 processor, parameters, state handling, VSTGUI editor, Mono/Stereo AAX
Native variants, and AudioSuite IDs.

The proprietary AAX SDK is not included in this repository. Obtain it from
the Avid developer program and pass its absolute path to CMake. This target
has been verified with AAX SDK 2.9.0:

``` console
cmake -S . -B build-aax -G Xcode \
  -DSMTG_MAC=ON \
  -DSMTG_AAX_SDK_PATH=/absolute/path/to/AAX_SDK \
  -DSMTG_ENABLE_VSTGUI_SUPPORT=ON \
  -DSMTG_ENABLE_VST3_PLUGIN_EXAMPLES=OFF \
  -DSMTG_ENABLE_VST3_HOSTING_EXAMPLES=OFF

cmake --build build-aax --config Release --target JS_Inflator-aax
```

On Windows, use a supported Visual Studio generator and provide the same
`SMTG_AAX_SDK_PATH` option.

When `SMTG_AAX_SDK_PATH` is not set, CMake intentionally skips the AAX target
and continues to generate the existing VST3 targets.

The generated development build is not a distributable AAX release. Avid/PACE
signing and validation are required before distribution, and the repository's
GPLv3 license must be reviewed for compatibility with the AAX SDK license.
