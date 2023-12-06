MIDIClient.init;
MIDIIn.connectAll;

f = Synth.new(\chouetteFlute, [\gate:0]);

(
MIDIdef.noteOn(\onNoteOne, {
	arg velocity, noteNumber, channel, source;
	[velocity, noteNumber, channel, source].postln;
	f.set(\freq, noteNumber.midicps, \gate, 1, \velocity, velocity.linexp(1,127, 0.1, 1));
});
)

(
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