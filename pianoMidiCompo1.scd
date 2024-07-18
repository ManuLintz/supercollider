// Use pianoMidi.scd to get set up
// we use "m" that is a MidiOut

// First the middle F that is playing the whole song (pretty much)
(
~middleFPattern = Pseq([Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, 65,
	\amp, Pseq([
		Pseq([0.6, Pwhite(0.2, 0.4, 7)], 1),
		Pseq([Rest(), Pwhite(0.2, 0.4, 7)], 14),
	]),
	\sustain, 1,
)])
)
(
Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, Pseq([65]),
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
		\strum, Pwrand([1/16, 2/16, 3/16],[4, 2, 1], inf),
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
		\amp, Pseq([0.5,0.6,0.4, 0.5, 0.5], inf),
		\sustain, Pseq([3,1,2, 2, 8], inf),
		\dur, Pseq([3,1,2, 2, 8], inf)
	);
};

~getTransitionPattern = {
	arg notes;
	Pseq([
		Ppar([
			Pbind.new(
				\type, \midi,
				\midicmd, \noteOn,
				\midiout, m,
				\midinote, Pseq([notes[0], notes[1]]),
				\amp, Pseq([0.5,0.6,0.7, 0.8], inf),
				\sustain, Pseq([2, 2], inf),
				\dur, Pseq([2, 2], inf)
			),
			Pbind.new(
				\type, \midi,
				\midicmd, \noteOn,
				\midiout, m,
				\midinote, Pseq([notes[4], notes[2], notes[3], notes[2]]),
				\amp, Pexprand(0.4, 0.6, inf), // ([0.5,0.4,0.7, 0.6], inf),
				\sustain, Pseq([1, 1], inf),
				\dur, Pseq([1, 1], inf)
			),
		],1),
	], 1)
}
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
	\midiout, m,      // MIDI channel (0-15)
	\midicmd, \program,     // MIDI command (program change)
	\progNum, Pseq([19]),  // Program numbers to change to
	\dur, 0
);

~pianoChangePattern  = Ppar([
	Pbind(
		\type, \midi,
		\midiout, m,
		// \chan, 0,               // MIDI channel (0-15)
		\midicmd, \program,     // MIDI command (program change)
		\progNum, Pseq([1]),  // Program numbers to change to
		\dur, 0
)], 1);

~forthPattern = Ppar([
	Pseq([
		Pbind.new(
			\type, \midi,
			\midicmd, \noteOn,
			\midiout, m,
			\midinote, Pseq([
				Pseq([[42, 54, 58, 61, 65]]),
			], 1),
			\amp, 1,
			\sustain, 4,
			\dur, 8
		),
		/*Pbind.new(
			\type, \midi,
			\midicmd, \noteOn,
			\midiout, m,
			\midinote, Pseq([

				Pseq([[36, 48]], 1),
			], 1),
			\amp, Prand([0.7, 0.8, 0.84], inf),
			\sustain, 4,
			\dur, 4,
			\strum, Pwrand([2/16, 1/16, 4/16],[4, 2, 1], inf),
		)*/
	], 2),
	Pbind.new(
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, m,
		\midinote, Pseq([
			Pseq([
				70, 73, 70, 77,
				73, 77, 73, 82,
				77, 82, 77, 89,
				82, 89, 82, 94
			].mirror2, 2),
		], 1),
		\amp, 0.5,
		\sustain, 0.25,
		\dur, 0.25,
	),
]);

~firstTransitionPattern = ~getTransitionPattern.([42, 54, 58, 61, 65]);
~secondTransitionPattern = ~getTransitionPattern.([44, 56, 60, 63, 65]);
~thirdTransitionPattern = ~getTransitionPattern.([41, 53, 56, 60, 65]);
~forthTransitionPattern = ~getTransitionPattern.([34, 46, 53, 58, 61]);
)
(
t = TempoClock(100/60).permanent_(true);
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
	Rest(8),
	~firstPartPattern,
	~secondPartPattern,
	~thirdPartPattern,
	Pseq([~forthPattern], 1),
	Pseq([~firstTransitionPattern], 2),
	Pseq([~secondTransitionPattern], 2),
	Pseq([~thirdTransitionPattern], 2),
	Pseq([~forthTransitionPattern], 2),
	Pseq([~firstTransitionPattern], 2),
	Pseq([~secondTransitionPattern], 2),
	Pseq([~thirdTransitionPattern], 2),
	Pbind.new(
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, m,
		\midinote, Pseq([
			[34, 46, 53, 58, 61]
		], 1),
		\amp, Prand([[0.5, 0.6, 0.65]], inf),
		\sustain, 8,
		\dur, 10,
		\strum, Pwrand([1/16, 2/16, 3/16],[4, 2, 1], inf),
	)
]);


~middleF = ~middleFPattern.play(t, quant: 8);
~piece = ~piecePattern.play(t, quant:16);
)

~middleF.stop;
~piece.stop;
