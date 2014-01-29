

// SynthDef(\sin_simple, {Out.ar(0, SinOsc.ar(440, 0, 0.2))}).add


// to eval, select lines between parens then press Ctrl+Enter
(

var sd = SynthDef("basic_sin", {
	arg freq = 440;
	Out.ar(0, SinOsc.ar(freq, 0, 0.3))});
sd.add;

sd.writeDefFile;
)

a = Synth("basic_sin");
a.set(\freq, 400)
a.run;
a.run(false)

s.sendMsg("/s_new", "default", 1000);



SynthDef.synthDefDir


/*

(
a = {arg freq=440; SinOsc.ar(freq)*0.1}.play;

a.run;

a.set(\freq,430); //change frequency!

a.run(false)
)

*/