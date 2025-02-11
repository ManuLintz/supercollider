(
~startMidi = {
	MIDIClient.init;
	MIDIClient.destinations;
	MIDIIn.connectAll;
	m = MIDIOut.newByName("ARIUS", "ARIUS");
};


~ariusPresets = (
	\grandPiano1: (
		\lsb: 0,
		\program: 1,
	),
	\grandPiano2: (
		\lsb: 3,
		\program: 1,
	),
	\grandPiano3: (
		\lsb: 2,
		\program: 2,
	),
	\ePiano1: (
		\lsb: 0,
		\program: 6,
	),
	\ePiano2: (
		\lsb: 0,
		\program: 5,
	),
	\harpsichord: (
		\lsb: 0,
		\program: 6,
	),
	\vibraphone: (
		\lsb: 0,
		\program: 12,
	),
	\pipeOrgan: (
		\lsb: 1,
		\program: 20,
	),
	\jazzOrgan: (
		\lsb: 0,
		\program: 17,
	),
	\harpsichord: (
		\lsb: 0,
		\program: 49,
	),
);
~startMidi.();
~setAriusPreset = {
	arg preset;
	var presets, message;
	presets = ~ariusPresets.keys;
	// Check if preset exists
	if(presets.includes(preset), {
		message = preset.asString ++ " exists";
		m.control(0, ctlNum: 32, val: ~ariusPresets[preset][\lsb] - 1);
		m.program(0,  ~ariusPresets[preset][\program] -1);
	}, {
		message = preset.asString ++ " doesn't exist";
		//	presets.postln;
	});
	message.postln;
};

~setAriusPreset.(\grandPiano2);
/*Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, Pseq([65]),
	\amp, 1,
	\sustain, 1,
).play;*/


)

~stopAllMidiNotes.();
// check if this does the same:
m.allNotesOff(0);

// Log Midi events
(
MIDIdef.program(\debugArius, {
	arg val, chan, src;
	[val, chan, src].postln;
});
MIDIdef.noteOn(\debugNote, {
	arg val, num, chan, src;
		[val, num, chan, src].postln;
});
MIDIdef.cc(\debugAriusControl, {
	arg val, num, chan, src;
	"debugAriusControl".postln;
	[val, num, chan, src].postln;
});
)