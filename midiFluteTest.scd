(
SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig, del;
	sig = In.ar(in, 2);
	sig = sig + (GVerb.ar(sig, 200, 10) * 0.1);
	Out.ar(out, sig);
}).add;
)

(
MIDIClient.init;
MIDIIn.connectAll;
f = Synth.new(\chouetteFlute, [\gate:0]);
MIDIdef.noteOn(\onNoteOne, {
	arg velocity, noteNumber, channel, source;
	[velocity, noteNumber, channel, source].postln;
	f.set(\freq, noteNumber.midicps, \gate, 1, \velocity, velocity.linexp(1,127, 0.1, 1));
});

MIDIdef.noteOff(\onNoteOff, {
	arg velocity, noteNumber, channel, source;
	[velocity, noteNumber, channel, source].postln;
	f.set(\freq, noteNumber.midicps, \gate, 0);
});
)

f.set(\gate, 0);


Pbind(
		\instrument, \chouetteFlute,
		\dur, 0.5,
		\degree, Pseq([5,7,8,9], inf),
	// \sustain, 0.15,
	\legato, 1
	)

s.meter;

~outsideVariable = 1;

(
r = Routine.new({
	f = Synth.new(\chouetteFlute, [\gate:0]);
	g = Synth.new(\chouetteFlute, [\gate:0]);
	inf.do({
		2.do({
			arg iteration, index;
			f.set(\freq,  55.midicps, \gate, 1);
			g.set(\freq,  31.midicps, \gate, 1, \velocity, ~outsideVariable);
			0.3.wait;
			f.set(\freq,  60.midicps, \gate, 1);
			0.3.wait;
			f.set(\freq,  63.midicps, \gate, 1);
			g.set(\freq,  43.midicps, \gate, 0);
			0.3.wait;
			f.set(\freq,  65.midicps, \gate, 1);
			0.3.wait;
			f.set(\freq,  67.midicps, \gate, 1);
			0.1.wait;
			f.set(\freq,  65.midicps, \gate, 0);
			0.1.wait;
			f.set(\freq,  65.midicps, \gate, 1, \velocity, 0.4);
			0.3.wait;
			f.set(\freq,  63.midicps, \gate, 0, \velocity, 0.9);
			g.set(\freq,  75.midicps, \gate, 1, \velocity, 0.2);
			0.1.wait;
			g.set(\freq,  74.midicps, \gate, 1, \velocity, 0.2);
			0.1.wait;
			g.set(\freq,  75.midicps, \gate, 1, \velocity, 0.2);
			0.1.wait;
			g.set(\freq,  75.midicps, \gate, 0, \velocity, 0.9);
			1.5.wait;
		});
	});

});
r.play;
)

r.stop;
r.play;
g = Synth.new(\chouetteFlute, [\gate:0]);
g.set(\freq,  42.midicps, \gate, 1);
g.free;
