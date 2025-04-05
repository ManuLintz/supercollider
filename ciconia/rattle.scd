(
SynthDef(\ciconiaRattle, {
	arg freq = 2000, amp = 0.5, gate = 1, pan = 0;
	var click, env, rattleEnv, rattle;

	// Single click sound (bill closure) with dynamic frequency
	// Ringz is amazing
	click = Ringz.ar(
			Impulse.ar(0),
			[freq, freq*1.4, freq*1.8],
			[0.03, 0.02, 0.01],
			0.3
		).sum;

	// Regular triggers instead of random Dust
	rattle = LFNoise2.kr().range(0.95, 1.05);

	// Overall envelope
	env = EnvGen.kr(
		Env.asr(0.01, 1, 0.2),
		gate,
		doneAction: 2
	);

	// Rattle envelope for natural dynamics
	rattleEnv = EnvGen.kr(
		Env.perc(0.05, 0.2),
		rattle,
		doneAction: 2
	);

	// Final sound with slight stereo spread
	Out.ar(0, Pan2.ar(
		click * rattleEnv * env * amp,
		pan

	));
}).add;

// Test
Synth(\ciconiaRattle, [
    \freq, 1000,
    \amp, 0.5

]);
)