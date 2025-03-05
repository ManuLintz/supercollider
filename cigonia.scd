// White Stork bill-clattering synthesizer
(
SynthDef(\storkRattle, {
    arg freq = 2000, rattleSpeed = 15, rattleRandomness = 0.3, amp = 0.5, gate = 1;
    var click, env, rattleEnv, triggerRate, rattle;

    // Map rattleSpeed to frequency (faster = higher pitch)
    // Base frequency scaled by normalized rattleSpeed (15 is the "standard" speed)
    var scaledFreq = freq * (rattleSpeed / 15).pow(0.5);

    // Single click sound (bill closure) with dynamic frequency
    click = Mix([
        // Wood-like impact
        Impulse.ar(0) * EnvGen.kr(Env.perc(0.001, 0.03)),
        // Resonant body with frequency linked to rattleSpeed
        Ringz.ar(
            Impulse.ar(0),
            [scaledFreq, scaledFreq*1.4, scaledFreq*1.8],
            [0.03, 0.02, 0.01],
            0.3
        ).sum
    ]);

    // Much less randomness for a more regular rattle
    triggerRate = rattleSpeed * LFNoise2.kr(
        rattleSpeed * 0.1
    ).range(0.95, 1.05);

    // Regular triggers instead of random Dust
    rattle = Impulse.kr(triggerRate);

    // Overall envelope
    env = EnvGen.kr(
        Env.asr(0.01, 1, 0.2),
        gate,
        doneAction: 2
    );

    // Rattle envelope for natural dynamics
    rattleEnv = EnvGen.kr(
        Env.perc(0.05, 0.2),
        rattle
    );

    // Final sound with slight stereo spread
    Out.ar(0, Pan2.ar(
        click * rattleEnv * env * amp,
        LFNoise2.kr(1).range(-0.3, 0.3)
    ));
}).add;
);

// Pattern for stork rattling behavior with synchronized parameters
(
~storkPattern = Pbind(
    \instrument, \storkRattle,
    // Smoothly changing durations using Pseg
    \dur, Pseg(
        Pseq([0.8, 0.2, 0.8], inf),  // Start at 0.8, go to 0.2, back to 0.8
        Pseq([8, 1], inf),           // Take 8 beats to go down, 8 beats to go up
        \sin                         // Curved transition
    ),
    // Base frequency stays constant
    \freq, 1200,
    // Rattle speed inversely follows duration pattern
    \rattleSpeed, Pfunc { |ev|
        // Convert duration to speed: shorter duration = faster speed
        // Map 0.2->25, 0.8->10
        (20 - (ev.dur * 15)).clip(10, 25);
    },
    // Consistent amplitude
    \amp, 0.5,
    // Less randomness
    \rattleRandomness, 0.1
).play;
)

// Stop the pattern
~storkPattern.stop;

// Or play a single rattle
(
Synth(\storkRattle, [
    \freq, 2000,
    \rattleSpeed, 15,
    \rattleRandomness, 0.3,
    \amp, 0.5
]);
)