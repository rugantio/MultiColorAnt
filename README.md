# GeneralizedAnt
A multicolor extension of Langton's Ant Cellular Automaton for NetLogo

## WHAT IS IT?

This models is a **multi-color extension** of the basic virtual ant ("*vant*") model. It is inspired by the "*Generalized Ant Automaton*" described in the July 1994 Scientific American. It shows how extremely simple deterministic rule can result in very complex-seeming behavior. Everything that happens in this model is entirely time-reversible and deterministic (it can and will be proved), but it so complex that can become completely indistinguishable from chaotic behavior.

## HOW IT WORKS

The *ant* is a **cellular automaton** that follows a binary deterministic rule which governs its behavior. The world is a grid of patches, each with a *state* variable (color). 
Every timestep (tick) the ant interacts with the patch in the following way:

- **Check** *state* of current patch: the ant finds out how many times has visited the cell

- **Turn**: left (*L*) or right (*R*) according to the current *state* of the patch

- **Update** *state*: which means change the color of the patch

- **Move**: forward of 1 patch unit

The Rule is given as an Input string in the interface that has to be a series of capital '*R*' and '*L*', and the 0-state is the last character (least significant convention). As the ant moves, it increments the state of the patches; when the end of the rule string is reached and no more states are available, the next state will be the 0-state, so that states are wrapped in a cyclic way. For example if the Rule is *LR* (the classical Langton's Ant) the ant will turn *right* if it has never visited the cell and *left* if it has been there once; if it goes over that cell the third time it would turn *right* again since the cell is now back to the original state. The Rule can be arbitrarily long (so the states can be so many) but the color palette is limited to 15, thus visualization won't be proper over this value.

## HOW TO USE IT

- The **Rule** string is needed, and it has to be a series of capital 'R' and 'L', other values will raise an error. The length of the Rule will determine how many states are available, thus also the possible colors.

- The **SETUP** button sets the ant looking in the x direction, all the patches have *state* variable 0.
 
- The **GO** button will start the computation, which goes on forever since the world is wrapped, but it can take many cycles to reach the edge. Can you find the shortest more localized rules?

- The **StopAtEdge?** switch can be used when we don't want to have our model to degenerate in chaos due to wrapping. When the ant reaches the end of the world, everything stops, and the tick counter provides a measure of how quick the ant explores the world. 

- The **GO-REVERSE** does everything that GO does but in reverse: first the ant takes a step backwards, then it updates the state to a lower value and finally it turns left or right. It demonstrates the reversibilty of the model since it can be used to demolish all the work that the ant does, right up to the beginning.

## THINGS TO NOTICE

Sometimes longer rules don't cause more complex behavior.

Notice that this model wouldn't work with an initial random "face" point, why?

How many single configurations are there with a rule of length n?
It would be 2^n but you have to remember that LR and RL is the same configuration with a rotation so it's 2^(n-1). Also, subtracting the trivial rules, such as R,RR,RRR... brings our calculation to 2^(n-1)-n possible configurations, not bad.


## THINGS TO TRY
There are many things to do such as counting and plotting the different colors, or count how long it takes for the ant to reach the edge. Basic interaction would be to setup and let it go with a Rule to see what it does. Here are some interesting ideas:

;;;; PATTERNS ::::
;;HIGHWAY CONSTRUCTION
;; RL            ; Langton's RuLe
;; RLL           ; very fast
;; RLLL
;; RLLLL
;; RLRLLRLRLR
;; RRLRLLRLRR
;; RRRLRRRLLLRR
;; RLLRRRLRRRR
;; RRLRRLLLLLLR
;; LLLRRRLLLLL
;; RRLRLLLRRLLR
;; RRLRLRLLLRRL  ; convoluted highway
;;
;;SPACE FILLING
;; LRLRLLL       ; triangle
;; RRRLRRRLLL    ; triangle
;; LLRRRLRRRLLL  ; triangle
;; RLLLLLRRRLLL  ; triangle
;; LLLLLRRLRLLL  ; aircraft
;;
;;WHOLE PLANE FILLING
;; LLRLL         ; square
;; LRRLLLR       ; square
;; LRRLLLLLR     ; square with knots
;; LRRRLLLRRRRL  ; spiral in a square
;; RLLLRRRLLLLL  ; spiral in a square with knots
;; RLRLLLLLL     ; square
;;
;;ARTISTIC SHAPES
;; LLRR          ; brain-like shape (symmetrical)
;; RLLR          ; complex structure in square (symmetrical)
;; LLRRLLLRLLLL  ; growing 3D solid projection
;; LLRRRRRRLLRL
;; RRRRRRRRLLRL
;; RLLLLLRLLLLRLLLR ; chaos in divided square
;; LLLLLRRLR     ; chaos grows in a jagged square
;; LLLLLRRRLRR   ; chaos grows in a jagged square
;; LLLLLRLLLRR   ; chaos grows in a jagged square
;; RLLLLLLLRLRL  ; chaos grows in fractal-like filled square
;; LLLLLLLRLLRR  ; chaos grows in a rotated square
;; LRRRRRRLLLLLLRRRLLLLL ; fractal like sawtooth square

## EXTENDING THE MODEL
- add more ants
- add more states (up down stop)
- add ant state (turmite)
- change grid (triangular /hexagonal)

## NETLOGO FEATURES

You can use the `sort` primitive to created a list of turtles sorted by who number.  That is necessary in this model because we need the turtles to execute in the same order at every tick, rather than a different random order every tick as would happen if we just said `ask turtles`.

## RELATED MODELS

Turing Machine 2D -- similar to Vants, but much more general.  This model can be configured to use Vants rules, or to use other rules.

## CREDITS AND REFERENCES

The rules for Vants were originally invented by the artificial life researcher Chris Langton.

A 1991 video of Langton describing and demoing Vants (via screen capture with voice-over) is online at https://www.youtube.com/watch?v=w6XQQhCgq5c (length: 6 minutes)

## HOW TO CITE

