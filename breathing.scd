// More natural breathing rhythm synthesizer
(
SynthDef(\breathing, {
    arg freq = 500, amp = 0.5, dur = 1, inhale = 1, pan = 0;
    var snd, env, filterEnv;

    // Smoother envelope shapes for inhale and exhale
    env = EnvGen.kr(
        Env.new(
            levels: [0, amp * 0.7, amp, amp * 0.8, 0],
            times: [dur * 0.15, dur * 0.25, dur * 0.3, dur * 0.3],
            curve: if(inhale == 1, [2, 0, -1, -2], [-2, 0, 1, 2])
        ),
        doneAction: 2
    );

    // Gentler filter movement
    filterEnv = EnvGen.kr(
        Env.new(
            levels: if(inhale == 1,
                [freq * 0.7, freq, freq * 0.9],
                [freq * 1.2, freq, freq * 0.8]
            ),
            times: [dur * 0.5, dur * 0.5],
            curve: [-1, 1]
        )
    );

    // More pink noise for warmth, less white noise for "air"
    snd = (PinkNoise.ar * 0.7) + (WhiteNoise.ar * 0.3);

    // Gentler filtering
    snd = BPF.ar(
        snd,
        [filterEnv, filterEnv * 1.1],
        [0.4, 0.5]
    ).sum;

    // Additional warmth
    snd = RLPF.ar(snd, filterEnv * 1.2, 0.7);

    // Remove the modulation, add very subtle movement
    snd = snd * (1 + (SinOsc.kr(3) * 0.03));

    // Final envelope and stereo positioning
    snd = Pan2.ar(snd * env, pan);

    Out.ar(0, snd * 0.25);
}).add;
);

// Pattern for breathing rhythm
(
~breathingPattern = Pbind(
    \instrument, \breathing,
    // Alternating between inhale and exhale
    \inhale, Pseq([1, 0], inf),
    // Simpler rhythm pattern
    \dur, Pseq([
        2, 2,        // Regular breath
        1.5, 1.5,
		1, 1,// Slightly quicker
        2, 2,         // Regular again
		4, 4
    ], inf),
    // Lower frequencies for more "huuuh" quality
    \freq, Pwhite(200, 500),
    // Consistent, gentle amplitude
    \amp, Pwhite(0.5, 0.6),
    // Less stereo movement
    \pan, Pwhite(-0.2, 0.2)
).play;
)

// Stop the pattern
~breathingPattern.stop;