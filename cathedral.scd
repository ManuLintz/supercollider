// Cathedral organ synthesizer
(
SynthDef(\cathedralOrgan, {
    arg freq = 440, amp = 0.5, gate = 1;
    var num = 2; // Number of oscillators for chorus effect
    var detune = 0.1; // Detune amount
    var snd, env;

    // Gentle envelope that won't retrigger with legato
    env = EnvGen.kr(
        Env.adsr(
            attackTime: 0.2,
            decayTime: 1,
            sustainLevel: 0.8,
            releaseTime: 4,
            curve: \sin
        ),
        gate,
        doneAction: 2
    );

    // Multiple detuned oscillators for rich organ sound
    snd = Mix.fill(num, {|i|
        var detuneFactor = i * detune - (detune * num/2);
		// detuneFactor.postln;
        var oscillator = SinOsc.ar(freq * (1 + detuneFactor));
        var subOscillator = SinOsc.ar(freq * 0.5 * (1 + detuneFactor)) * 0.3;

        oscillator
    });

    // Additional harmonics for organ-like character
	snd = snd + (SinOsc.ar(freq * 2) * 0.1);
	snd = snd + (SinOsc.ar(freq * 4) * 0.05);

    // Subtle chorus effect
    snd = snd + DelayC.ar(snd, 0.03, LFNoise2.kr(0.1).range(0.01, 0.02)) * 0.2;

    // Filter for warmth
    snd = LPF.ar(snd, 5000);

    // Output with stereo spread
    snd = Splay.ar(snd) * env * amp * 0.15;
    Out.ar(0, snd);
}).add;
);

// Define the chord progression with longer durations
(
~chordProgression = Pbind(
    \instrument, \cathedralOrgan,
    \dur, Pseq([8, 2, 8, 2], inf),

    \midinote, Pseq([
        Pseq([[41, 53]], 1),
        Pseq([[65, 68]], 1),
		Pseq([[45, 60]], 1),
        Pseq([[55, 70]], 1),
    ], inf),
    \amp, 0.2,
    \legato, 1.1  // What does it do ?
).play;
)

// Stop the progression
~chordProgression.stop;