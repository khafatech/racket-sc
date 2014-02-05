
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


* To setup PulseAudio to use jack instead of Alasa: (so other sounds will play besides jack sounds)
	`http://trac.jackaudio.org/wiki/WalkThrough/User/PulseOnJack`

1. Redirect alsa to PulseAudio, put in `~/.asoundrc`:

		pcm.pulse {
			type pulse
		}

		ctl.pulse {
			type pulse
		}

		pcm.!default {
			type pulse
		}
		ctl.!default {
			type pulse
		}
2. apt-get install pulseaudio-module-jack

3. put in `~/.pulse/default.pa`:

		load-module module-native-protocol-unix
		load-module module-jack-sink channels=2
		load-module module-jack-source channels=2
		load-module module-null-sink
		load-module module-stream-restore
		load-module module-rescue-streams
		load-module module-always-sink
		load-module module-suspend-on-idle
		set-default-sink jack_out
		set-default-source jack_in

#### Starting

start jackd using qjackctl.

Important note: If starting `scsynth`, need to use `qjackctl` to connect SuperCollider->out_1 to the system output using the Connect button.


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




## Alternative clients


* SC Clients
http://supercollider.sourceforge.net/wiki/index.php/Systems_interfacing_with_SC


* Some osc clients for SC exist "including rsc3, a Scheme client, hsc3, based on Haskell, ScalaCollider, based on Scala, and Overtone, based on Clojure"

Rutz, H. H. (2010). "Rethinking the SuperCollider Client...". Proceedings of SuperCollider Symposium. Berlin. CiteSeerX: 10.1.1.186.9817.


### Overtone (SC Client)

- Tried it 12 Jan 2014. Works on my laptop. Easy to install and start.


- code to compile a synthdef: `src/overtone/sc/synth.clj`
- code defines syntdef format: `src/overtone/sc/machinery/synthdef.clj`


### RSC3 (Scheme)

#### Installing on Ubuntu 12.10


* Instructions from http://rd.slavepianos.org/ut/rsc3-texts/lss/rsc3-tutorial.html plus a little detective work.

- install darcs: `aptitude install darcs`
- "clone" the repos listed in http://rd.slavepianos.org/ut/rsc3-texts/lss/rsc3-tutorial.html

- install Ikarus (a scheme implementation) to compile the libraries.
	* `apt-get install ikarus`

	* Set the lib path. Put in ~/.bashrc
		IKARUS_LIBRARY_PATH=~/opt/lib/r6rs/
		export IKARUS_LIBRARY_PATH

- go to each of the 4 repos' mk dir and do `make prefix=~/opt`


- now `~/opt/lib/r6rs/` should look like:
		$ ls ~/opt/lib/r6rs/
		mk-r6rs.sls  rsc3.ikarus.sls    sosc.ikarus.sls
		rhs.sls      rsc3.mzscheme.sls  sosc.mzscheme.sls


- install libs into PLT scheme:
	
		$ plt-r6rs --install ~/opt/lib/r6rs/rhs.sls
		$ plt-r6rs --install ~/opt/lib/r6rs/sosc.mzscheme.sls
		$ plt-r6rs --install ~/opt/lib/r6rs/rsc3.mzscheme.sls




## References


* OSC Command Reference
http://doc.sccode.org/Reference/Server-Command-Reference.html

* Server Architecture
http://doc.sccode.org/Reference/Server-Architecture.html

* SynthDef specs
http://doc.sccode.org/Reference/Synth-Definition-File-Format.html

* Blogs about SC
http://supercollider.github.io/community/blogs-and-sites.html







