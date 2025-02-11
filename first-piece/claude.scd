// Whale song synthesizer
(
SynthDef(\whaleSong, {
    arg freq = 200, amp = 0.5, gate = 1, rel = 1,
        modSpeed = 0.5, modDepth = 50,
        filterFreq = 1000, rq = 0.5;

    var carrier, modulator, env, filtered;
   @
    // Envelope for overall amplitude
    env = EnvGen.kr(
        Env.adsr(attackTime: 2, decayTime: 1, sustainLevel: 0.8, releaseTime: 4),
        gate,
        doneAction: 2
    );

    // Frequency modulation for the whale-like wobble
    modulator = SinOsc.kr(modSpeed).range(freq - modDepth, freq + modDepth);

    // Main oscillator with slight detuning for richness
    carrier = Mix([
        SinOsc.ar(modulator),
        SinOsc.ar(modulator * 1.01),
        SinOsc.ar(modulator * 0.99)
    ]) * 0.33;

    // Resonant filter for shaping the timbre
    filtered = RLPF.ar(
        carrier,
        filterFreq * LFNoise1.kr(0.2).exprange(0.5, 2),
        rq
    );

    // Final output with envelope and amplitude control
    Out.ar(0, Pan2.ar(filtered * env * amp));
}).add;
);

// Example usage
(
~whalePattern = Pbind(
    \instrument, \whaleSong,
    \dur, Prand([1, 2, 3], inf),
    \freq, Pwhite(100, 200),
    \amp, 0.4,
    \modSpeed, Pwhite(0.2, 0.8),
    \modDepth, Pwhite(30, 60),
    \filterFreq, Pwhite(400, 1200),
    \rq, 0.3
).play;
)

// Stop the pattern
~whalePattern.stop;

// Or play individual notes
(
Synth(\whaleSong, [
    \freq, 200,
    \modSpeed, 0.4,
    \modDepth, 40,
    \filterFreq, 800
]);
)