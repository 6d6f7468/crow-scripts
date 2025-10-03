# crow-scripts
Lua scripts for the monome crow eurorack synthesizer module

### clockdiv_events
CV 1 clock pulse whose divisions trigger random CV out values and a trigger pulse on CV output 4.


### markovtrigs
4th-order markov chain driven by CV Input 1 clock signal that sends trigger pulses to each of the 4 CV outputs.
A second chain driven by CV Input 2 contains states which modify the order of state transition probabilities for the 1st chain.
