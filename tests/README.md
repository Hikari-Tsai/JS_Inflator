# AAX meter regression test (macOS)

Run from the repository root after building the Release SDK libraries:

```sh
clang++ -std=c++17 -DRELEASE=1 -DJSIF_AAX_BUILD=1 \
  -I source -I vst3sdk -I libs/r8brain-free-src \
  tests/aax-meter-smoke.cpp source/JSIF_processor.cpp \
  -L build-aax-sdk/lib/Release \
  -lsdk -lsdk_hosting -lsdk_common -lbase -lpluginterfaces -lr8brain-free-src \
  -framework Foundation -lpthread -o /tmp/jsif-aax-meter-smoke
/tmp/jsif-aax-meter-smoke
```

The test feeds mono and stereo audio on a worker thread through the actual
processor. It connects a meter receiver through the same SDK ConnectionProxy
used by AAX, then runs the main event loop. It requires nonzero audio output,
nonzero input/output meters, and no meter callback on the audio thread.
The original processor produces audio but fails meter delivery in both layouts.
This is a processor/message transport regression test, not a Pro Tools host test.

For Xcode 26.6, the bundled VSTGUI/RapidJSON dependency emits
`nan-infinity-disabled`, `unused-but-set-variable`, and deprecation warnings.
This local build override preserves these warnings without treating them as errors:

```sh
cmake --build build-aax-sdk --config Release --target JS_Inflator-aax -- \
  'OTHER_CPLUSPLUSFLAGS=$(inherited) -Wno-error=nan-infinity-disabled -Wno-error=unused-but-set-variable -Wno-error=deprecated-declarations'
```

If an existing build cache still points to a removed Xcode SDK (for example
`MacOSX15.2.sdk/usr/lib/libexpat.tbd`), rediscover Expat before building:

```sh
cmake -S . -B build-aax-sdk -U 'EXPAT_*'
```

## Parameter audio sweep

Compile `tests/parameter-audio-smoke.cpp` using the meter test command above
(replace the test source and executable name). It compares output waveforms for
Input, Output, Effect, Curve, Clip, Split, In, Bypass, OS x1/x2/x4/x8, and Phase.
It tests mono/stereo at 44.1, 48 and 96 kHz. Curve is tested with Effect enabled;
Clip uses an over-full-scale signal; Phase is tested at x2, x4 and x8 oversampling. Negative controls
verify that Curve has no effect at Effect=0 and Phase has no effect at OS=x1.
Results are recorded in `tests/results/parameter-audio.txt`.

Local development AAX bundles need a complete ad-hoc bundle signature after build:

```sh
codesign --force --sign - build-aax-sdk/AAXPLUGIN/Release/JS_Inflator.aaxplugin
```

This does not provide the Avid/PACE signature required by retail Pro Tools.

## macOS AAX drawing-layer resize regression

Pro Tools can resize the native NSView before VSTGUI receives `setSize`.
The SDK's same-size early return then leaves its separate CALayer at the old
size. This test reproduces that order using the actual VSTGUI Cocoa frame.
Without the repair it reports 240×400 for both 650×650 and 975×975 requests.

```sh
clang++ -std=c++17 -DRELEASE=1 -DJSIF_TEST_LAYER_FIX=1 \
  -I source -I vst3sdk/vstgui4 \
  tests/aax-layer-resize.mm source/JSIF_aax_mac.mm \
  -L build-aax-sdk/lib/Release -lvstgui \
  -framework Cocoa -framework QuartzCore -framework OpenGL \
  -framework Accelerate -framework Carbon -o /tmp/jsif-aax-layer-resize
/tmp/jsif-aax-layer-resize
```

To observe the original failure, omit `-DJSIF_TEST_LAYER_FIX=1` and
`source/JSIF_aax_mac.mm`. This tests native drawing-layer geometry, not Pro Tools
screen rendering. The repair is linked only into the macOS AAX target and runs
from the editor timer; it redraws once only when the layer dimensions differ.

## Editor integration (macOS)

This instantiates the actual controller and editor with installed bundle
resources. A small test host resizes the NSView before `onSize`, matching the
ordering seen in Pro Tools. The normal editor timer must repair the layer.
It checks Original → Twarch → 75% → Original, zoom parameter synchronization,
and closing/reopening the editor at the retained 75% zoom.

```sh
clang++ -std=c++17 -DRELEASE=1 -DJSIF_AAX_BUILD=1 \
  -I source -I vst3sdk -I vst3sdk/vstgui4 \
  tests/aax-editor-smoke.mm source/JSIF_controller.cpp source/JSIF_aax_mac.mm \
  -L build-aax-sdk/lib/Release -lvstgui_support -lvstgui_uidescription \
  -lvstgui -lsdk -lsdk_hosting -lsdk_common -lbase -lpluginterfaces -lexpat \
  -framework Cocoa -framework QuartzCore -framework Accelerate \
  -framework OpenGL -framework Carbon -o /tmp/jsif-aax-editor-smoke
/tmp/jsif-aax-editor-smoke \
  '/Library/Application Support/Avid/Audio/Plug-Ins/JS_Inflator.aaxplugin'
```

Omitting `-DJSIF_AAX_BUILD=1` and `source/JSIF_aax_mac.mm` reproduces the
unrepaired layer dimensions during skin/zoom changes. This integration test
checks geometry and zoom state; final visual confirmation in Pro Tools is
still separate.
