SynthDef(\ciconiaRattle, {
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
});

(
SynthDef(\ciconiaRattle, {
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
/*
// Test
Synth(\storkRattle, [
    \freq, 1000,
    \rattleSpeed, 15,
    \rattleRandomness, 0.3,
    \amp, 0.5

]);*/
)