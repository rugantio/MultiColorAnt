extensions [cf] ;; switch-case like construct, it speeds up computation

patches-own [state]

to setup
  clear-all
  ask patches[
    set pcolor 5
    set state 0]
  crt 1[
    set color red
    set size 6
    face patch 1 0
  ]
  reset-ticks
  reset-timer
end

to go
  let flag 0                     ;; flag is needed to stop the go procedure in case StopAtEdge is active
  ask turtle 0[
    turn
    update-state
    fd 1
  ]
  if StopAtEdge? [
    ask turtle 0 [if out-of-world? [
      set flag 1
      stop]]]
  if flag = 1 [stop]
  tick
end

to turn
  cf:match item state reverse Rule  ;; matching reverse implies that the first state is the last character; this allows a simple binary R-L classification
  cf:case [[i] -> i = "L"][
    lt 90]
  cf:case [[i] -> i = "R"][
    rt 90]
  cf:else[
    print "Error!"
    stop]
end

to update-state
  let i 0
  let flag 0             ;; flag is needed since there's no "break" function and we need to exit the while...
  while [i < length Rule and flag != 1][
    ifelse i = state [              ;; ...when we match the state
      set pcolor pcolor + 10
      set state state + 1
      set flag 1
    ]
    [set i i + 1]
  ]
  if state = length Rule[           ;; after last available state, go back to 0-state
    set pcolor 5
    set state 0
  ]
end

to-report out-of-world?
  cf:match pxcor
  cf:case [[x] -> x = max-pxcor][
    report True]
  cf:case [[x] -> x = min-pxcor][
    report True]
  cf:else [
    cf:match pycor
    cf:case [[y] -> y = max-pycor][
      report True]
    cf:case [[y] -> y = min-pycor][
      report True]
    cf:else [report False]]
end

to go-reverse
  ask turtle 0[
    bk 1
    update-state-reverse
    turn-reverse
  ]
  tick
end

to turn-reverse
  cf:match item state reverse Rule
  cf:case [[i] -> i = "L"][
    rt 90]                    ;; if you go forward and turn left, to reverse you go backwards and turn right
  cf:case [[i] -> i = "R"][
    lt 90]
  cf:else[
    print "Error!"
    stop]
end

to update-state-reverse
  if state = 0 [                           ;; a little trickier, since from 0-state we have to go to last state
    set pcolor 5 + 10 * (length Rule - 1)  ;; add to the initial 0-state color value (5) the increment * numberOfStates
    set state (length Rule - 1)
    stop
  ]
  let i 0
  set i (length Rule - 1)
  let flag 0
  while [i > 0 and flag != 1][
    ifelse i = state [
      set pcolor pcolor - 10
      set state state - 1
      set flag 1]
    [ set i i - 1]]
end
@#$#@#$#@
GRAPHICS-WINDOW
331
10
1141
821
-1
-1
2.0
1
10
1
1
1
0
1
1
1
-200
200
-200
200
1
1
1
ticks
60.0

BUTTON
96
148
219
181
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
25
12
290
72
Rule
RLLR
1
0
String

BUTTON
62
198
125
231
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
82
94
231
127
StopAtEdge?
StopAtEdge?
0
1
-1000

BUTTON
165
197
274
230
NIL
go-reverse
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
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
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
setup
repeat 60000 [ go-forward ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
