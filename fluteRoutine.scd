~outsideVariable = 2;


(
~sourceGroup = Group.new;
~fxGroup = Group.after(~sourceGroup);
~reverbBus = Bus.audio(s, 2);





SynthDef.new(\reverb, {
	arg in, out = 0, cutoffFreq = 440;
	var sig, del;
	cutoffFreq.postln;
	sig = In.ar(in, 2);
	sig = sig + (FreeVerb.ar(sig, room:200) * 0.1);
	// sig = LPF.ar(sig, cutoffFreq);
	Out.ar(out, sig);
}).add;


r = Routine.new({
	inf.do({
		5.do({
			arg item, index;
			y = Synth.new(\reverb, [\in, ~reverbBus, \cutoffFreq, 100 + (index * 400)], ~fxGroup);
			f = Synth.new(\chouetteFlute, [\out, ~reverbBus, \gate:0]);
			g = Synth.new(\chouetteFlute, [\out, ~reverbBus,\gate:0]);
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
			y.free;
			f.free;
			g.free;
		});
	});

});
r.play;
)


r.stop(t.nextbar);
(
s.freqscope;
s.plotTree;
)