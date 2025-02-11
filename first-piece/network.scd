// Define the IP and port of the Node.js server
~nodeIP = "127.0.0.1"; // Localhost
~nodePort = 57122;     // Port for OSC messages

// Send a test OSC message
(
OSCdef(\sendLightCommand, {
    |val|
    var brightness = val.linlin(0, 1, 0, 254).asInteger; // Scale value for brightness
	brightness.postln;
    NetAddr(~nodeIP, ~nodePort).sendMsg("/light", brightness);
}, \lightControl);
)

NetAddr(~nodeIP, ~nodePort).sendMsg("/light", 266); // Send a test brightness value


NetAddr(~nodeIP, ~nodePort).sendMsg("/video", 'start'); // Send a test brightness value

NetAddr(~nodeIP, ~nodePort).sendMsg("/video", 'stop'); // Send a test brightness







(~sendLightCommand = {
	|val|
    var brightness = val.linlin(3, 4, 154, 500).asInteger; // Scale value for brightness
	brightness.postln;
    NetAddr(~nodeIP, ~nodePort).sendMsg("/light", brightness);
};)

~sendLightCommand.value(0.2); // Sends a brightness value of 127 (approximately half)


(
Pbind(
	\type, \set,
	\freq, Pexprand(0.001, 1),
	\light, Pfunc({
		|argument|
		argument[\freq].postln;
		~sendLightCommand.value(argument[\freq]);
		})
).play;
)


