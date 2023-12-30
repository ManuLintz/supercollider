(
// First oscillator
~b1 = Buffer.alloc(s, 2048);
~sig = Signal.sineFill(1024, [0.35, 0.12], [0,0]);
~wt = ~sig.asWavetable;
~b1.loadCollection(~wt);
//~b1.plot;
// Second oscillator
~b2 = Buffer.alloc(s, 2048);
~sig = Signal.sineFill(1024, [0.32, 0, 0.51, 0.37], [0,0]);
~wt = ~sig.asWavetable;
~b2.loadCollection(~wt);
// ~b2.plot;
// Third oscillator
~b3 = Buffer.alloc(s, 2048);
~sig = Signal.sineFill(1024, [0.35, 0, 0, 0, 0.48, 0.65], [0,0]);
~wt = ~sig.asWavetable;
~b3.loadCollection(~wt);
// ~b3.plot;

SynthDef(
	\chouetteFlute, {
		arg freq=440, out=0, gate=1, release=1.2, velocity=1;
		var sig, globalAmplitudeEnv,
		osc1, osc2, osc3, noise,
		osc1Env, osc2Env, osc3Env, noiseEnv, lowPassCutoffMultiplicator,
		osc1Lfo, osc2Lfo, osc3Lfo, noiseLfo;

		osc1Lfo = 1 + (SinOsc.kr(1, mul:0.03) * SinOsc.kr(2, mul:0.1));
		osc2Lfo = 1 + (SinOsc.kr(1, mul:0.13) * SinOsc.kr(2, mul:0.15));
		osc3Lfo = 1 + (SinOsc.kr(1, mul:0.13) * SinOsc.kr(2, mul:0.15));
		noiseLfo = 1 + SinOsc.kr(0.98, mul:0.05);
		osc1 = Osc.ar(~b1, freq, mul:0.5!2) * osc1Lfo;
		osc2 = Osc.ar(~b2, freq, mul:0.2!2) * osc2Lfo;
		osc3 = Osc.ar(~b3, freq, mul:0.02!2) * osc3Lfo;
		globalAmplitudeEnv = EnvGen.kr(
			Env.adsr(attackTime: 0.2, releaseTime:release, peakLevel: velocity),
			gate:gate,
			// doneAction: 2 // improve this
		);

		sig = osc1 + osc2 + osc3;

		~amplitudes = [0.8, 0.4, 0.3, 0.2, 0.18];
		noise = {
			var temp, sum;
			sum = 0;
			5.do({
				arg x;
				temp = BBandPass.ar(
					WhiteNoise.ar ! 2,
					freq * (x + 1),
					0.01,
					mul: ~amplitudes[x]);
				sum = sum + temp;
			});

			HPF.ar(
				sum,
				freq: MouseX.kr(300, 600)
			);
		} * noiseLfo;
		sig = ((osc1 + osc2 + osc3) * 0.1 + (noise * 2));
		sig = sig * globalAmplitudeEnv;
		lowPassCutoffMultiplicator = 4.5;
		sig = BLowPass.ar(sig, freq: freq * lowPassCutoffMultiplicator * globalAmplitudeEnv);
		sig = FreeVerb.ar(sig, room:0.7);
		Out.ar(out, sig);
	}
).add;
)

(
x = Synth.new(
	\chouetteFlute,
	args: [freq: 440]
);
x.set(\gate, 1);
)
x.set(\gate, 1);
x.set(\freq, 660);
x.set(\freq, 440);
x.set(\gate, 0);
(
y = Synth.new(
	\chouetteFlute,
	args: [ \freq: 660]
);
y.set(\gate, 1);
)
y.set(\gate, 1);
y.set(\gate, 0);



x.set(\freq, 880);
x.set(\freq, 440);
x.set(\gate, 0);
s.plotTree;
x.free;