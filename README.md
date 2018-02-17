# MultiColorAnt
A multi-color extension of Langton's Ant Cellular Automaton for NetLogo

## WHAT IS IT?

This models is a **multi-color extension** of the basic virtual ant ("*vant*") model. It is inspired by the "*Generalized Ant Automaton*" described in the July 1994 Scientific American. It shows how extremely simple deterministic rule can result in very complex-seeming behavior. Everything that happens in this model is entirely time-reversible and deterministic (it can and will be proved), but it so complex that can become completely indistinguishable from chaotic behavior.

## HOW IT WORKS

The *ant* is a **cellular automaton** that follows a binary deterministic rule which governs its behavior. The world is a grid of patches, each with a *state* variable (color). 
Every timestep (tick) the ant interacts with the patch in the following way:

- **Check** *state* of current patch: the ant finds out how many times has visited the cell

- **Turn**: left (*L*) or right (*R*) according to the current *state* of the patch

- **Update** *state*: change the color of the patch and increments the state

- **Move**: forward of 1 patch unit

The Rule is given as an Input string in the interface that has to be a series of capital '*R*' and '*L*', and the 0-state is the last character (least significant convention). As the ant moves, it increments the state of the patches; when the end of the rule string is reached and no more states are available, the next state will be the 0-state, so that states are wrapped in a cyclic way. For example if the Rule is *LR* (the classical Langton's Ant) the ant will turn *right* if it has never visited the cell and *left* if it has been there once; if it goes over that cell the third time it would turn *right* again since the cell is now back to the original state. The Rule can be arbitrarily long (so the states can be so many) but the color palette is limited to 15, thus visualization won't be proper over this value.

## HOW TO USE IT

- The **Rule** string is needed, and it has to be a series of capital 'R' and 'L', other values will raise an error. The length of the Rule will determine how many states are available, thus also the possible colors.

- The **SETUP** button sets the ant looking in the x direction, all the patches have *state* variable 0.
 
- The **GO** button will start the computation, which goes on forever since the world is wrapped, but it can take many cycles to reach the edge. Can you find the shortest more localized rules?

- The **StopAtEdge?** switch can be used when we don't want to have our model to degenerate in chaos due to wrapping. When the ant reaches the end of the world, everything stops, and the tick counter provides a measure of how quick the ant explores the world. 

- The **GO-REVERSE** does everything that GO does but in reverse: first the ant takes a step backwards, then it updates the state to a lower value and finally it turns left or right. It demonstrates the reversibilty of the model since it can be used to demolish all the work that the ant does right up to the beginning.

## THINGS TO NOTICE

Sometimes longer rules don't cause more complex behavior.

Notice that this model wouldn't work with an initial random "face" point, why?

How many single configurations are there with a rule of length n?
It would be 2^n but you have to remember that LR and RL is the same pattern (with a rotation) so it's 2^(n-1). Also, subtracting the trivial rules, such as R,RR,RRR... brings our calculation to 2^(n-1)-n possible unique configurations. The number grows exponentially with the number of available states, as we would expect. 

## THINGS TO TRY
There are many things you can try, such as counting and plotting the different colors of the patches, or count how many ticks it takes for the ant to reach the edge. Basic interaction would be to setup with a Rule and let it go to see what it does. Is it chaotic? Does the ant build a highway? Can you find some rules for its behavior given the rule string (try rules with some palindromy)? Here are some interesting ideas:

HIGHWAY CONSTRUCTION
********************
RL                   Langton's RuLe
RLL, RLLL, RLLLL...  Very fast
RRLLRRRLRRR          Fast
RLRLLRLRLR           Thick
RRRLLLRRR            Unexpected
RRLRLLRLRR           Large
RRRLRRRLLLRR         Thick
RRRLRRLLLLLL         Takes a while
RLLRLRLRRRLL         Convoluted

SPACE FILLING
********************
RRLRLRR              Triangle
RLLLRLLLRR           Triangle
RRRLLLRLLLRR         Triangle
RLRRRRRLLLRR         Triangle
RRRRRRLLRLRR         Aircraft

WHOLE PLANE FILLING
********************
RRLRR                Square
RLLRRRL              Square
RLLRRRRRL     	     Square with knots
RLLLRRRLLLLR         Spiral in a square
RRRLLLRRRRL          Spiral in a square with knots

ARTISTIC SHAPES
********************
RRLL                 Brain
RLLR                 Complex symmetrical mandala
RRLRRLLLLLLR         Chaos with highways in a square
RRLLRRRLRRRR         Growing 3D-like solid
RLLLLLRLLLLRLLLR     Chaos grows in a jagged square
RRLLLLLLRRLR         Chaos grows in a jagged square
RRRRRRRRLLRL         Chaos grows in a jagged square
RRRRRLLRL            Chaos grows in a jagged square
RRRRRLLLRLL          Chaos grows in a jagged square
RRRRRLRRRLL          Chaos grows in a jagged square
RLLLLLLLRLRL         Chaos grows in fractal-like filled background
RRRRRRRLRRLL         Chaos grows in a rotated square
RLLLLLLRRRRRRLLLRRRRR Fractal like sawtooth square

## EXTENDING THE MODEL
This model is a big playground, it can be extended in many ways. Here are some suggestions:

- **Add more ants**: In his original work, Chris Langton made his ants interact collaborate and build ant colonies (explained here https://www.youtube.com/watch?v=w6XQQhCgq5c). How would multi-color ants behave together?
- **Change the step**: Instead of going always forward 1 square the ant could do something else, going forward 2 or 3 squares or backwards sometimes.
- **Change the rule** (add other patch states): Instead of always turning L/R on every step, the ant might also want to go up (U) or down (D). 
- **Add ant state**: The ant is powerful but dumb, it doesn't have an internal state. If implemented, the ant becomes a 2-D Turing Machine (also called *turmite*)
- **Change grid**: Many interesting things happen if we change the patch tessellation, for example triangular or hexagonal. In some of them it's not obvious to define a neighbor cell, and with different choices different things happen.

## NETLOGO FEATURES
The cf extension is used to provide a switch-case like construct. This comes very helpful because the use of anonymous procedures in the turn and turn-reverse procedures speeds up the computation. NetLogo doesn't handle very well iteration and that's why here and there a flag is needed to break the while cycle or to stop the go procedure.

## RELATED MODELS

* Vants -- Implementation of muliple Langton's Ant cellular automata.

* Turing Machine 2D -- similar to Vants, but much more general.  This model can be configured to use Vants rules, or to use other rules.

## CREDITS AND REFERENCES

Credits to Chris Langton for the idea and to Uri Wilensky for the NetLogo implementation.
Generalized Ants (or multi-color ants) were described in the July 1994 Scientific American and the mathematics behind it can be retrieved from the paper "*Further Travel with My Ant*", (https://arxiv.org/abs/math/9501233) appeared in the summer 1995 issue of the Mathematical Intelligencer.
Some preliminary work on generalized ant colonies can be found in the paper "*Behaviour of Multiple Generalized Langton's Ants*"(https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.54.179)
I have to give credits to aldoaldoz and his video (https://www.youtube.com/watch?v=1X-gtr4pEBU) that inspired the "things to try" section. 

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Carugno, C. (2018).  NetLogo MultiColorAnt model https://github.com/rugantio/MultiColorAnt

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE
https://github.com/rugantio/MultiColorAnt/blob/master/LICENSE

Copyright 2018 Costantino Carugno

MultiColorAnt is licensed under the
GNU General Public License v3.0

Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.
