// Use pianoMidi.scd to get set up
// we use "m" that is a MidiOut

// First the middle F that is playing the whole song (pretty much)
(
~middleFPattern = Pseq([Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, 65,
	\amp, Pseq([0.6, Pwhite(0.2, 0.4, 7)], 1),
	\sustain, 1,
)], 15)
)
(
Pbind.new(
	\type, \midi,
	\midicmd, \noteOff,
	\midiout, m,
	\midinote, 65,
	\amp, 1,
	\sustain, 1,
).play;)

(
~getChords = {
	arg chord1, chord2;
	Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, Pseq([chord1, chord2], 1),
	\amp, 0.4,
	\sustain, 8,
	\dur, 8
)
};
~getMelody = {
	arg melody;
	Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, Pseq(melody, 1),
	\amp, Pseq([0.5,0.6,0.4, 0.5, 0.8], inf),
	\sustain, Pseq([3,1,2, 2, 8], inf),
	\dur, Pseq([3,1,2, 2, 8], inf)
);
};
)
// The first chord
(
~firstChordPattern = ~getChords.([62, 65, 72], [61, 65, 70]);
~firstMelodyPattern = ~getMelody.([48, 53, 60, 53, 58]);
~secondChordPattern = ~getChords.([63, 68, 72], [65, 68, 73]);
~secondMelodyPattern = ~getMelody.([53, 56, 60, 56, 58]);
~thirdChordPattern = ~getChords.([60, 63, 68], [58, 62, 67]);
~thirdMelodyPattern = ~getMelody.([56, 53, 46, 56, 50]);
~organChangePattern  = Pbind(
    \type, \midi,
    \midiout, m,
	// \chan, 0,               // MIDI channel (0-15)
    \midicmd, \program,     // MIDI command (program change)
	\progNum, Pseq([19]),  // Program numbers to change to
	\dur, 0
);
~forthPattern = Pseq([
Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
		\midinote, Pseq([
			Pseq([[42, 54, 58, 61, 65]], 2),
			Pseq([[44, 56, 60, 63, 65]], 2),
			Pseq([[41, 53, 56, 60, 63]], 2),
			Pseq([[34, 46, 53, 58, 61]], 2)
		], 1),
	\amp, 1,
	\sustain, 4,
	\dur, 8
),
	Pbind.new(
	\type, \midi,
	\midicmd, \noteOff,
	\midiout, m,
	\midinote, Pseq([[42, 54, 58, 61, 65]], 1),
	\amp, 1,
	\sustain, 0,
	\dur, 0
)
], 1);
)
(
m.control(0, ctlNum: 0, val: 0);
m.control(0, ctlNum: 32, val: 3);
m.program(0, 1);
t = TempoClock(100/60).permanent_(true);
~middleF = ~middleFPattern.play(t, quant: 8);
~firstPartPattern = Pseq([
	~firstChordPattern, Ppar([~firstChordPattern,~firstMelodyPattern], 2)
]);
~secondPartPattern = Pseq([
	Ppar([~secondChordPattern,~secondMelodyPattern], 2)
]
);
~thirdPartPattern = Pseq([
	Ppar([~thirdChordPattern,~thirdMelodyPattern], 2)
]
);

~piecePattern = Pseq([
	~firstPartPattern,
	~secondPartPattern,
	~thirdPartPattern,
	~organChangePattern,
	Pseq([~forthPattern], 2)
]);
~piece = ~piecePattern.play(t, quant:16);
)

~middleF.stop;
~piece.stop;
