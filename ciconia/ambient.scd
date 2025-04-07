(
SynthDef(\ambient, {
	arg freq = 2000, amp = 0.5, gate = 1, pan = 0;
	var sig, env, rattle;

	sig = Ringz.ar(WhiteNoise.ar(0.005), freq, 0.5);
	env = EnvGen.kr(
		Env.asr(attackTime: 0.2, sustainLevel: 1, releaseTime: 1 ),
		doneAction: Done.freeSelf,
		gate: gate
	);

	// Final sound with slight stereo spread
	Out.ar(0, Pan2.ar(
		sig * env * amp,
		pan
	));
}).add;
)

(
~circoniaPattern = Pbind(
    \instrument, \ambient,
    // Simpler rhythm pattern
    \dur, Pseq([
		Pseq([1], 1),
		Pseq([1], 1),
		Pseq([1], 1)
	]),
	\freq, Pseq([
		400,
		600,
		[400, 650, 850],
	]
	),
    \amp, 0.9,
    \pan, Pwhite(-0.8, 0.8),
	\strum, Pwrand([1/16, 2/16, 3/16],[4, 2, 1], inf),
	// \strum, 1/12
).play;
)
