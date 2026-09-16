# AAX verification — 2026-09-15 23:25 build

## Current status

New universal macOS AAX bundle is built, ad-hoc signed, installed, and verified.
The processor, native layer regression, and actual editor integration tests pass.
**Final Pro Tools visual/control verification now passes on this build.**
The user reopened Signal Generator → JS Inflator on Audio 1, Insert b.
Both skins show live input/output meters and update controls without the old
stale text or duplicate handles. Parameters were restored to their initial
values and the editor left open on Original at 50%.
Developer saving is disabled; session save/reload remains untested.

Installed: `/Library/Application Support/Avid/Audio/Plug-Ins/JS_Inflator.aaxplugin`

Binary SHA-1: `c19147eca92fa509e0d656147ee7c407bbcaf543`

Previous build backup: `build-aax-sdk/backups/20260915-232544/JS_Inflator.aaxplugin`

## Confirmed causes and fixes

1. **PPM transport:** the SDK ConnectionProxy does not deliver audio-thread UI
   messages. AAX now publishes scalar meter values with lock-free atomics and
   sends their combined message from a main-thread timer. Oversampling/phase
   latency notifications also use that timer. Both Original and Twarch host PPM movement was
   observed on the final build; transport regression also passes.
2. **Twarch stale controls:** LLDB in Pro Tools showed an NSView and parent
   layer of **650×650**, but VSTGUI's drawing CALayer remained **240×400**.
   The editor timer fired and invalidated the full 650×650 rectangle, so
   repaint frequency was not the cause. Pro Tools resizes the native view
   before VSTGUI's setSize; the SDK's same-size early return skips the layer
   update. New macOS AAX-only code synchronizes the layer bounds on a mismatch
   and requests one redraw. No SDK files are modified, and the earlier
   ineffective continuous full-frame repaint is removed.
3. **Zoom state:** editor creation restores the private zoom parameter;
   right-click zoom changes synchronize that parameter. Switching to the
   taller Twarch skin resets zoom above 50% to 50% so controls remain reachable.
   Idle timing now uses integer milliseconds instead of a value truncated to 0.

## Automated verification

| Test | Result | Scope |
| --- | --- | --- |
| Parameter audio sweep | 96 passed, 0 failures | Actual processor, mono/stereo × 44.1/48/96 kHz |
| Meter transport | Mono/stereo passed | Worker audio → ConnectionProxy → main run loop |
| Native layer resize | 3 passed | 650×650, 975×975, return to 240×400 |
| Actual editor integration | 5 passed | Original → Twarch → 75% → Original → close/reopen |
| Bundle verification | Passed | Universal arm64/x86_64, codesign, installed/build comparison |

The native regression fails at 650×650 and 975×975 without the repair.
The integration test uses the real controller/editor and a test host that
reproduces Pro Tools resize ordering. It also verifies right-click-equivalent
editor zoom updates the parameter and closing/reopening retains 75%.
Pro Tools screen/control checks below are separate; recorded host automation
and session persistence were not tested.

Audio sweep coverage: Input, Output, Effect, Curve, Clip, Split, In, Bypass,
OS x2/x4/x8, and Phase at x2/x4/x8. Curve intentionally does not alter audio at
Effect=0; Phase intentionally does not alter audio at OS=x1. Clip is tested
with an above-full-scale signal. Finite output and expected waveform changes
are checked, not subjective audio quality or click-free switching.

## Earlier Pro Tools control observations

On earlier builds, GUI edits reached the host correctly for both skins:
Input +3.29 dB, Output −3.07 dB, Effect 40%, Curve +30, In/Split/Clip,
OS selection, Phase, and host Bypass. Twarch text/handles often remained stale
even when the host parameter changed. The latest debugging run reproduced
that discrepancy and isolated the layer size above.
See `host-controls-before-final-refresh.txt` and `twarch-before-redraw-fix.jpg`.

## Final Pro Tools visual/control checks

Test host: Pro Tools Developer 2025.6 arm64. Same installed binary SHA-1 as above.
Each GUI edit was checked against the host parameter, with screenshots used to
verify the rendered value or control position. The test source supplied live
input throughout; host audio was not recorded for waveform comparison.

| Control | Observed result |
| --- | --- |
| Original Input / Output | 0 → +5.43 dB / 0 → −2.71 dB; handles updated |
| Original Effect / Curve | 0 → 40% / 0 → +30; knobs updated |
| Twarch Input / Output | +5.43 → +2.02 dB / −2.71 → −5.69 dB; text and handles updated |
| Twarch Effect / Curve | 40 → 70% / +30 → +50; text and knobs updated |
| In / Split / Clip | Both skins: host values and full button images changed correctly |
| OS | x1 → x2 → x4 → x8 → x1; host and display agree |
| Phase | Min → Max → Min; host and display agree |
| Host Bypass | Off → On → Off; host parameter and bypass indicator agree; FX meter clears on bypass |
| PPM | IN/OUT active on both skins; FX responds to processing/In/Bypass changes |
| Skin round trips | Original → Twarch → Original, repeated; values preserved, no stale controls |
| Zoom | Twarch 50 → 75 → 50 via UI Zoom; final private percentage reads 50% |
| Auto fit | Original 75% → Twarch resets to 50%; complete interface visible |
| Host parameter reset | Pick action restores all four continuous controls; GUI follows immediately |

Evidence: `host-controls-final.txt`, `twarch-after-layer-fix.jpg`,
`original-after-layer-fix.jpg`, and `twarch-auto-fit.jpg`.

Restored state: Input/Output 0 dB, Effect 0%, Curve 0, Clip/Split/Bypass Off,
In On, OS x1, Phase Min, Original 50%. No source/build changes in this final
host verification turn.

Scope limits: this confirms manual control/GUI behavior and live metering.
Processor waveform behavior is covered by the separate 96-case test. Recorded
AAX automation, subjective listening, and host session save/reload were not
verified. Closing/reopening zoom retention was verified in the editor
integration test, not by closing the final Pro Tools instance.

Build/test commands: `../README.md`. Raw automated output is in this directory.
Earlier diagnostic chronology is preserved in `aax-diagnostic-history.md`;
its intermediate full-redraw approaches were unsuccessful and superseded.
