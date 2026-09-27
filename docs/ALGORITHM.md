# Audio algorithm

JS Inflator uses **sample-by-sample waveshaping**: a nonlinear curve changes each sample's amplitude. Small and medium amplitudes can rise relative to peaks, increasing signal density while introducing harmonics. The shaping function has no attack/release envelope; PPM meters observe the signal without controlling it. This describes the open-source JSIF implementation, not a verified account of Sonnox's internal algorithm.

![JS Inflator audio algorithm: input limits, oversampling, waveshaping, dry delay and output mixing](../screenshots/js-inflator-algorithm.en.webp)

- **Input and Clip:** Input applies −12 to +12 dB. Clip optionally limits samples to ±1 before upsampling; a ±2 limit always applies at this point. The dry branch is taken after these operations.
- **Wet processing:** Upsample by 1×, 2×, 4× or 8×, apply the Curve-controlled waveshaper, optionally clip to ±1, then downsample. Oversampling uses the custom FIR or r8brain path to reduce aliasing, with CPU and latency costs. Turning Effect In off skips shaping and wet clipping while retaining resampling.
- **Band Split:** When enabled, filters at 240 Hz and 2400 Hz produce overlapping low, mid and high bands. Each band is shaped separately, then summed as `F(L) + F(G*M)/G + F(H)`, where `G` compensates mid-band gain.
- **Effect and Output:** Delay the dry branch to match the wet path, then mix `(1−E)*dry + E*wet`, where `E = Effect / 100`. Output applies −12 to 0 dB afterward. **Effect = 0% is not full bypass:** Input and pre-clipping remain active. Host Bypass uses its own latency-compensated path.

<details>
<summary>Waveshaping formula and overload behavior</summary>

Let `a = abs(x)` and `c = Curve / 100`, using the displayed Curve value from −50 to +50. Define `D = 0.0625 − 0.25*c + 0.25*c²`:

```text
0 ≤ a ≤ 1: F(a) = (1.5+c)*a − 2*c*a² + (c−0.5)*a³ − D*a²*(1−a)²
1 < a < 2: F(a) = 2*a − a²
    a ≥ 2: F(a) = 0

y = sign(x) * F(abs(x))
```

At Curve = 0, an amplitude of 0.5 becomes approximately 0.6836, while 1 remains 1. Above 1, the wet waveshaper output folds back: 1.5 becomes 0.75 and 2 becomes 0. This is why more Input gain does not always produce a louder wet signal. Clip is not a guarantee that the final output is true-peak limited.

</details>

Source: [waveshaper and processing chain](../source/JSIF_processor.cpp) (`process_inflator`, `processAudio`) and [band-split coefficients](../source/JSIF_processor.h) (`Band_Split_set`). AAX and VST3 use this shared processing core.

[← Back to README](../README.md)
