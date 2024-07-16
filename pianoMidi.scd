MIDIClient.init;
MIDIClient.destinations;

m = MIDIOut.newByName("ARIUS", "ARIUS");
MIDIIn.connectAll;

m.noteOn(4, 50, 60);
(
m.noteOn(0, 60, 30);
m.noteOn(0, 64, 30);
)

m.noteOn(12, 4090, 88);
(
m.noteOff(7, 60, 60);
m.noteOff(7, 64, 60);
)

(
m.noteOn(0);
m.noteOff(0);
)
/*
16 => groovy organ
19 => orgue d'église
11 => xylo
6  => clavecin
4  => autre orgue groovy
5  => 80's
1  => Piano
0  => Piano
7 => Piano
48 => Cordes / violon
[ 0, 0, -611493605 ]
[ 48, 0, -611493605 ]
[ 16, 0, -611493605 ]
*/
m.program(0, 1);
m.noteOn(0, 50, 88);
m.noteOff(0, 50, 88);
// m.allNotesOff(0);

MIDIIn.disconnectAll();
MIDIIn.connectAll();

(
m.control(0, 64, 127); // pedal
m.noteOn(0, 50, 88);

// m.control(\chan, 0, \ctlNum, 64, \val, 0);
m.noteOn(0, 54, 88);

)

m.control(0, 64, 27);


MIDIFunc.trace(false);
m.allNotesOff(0);
(
Routine({
	( 19 + [42, 44, 46, 49, 53, 61]).mirror1.do({
		arg nn;
		var vel;
		vel = rrand(70, 90);
		m.noteOn(0, nn, vel);
		rrand(0.1, 0.15).wait;
		m.noteOff(0, nn, vel);
		"coucou".postln;
	})
}).play;
)
(
MIDIdef.program(\debugArius, {
	arg val, chan, src;
	[val, chan, src].postln;
})
)
(
MIDIdef.noteOn(\debugNote, {
	arg val, num, chan, src;
		[val, num, chan, src].postln;
});
)
(
MIDIdef.cc(\debugAriusControl, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
})
)


(
~myPianoPattern = Pbind.new(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\midinote, Prand([40, 42, 44, 47], inf),
	\amp, Pexprand(30, 100, inf)/127,
	\sustain, Prand([0.2, 0.4, 0.05], inf),
    \dur, 1/2,

).play;
)

~myPianoPattern.stop

// Define the function to send noteOff for all notes
(
~allNotesOff = {
    var channel = 0;  // MIDI channel (0-15)

    // Iterate over all possible MIDI notes (0-127)
    (0..127).do { |note|
        m.noteOff(channel, note);
    };

    "All notes off sent.".postln;
};

// Call the function to send noteOff for all notes
~allNotesOff.value;
)
