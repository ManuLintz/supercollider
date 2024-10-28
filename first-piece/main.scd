
(
SynthDef(\organicFluteyDrone, {
	arg freq = 200, rq = 0.0025, gate = 1, atk = 1,
	rel = 4, pan = 0, amp = 0.5, out = 0;
	var sig, env;
	env = EnvGen.kr( Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = BrownNoise.ar(1);
	sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
	sig = sig * env;
	sig = sig * (1 + SinOsc.kr(1/4, Rand(0, 1), 0.1));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

~reverb = SynthDef(\reverb, {
	arg in = 0, out = 0, mix = 0.25;
	var sig, wet;
	sig = In.ar(in, 2);
	wet = DelayN.ar(sig, 0.03, 0.03); // pre-delay
	5.do({ |n|
		var del;
		// 1st value randomly selected between 0.05 - 0.1
		// 2nd between 0.333 - 0.05
		// 3rd between 0.025 - 0.333, etc.
		del = Rand(0.1 / (n + 2), 0.1 / (n + 1));
		wet = AllpassN.ar(wet, 0.1, del, 3);
	});
	sig = sig + (wet * mix);
	Out.ar(out, sig);
}).add;

~volume = SynthDef(\volume, {
	arg in = 0, out = 0, amp = 1;
	var sig;
	sig = In.ar(in, 2);
	sig = sig * amp;
	Out.ar(out, sig);

}).add;

s.newBusAllocators;
~bus = Bus.audio(s, 2);
~beepVolumeBus = Bus.audio(s, 2);
~reverbSynth = Synth(\reverb, [in: ~bus, out: 0]);
~beepVolumeSynth = Synth(\volume, [\in, ~beepVolumeBus]);


~fluteyDronesDef = (
	x: (
		freq: 110,
		tempFreq: 110,
		amp: 0.1,
		synth: 0
	),
		y: (
		freq: 220,
		tempFreq: 220,
		amp: 0.06,
		synth: 0
	),
		z: (
		freq: 330,
		tempFreq: 330,
		amp: 0.06,
		synth: 0
	),
		a: (
		freq: 550,
		tempFreq: 550,
		amp: 0.02,
		synth: 0
	),
);

~startFluteyDrone = {
	~fluteyDronesDef.do({ |droneDef|
		droneDef[\synth] = Synth(\organicFluteyDrone, [
			\freq, droneDef[\freq], \amp, droneDef[\amp], \out, ~bus
		]);
	})
};
~stopFluteyDrone = {
	~fluteyDronesDef.do({ |droneDef|
		droneDef[\synth].set(\gate, 0);
	})
};

~firstPiece = {
	"let's get started".postln;
	~startFluteyDrone.value();
};

SynthDef(\kick, {
	arg boost = 1.1, pan = 0, amp = 1, out = 0;
	var sig, freqSweep, env;
	freqSweep = Env([3000, 60, 20], [0.025, 1], [-8, -4]).ar;
	env = Env([0, 1, 0], [0.005, 0.5], [1, -12]).ar(2);
	sig = SinOsc.ar(freqSweep);
	sig = (sig * boost).clip(-1, 1);
	sig = sig.distort * 4;
	sig = Pan2.ar(sig, pan, env) * amp;
	Out.ar(out, sig);
}).add;

~kickPattern = Pbind(
	\instrument, \kick,
    \amp, Pwhite(0.6, 0.8, inf),
	    \pan, Pwhite(-0.8, 0.8, inf),
	\dur, Pseq([Pseq([1/4, Rest(1/2), 1/4,1/4, 1/2]), Pseq([1/4, Rest(1/2), 1/16,1/16, 1/16, 1/16, 1/2] )], inf ),
	\out, Pwrand([~bus, 0],[1/5, 1], inf)
);

SynthDef(\coolBeep, {
    |freq = 440, amp = 0.2, decay = 0.1, attack = 0.01, detune = 2, distAmt = 0.5, out = 0, pan = 0|
    var beep, dist, env, filtered;
    // Generate a sine wave with a bit of detuning for that analog feel
    beep = SinOsc.ar(freq, 0) * 0.8 + SinOsc.ar(freq * (1 + detune/1000), 0) * 0.2;

    // Add subtle distortion to give it some analog-style warmth
    dist = beep * (1 + distAmt * 2);
	dist = dist.tanh; // Use tanh for soft clipping
	// dist = dist.clip(-0.5, 0.5);
	// dist = dist.sign * (dist.abs ** 0.2);  // Exponential distortion

    // Create an envelope with a percussive attack and decay
    env = EnvGen.ar(Env.perc(attack, decay), doneAction: 2); // Attack and Decay only for Env.perc

    // Filter the sound to give a more focused tone
    filtered = BPF.ar(dist, freq * 2, 0.5); // Band-pass filter for punchiness

	filtered = Pan2.ar(filtered, pan);

    // Control the output level with the envelope
    Out.ar(out, filtered * env * amp);
}).add;


)
~firstPiece.value();
~stopFluteyDrone.value();
~k = ~kickPattern.play;
~k.stop();


x.set(\freq, Line.kr(110, 200, 3));

(

p = Pbindef(
	\coolPattern,
    \instrument, \coolBeep,
	\degree, Pseq([0], inf),      // 0 is the first degree (tonic) in the scale
	\dur, Pseq([
		Pseq([1/2], 2),
		Pseq([1/4], 1),
		Pseq([3/4], 1),
		// Rest(1),
	],
	inf),
	\octave, Pseq([
		Pseq([3], 3),
		Pseq([4], 4),
		Pseq([3], 9),
	], inf),
	\amp, Pseq([1.7, 1.5], inf),
	\decay, 0.4,
	\out, ~beepVolumeBus,
	\pan, Pwhite(-0.7, 0.7)
).play;
)

p.stop;
(
~freqBus = Bus.control(s, 1);

Pbind(
	\type, \set,
	\synth, Prand([x, y, z, a], inf),
	\id, Pfunc { |event|
		event[\synth].nodeID
	},

    // Fetch frequency, add random offset, and read from the Bus
    \freq, Pfunc { |event|
        var synth = event[\synth];

        // Request the synth's frequency and store it on the Bus
        synth.get(\freq, { |value|
            ~freqBus.set(value); // Store in bus
        });
		~freqBus.getSynchronous.postln;
        // Read from the Bus, adding a random offset (1-10)
        ~freqBus.getSynchronous + 10.rand;
    },
).play;
)

~dronePbinds = ~fluteyDronesDef.collect({
	|droneDef|
	Pbind(
		\type, \set,
		\id, droneDef[\synth],
		\freq, Pfunc {
			var newFreq = droneDef[\tempFreq] + 10.rand2;
			droneDef[\tempFreq] = newFreq;
			newFreq.postln;
			newFreq;
		},
		\dur, Pwhite(1, 3, inf);
	).play;

});


~dronePbinds.do({
	|dronePind|  dronePind.stop;
})


~fluteyDronesDef.do({
	|droneDef|
	Pbind(
		\type, \set,
		\id, droneDef[\synth],
		\freq, droneDef[\freq],
		\dur, Pwhite(1, 3, 1);
	).play;
});