// First oscillator
~b1 = Buffer.alloc(s, 2048);

(
~sig = Signal.sineFill(1024, [0.35, 0.12], [0,0]);
~wt = ~sig.asWavetable;
~b1.loadCollection(~wt);
)

~b1.plot;


({Osc.ar(~b1, 440, mul:0.05!2)}.play)


// Second oscillator
~b2 = Buffer.alloc(s, 2048);

(
~sig = Signal.sineFill(1024, [0.32, 0, 0.51, 0.37], [0,0]);
~wt = ~sig.asWavetable;
~b2.loadCollection(~wt);
)

~b2.plot;


({Osc.ar(~b2, 440, mul:0.02!2)}.play)


// Third oscillator
~b3 = Buffer.alloc(s, 2048);

(
~sig = Signal.sineFill(1024, [0.35, 0, 0, 0, 0.48, 0.65], [0,0]);
~wt = ~sig.asWavetable;
~b3.loadCollection(~wt);
)

~b3.plot;


({Osc.ar(~b3, 440, mul:0.002!2)}.play)

// Wind
({
	CombN.ar(

    WhiteNoise.ar ! 2,

		maxdelaytime: 0.01,
		delaytime: MouseX.kr(1/100, 1/440),
		decaytime: 0.2
	)
}.play;)


(
z = {

	HPF.ar(
	BBandPass.ar(
    WhiteNoise.ar ! 2,
		// MouseX.kr(20, 20000, \exponential),
		440,
		// MouseY.kr(0.0, 10.0, \linear), // bw
		0.01,
    0.8)
	+

	BBandPass.ar(
    WhiteNoise.ar ! 2,
		// MouseX.kr(20, 20000, \exponential),
		440 *2,
		// MouseY.kr(0.0, 10.0, \linear), // bw
		0.01,
    0.4) // mul
	+
	BBandPass.ar(
    WhiteNoise.ar ! 2,
		// MouseX.kr(20, 20000, \exponential),
		440 *3,
		// MouseY.kr(0.0, 10.0, \linear), // bw
		0.01,
    0.3) // mul
	+

	BBandPass.ar(
    WhiteNoise.ar ! 2,
		// MouseX.kr(20, 20000, \exponential),
		440 *4,
		// MouseY.kr(0.0, 10.0, \linear), // bw
		0.01,
    0.2) // mul
	+

	BBandPass.ar(
    WhiteNoise.ar ! 2,
		// MouseX.kr(20, 20000, \exponential),
		440 *5,
		// MouseY.kr(0.0, 10.0, \linear), // bw
		0.01,
		0.18), // mul
	freq: MouseX.kr(300, 600)
	)
}.play)

({
	(Saw.ar(440) + Saw.ar(440, phase:MouseX.kr(0,1))).scope
}.play;)

s.freqscope;