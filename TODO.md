

## Interface


### Initial functions
* send-synthdef: byte-string -> void
* instantiate a synth: "string", [(arg val) ...] -> synth-obj
* synth funcs:
	- synth-play
	- synth-stop
	- synth-run: bool -> void
	- synth-param [("arg" val) ...]


## Ideas

- use global control busses to control synths (/n_map and /mapn)




## Play sound

* find a synthdef binary

Questions
- How could I write a synthdef to a file?
	* use writeDefFile, an instance method of a SynthDef
	* created basic_sin.scsyndef

	 
## Generate SynthDef files and send them to the server. (SynthDefs specify networked Unit Generators)

Need to:

- generate a synthdef in racket.
	* look at how overtone does it
		- where is it in the code?
	* overtone has command metadata, and uses it for determining the args (e.g. default args)



- send the blob to the server using an osc command.




## Controling and sending messages to nodes (Unit Generators, synths)


## Implement more features of the full SC interface (control flow, sequencing)

