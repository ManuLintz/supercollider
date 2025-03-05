// A synth that receives a signal and output it with "distance"
(
SynthDef(\distance, {
	arg distance = 0.5, in, out = 0, panAmp, panFreq;
	// here logic to add distance
	Out.ar(out, in);
}).add;
)