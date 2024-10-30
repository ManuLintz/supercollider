(
~startMidi = {
	MIDIClient.init;
	MIDIClient.destinations;
	MIDIIn.connectAll;
	m = MIDIOut.newByName("Arturia MiniLab mkII", "Arturia MiniLab mkII");
};

~startMidi.();
MIDIdef.program(\debugProgram, {
	arg val, chan, src;
		"\debugProgram".postln;
	[val, chan, src].postln;
});
MIDIdef.noteOn(\debugNote, {
	arg val, num, chan, src;
		"\debugNote".postln;
		[val, num, chan, src].postln;
});
MIDIdef.cc(\debugControl, {
	arg val, num, chan, src;
	"debugControl".postln;
	[val, num, chan, src].postln;
});

MIDIdef.noteOn(\startDrone, {
	arg val, num, chan, src;
	"\startDrone".postln;
	[val, num, chan, src].postln;
	~firstPiece.value();
}, 36, 9);

MIDIdef.noteOn(\stopDrone, {
	arg val, num, chan, src;
	"\stopDrone".postln;
	[val, num, chan, src].postln;
	~stopFluteyDrone.value();
}, 37, 9);

MIDIdef.noteOn(\startCoolPattern, {
	arg val, num, chan, src;
	"\\startCoolPattern".postln;
	[val, num, chan, src].postln;
	~startCoolPattern.();
}, 38, 9);

MIDIdef.noteOn(\stopCoolPattern, {
	arg val, num, chan, src;
	"\stopCoolPattern".postln;
	[val, num, chan, src].postln;
	p.stop;
}, 39, 9);

MIDIdef.cc(\controlDroneVolume, {
	arg val, num, chan, src;
	"\controlDroneVolume".postln;
	[val, num, chan, src].postln;
	val.linlin(0,127, 0, 3).postln;
	~droneVolumeSynth.set(\amp, val.linlin(0,127, 0, 3));
}, 74);

MIDIdef.cc(\controlCoolPatternVolume, {
	arg val, num, chan, src;
	"\controlCoolPatternVolume".postln;
	[val, num, chan, src].postln;
	~beepVolumeSynth.set(\amp, val.linlin(0,127, 0, 3))
}, 71));
)