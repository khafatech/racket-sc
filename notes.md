

## TODO

- get more familiar with Racket
	- what is "match"?


* is there a linux commandline osc server (or could I make one) that dumps all messages it receives on the terminal?
	* **Yes! dumpOSC in the rack-osc berkely libs**




## SuperCollider stuff





### Setup


Used supercollider ppa for ubuntu 12.10

Jackd needs to use the alsa driver, no real time, no mem lock, Audio: Playback Only.


### Starting

start jackd using qjackctl.


## Programs

{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;


// example of a function with args

f = { arg a; a.value + 3 };    // call 'value' on the arg; polymorphism awaits!
f.value(3);            // 3.value = 3, so this returns 3 + 3 = 6
g = { 3.0.rand; };




### Alternative clients


* SC Clients
http://supercollider.sourceforge.net/wiki/index.php/Systems_interfacing_with_SC


* Some osc clients for SC exist "including rsc3, a Scheme client, hsc3, based on Haskell, ScalaCollider, based on Scala, and Overtone, based on Clojure"

Rutz, H. H. (2010). "Rethinking the SuperCollider Client...". Proceedings of SuperCollider Symposium. Berlin. CiteSeerX: 10.1.1.186.9817.


### Overtone (SC Client)

- Tried it 12 Jan 2014. Works on my laptop. Easy to install and start.



### References


* OSC Command Reference
http://doc.sccode.org/Reference/Server-Command-Reference.html

* Server
http://doc.sccode.org/Reference/Server-Architecture.html

* SynthDef specs
http://doc.sccode.org/Reference/Synth-Definition-File-Format.html

* Blogs about SC
http://supercollider.github.io/community/blogs-and-sites.html




### Bugs

slang can't connect to server.




