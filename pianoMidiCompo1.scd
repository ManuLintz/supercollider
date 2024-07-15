// Use pianoMidi.scd to get set up
// we use "m" that is a MidiOut

// First the middle F that is playing the whole song (pretty much)
(
~middleFPattern = Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, 65,
	\amp, Pseq([0.6, Pwhite(0.2, 0.4, 7)], inf)
	\sustain, 1,
/*	\amp, 80*/
)
)

// The first chord
(
~firstChordPattern = Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, Pseq([[62, 65, 72], [61, 65, 70]], inf),
	\amp, 0.6,
	\sustain, 8,
	\dur, 8
/*	\amp, 80*/
)
)
// The first melody
(
~firstMelodyPattern = Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, Pseq([48, 53, 60, 53, 58], inf),
	\amp, 0.6,
	\sustain, 8,
	\dur, Pseq([3,1,2, 2, 8], inf)
);
)

t = TempoClock(100/60).permanent_(true);

(
~middleF = ~middleFPattern.play(t, quant: 8);
~firstChord = ~firstChordPattern.play(t, quant:16);
~firstMelody = ~firstMelodyPattern.play(t, quant:32);
)

~middleF.stop;
~firstChord = ~firstChordPattern.play(t, quant:0);

~firstChord.stop;