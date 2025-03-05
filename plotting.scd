// Make sure the server is booted
s.boot;

// 1. VISUALIZE CLICK SOUND USING SCOPE
(
// Create a temporary buffer to capture the click sound
~clickBuf = Buffer.alloc(s, s.sampleRate * 0.1); // 100ms buffer

SynthDef(\clickCapture, {
    var click = Mix([
        // Wood-like impact
        Impulse.ar(0) * EnvGen.kr(Env.perc(0.001, 0.03)),
        // Resonant body
        Ringz.ar(
            Impulse.ar(0),
            [2000, 2000*1.4, 2000*1.8],
            [0.03, 0.02, 0.01],
            0.3
        ).sum
    ]);

    // Record the click into the buffer
    RecordBuf.ar(click, ~clickBuf, loop: 0, doneAction: 2);
}).play;
)

// Visualize the recorded click
~clickBuf.plot("Single Click Waveform", minval: -1, maxval: 1);

// 2. VISUALIZE TRIGGER RATE USING CONTROL BUS PLOTTING
(
// Create a control bus to monitor the trigger rate
~triggerBus = Bus.control(s, 1);

SynthDef(\monitorTriggerRate, {
    arg out=0, rattleSpeed=15, rattleRandomness=0.3;

    // Variable trigger rate as in the original synth
    var triggerRate = rattleSpeed * LFNoise2.kr(
        rattleSpeed * rattleRandomness
    ).range(0.8, 1.2);

    // Output to a control bus
    Out.kr(~triggerBus, triggerRate);
}).play;
)

// Plot the trigger rate over time
~triggerBus.plot(1, minval: 10, maxval: 20);

// 3. VISUALIZE RATTLE PATTERN USING A CUSTOM FUNCTION
(
// Custom function to create a visual representation of the rattle pattern
~visualizePattern = { |duration=5|
    var pattern = Pbind(
        \instrument, \storkRattle,
        \dur, Pseg(
            Pseq([0.8, 0.2, 0.8], inf),
            Pseq([8, 8], inf),
            \sin
        ),
        \freq, Pwhite(1800, 2200),
        \rattleSpeed, Pseq([18], inf),
        \amp, 0.5,
        \rattleRandomness, 0.3
    );

    // Collect pattern values
    var stream = pattern.asStream;
    var times = Array.new;
    var durations = Array.new;
    var currentTime = 0;
    var event;
	var w;
    var v;
    // Generate events for the specified duration
    while { currentTime < duration } {
        event = stream.next(());
        if (event.notNil) {
            times = times.add(currentTime);
            durations = durations.add(event[\dur]);
            currentTime = currentTime + event[\dur];
        } {
            currentTime = duration; // Break if pattern ended
        };
    };

    // Create a plot
    w = Window("Rattle Pattern", Rect(100, 100, 800, 200));
    v = UserView(w, Rect(0, 0, 800, 200));

    v.background = Color.white;
    v.drawFunc = {
        var scale = 800 / duration;

        // Draw time axis
        Pen.strokeColor = Color.black;
        Pen.line(Point(0, 150), Point(800, 150));
        Pen.stroke;

        // Draw timing markers
        (0..duration).do { |i|
            var x = i * scale;
            Pen.line(Point(x, 145), Point(x, 155));
            Pen.stroke;
            Pen.stringAtPoint(i.asString, Point(x-5, 160));
        };

        // Draw events
        times.do { |time, i|
            var x = time * scale;
            var width = min(durations[i] * scale, 5); // Make very short durations visible

            Pen.fillColor = Color.red;
            Pen.addRect(Rect(x, 100, width, 40));
            Pen.fill;

            // Add duration value
            Pen.stringAtPoint(durations[i].round(0.01).asString, Point(x, 80));
        };
    };

    w.front;
};

// Visualize the pattern for 20 seconds
~visualizePattern.(20);
)

// 4. ANALYZE FREQUENCY CONTENT OF THE CLICK
(
// Generate a longer sample of clicks for FFT analysis
~fftBuf = Buffer.alloc(s, s.sampleRate * 2); // 2 seconds

SynthDef(\fftCapture, {
    var click = Mix([
        // Wood-like impact
        Impulse.ar(0) * EnvGen.kr(Env.perc(0.001, 0.03)),
        // Resonant body
        Ringz.ar(
            Impulse.ar(0),
            [2000, 2000*1.4, 2000*1.8],
            [0.03, 0.02, 0.01],
			0.3
        ).sum
    ]);

    // Trigger multiple clicks
    var trig = Dust.kr(15);
    var env = EnvGen.kr(Env.perc(0.05, 0.2), trig);
    var signal = click * env;

    // Record to buffer
    RecordBuf.ar(signal, ~fftBuf, loop: 0, doneAction: 2);
}).play;
)

// Plot the spectral analysis
~fftBuf.loadToFloatArray(action: { |data|
    var fft = data.as(Signal).fft(Signal.fftCeilingSize(data.size));
    var spectrum = fft.magnitude.copyRange(0, fft.size/2);
    var freqs = (0..spectrum.size-1) * s.sampleRate / fft.size;

    // Plot only the meaningful frequency range (up to 10kHz)
    var cutoff = (10000 * fft.size / s.sampleRate).asInteger;
    spectrum = spectrum.copyRange(0, min(cutoff, spectrum.size-1));
    freqs = freqs.copyRange(0, min(cutoff, freqs.size-1));

    spectrum.plot("Frequency Spectrum", freqs, minval: 0);
});