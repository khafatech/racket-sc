
## TODO

- get more familiar with Racket
	- what is "match"?


* is there a linux commandline osc server (or could I make one) that dumps all messages it receives on the terminal?
	* **Yes! dumpOSC in the rack-osc berkely libs**




## SuperCollider stuff


### Installation/setup

#### Ubuntu 12.10


Used [supercollider 3.6.6 ppa](https://launchpad.net/~supercollider/+archive/ppa) for ubuntu 12.10

Jackd needs to use the alsa driver, no real time, no mem lock, Audio: Playback Only.



#### Starting

start jackd using qjackctl.




### Programs

{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;


// example of a function with args

f = { arg a; a.value + 3 };    // call 'value' on the arg; polymorphism awaits!
f.value(3);            // 3.value = 3, so this returns 3 + 3 = 6
g = { 3.0.rand; };

// can use keyword args
{SinOsc.ar(mul:0.1, freq:440)}.scope


* Synthdef with args. To run, select synthdef, then press Ctrl+Enter. Do same for each line

		(
		SynthDef("Switch", { |out, freq = 800, sustain = 1, amp = 0.1|
			Out.ar(out,
				SinOsc.ar(freq, 0, 0.2) * Line.kr(amp, 0, sustain, doneAction: 2)
			)
		}).add;
		)
		a = Synth("Switch");
		a.run(false)


* Synth functions

a = {arg freq=440; SinOsc.ar(freq)*0.1}.play
// or {| freq=440| SinOsc.ar(freq)*0.1}.play
a.set(\freq,330) //change frequency! 


### Server Architecture


Question: What's the relationship between nodes, groups, synthdefs, and ugens?

* a synthdef is the "class", or blueprint to create a synth (objects), which contains ugens, generates sounds.

* synths and groups are both nodes.



* On Linux, synthdefs loaded/saved by server are stored in `~/.local/share/SuperCollider/synthdefs/`




### Alternative clients


* SC Clients
http://supercollider.sourceforge.net/wiki/index.php/Systems_interfacing_with_SC


* Some osc clients for SC exist "including rsc3, a Scheme client, hsc3, based on Haskell, ScalaCollider, based on Scala, and Overtone, based on Clojure"

Rutz, H. H. (2010). "Rethinking the SuperCollider Client...". Proceedings of SuperCollider Symposium. Berlin. CiteSeerX: 10.1.1.186.9817.


### Overtone (SC Client)

- Tried it 12 Jan 2014. Works on my laptop. Easy to install and start.


- code to compile a synthdef: `src/overtone/sc/synth.clj`
- code defines syntdef format: `src/overtone/sc/machinery/synthdef.clj`



### References


* OSC Command Reference
http://doc.sccode.org/Reference/Server-Command-Reference.html

* Server Architecture
http://doc.sccode.org/Reference/Server-Architecture.html

* SynthDef specs
http://doc.sccode.org/Reference/Synth-Definition-File-Format.html

* Blogs about SC
http://supercollider.github.io/community/blogs-and-sites.html




### Bugs

slang can't connect to server.




