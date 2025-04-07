(
SynthDef(\ciconiaRattle, {
	arg freq = 2000, amp = 0.5, gate = 1, pan = 0;
	var click, env, rattle;

	// Single click sound (bill closure) with dynamic frequency
	// Ringz is amazing
	click = Ringz.ar(
			Impulse.ar(0),
			[freq, freq*1.4, freq*1.8],
			[0.03, 0.02, 0.01],
			0.3
		).sum;


	// Rattle envelope for natural dynamics
	env = EnvGen.kr(
		Env.perc(0.1, 0.4),
		doneAction: 0
	);

	// Final sound with slight stereo spread
	Out.ar(0, Pan2.ar(
		click * env * amp,
		pan
	));
}).add;
)

(
~circoniaPattern = Pbind(
    \instrument, \ciconiaRattle,
    // Simpler rhythm pattern
    \dur, Pseq([
		Pseq([1], 1),
		Pseq([1], 1),
		Pseq([1], 1)
	]),
	\freq, Pseq([
		400,
		[400, 600, 800],
		[400, 650, 850],
	]
	),
    \amp, 0.9,
    \pan, Pwhite(-0.8, 0.8),
	\strum, Pwrand([1/16, 2/16, 3/16],[4, 2, 1], inf),
	// \strum, 1/12
).play;
)
