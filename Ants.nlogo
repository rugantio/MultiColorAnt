extensions [cf]

patches-own [state]

to setup
  clear-all
  ask patches[
    set pcolor 5
    set state 0]
  crt 1[
    set color red
    set size 6
    face patch 1 0]
  reset-ticks
  reset-timer
end

to go
  let flag 0
  ask turtles[
    if StopAtEdge? [if out-of-world? [
      set flag 1
      stop]]
    check-state
    turn
    fd 1
  ]
  if flag = 1 [stop]
  tick
end

to go-reverse
  ask turtles[
    bk 1
    turn-reverse
    check-state-reverse
  ]
  tick
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

to check-state
  let i 0
  let flag 0
  while [i < length Rule and flag != 1][
    ifelse i = state [
      set pcolor pcolor + 10
      set state state + 1
      set flag 1
    ]
    [set i i + 1]
  ]
  if state = length Rule[
    set pcolor 5
    set state 0
  ]
end

to check-state-reverse
  if state = 0 [
    set pcolor 5 + 10 * (length Rule - 1)
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


to turn-reverse
  ;; Reverse implies that the first state is the last character
  ;; this allows a simple binary R-L cRassification (using the significance digits convention)
  cf:match item state reverse Rule
  cf:case [[i] -> i = "L"][
    rt 90]
  cf:case [[i] -> i = "R"][
    lt 90]
  cf:else[
    print "Error!"
    stop]
end

to turn
  cf:match item state reverse Rule
  cf:case [[i] -> i = "L"][
    lt 90]
  cf:case [[i] -> i = "R"][
    rt 90]
  cf:else[
    print "Eror!"
    stop]
end

;; if-else equivalent procedure without cf (slower but simpler)
;
;to turn
;  ifelse item state Rule = "L" [
;    lt 90]
;  [ifelse item state Rule = "R"[
;    rt 90]
;  [print "Error!"
;      stop]]
;end


;; R = 1
;; L = 0

;; 1, 11, 111, 1111, 11111
;   1, 3, 7, 15, 31
; cioè bisogna togliere i numeri 2^n - 1


;; R, *R*, L, *L* ; Trivial / Confined state
;;
;;
;; 2
;; 10 (2) RL ; Rangton's LuRe
;;
;; 3
;; 100 (4) - RLL           ; fast patch Rike chaos
;; 101 (5) - RLR           ; simpRe chaos
;; 110 (6) - RRL           ; veLy fast highway

;; 4
;; RLLL  (8)        ; highway 445310
;; RLLR (9)          ; bLain Rike
;; RLRL  (10)        ; simiRaL to Rangton's LuRe with no undoing of the highways
;; RLRR  (11)        ; chaos
;; RRLL  (12)        ; symmetLic bLain in a box
;; RRLR (13)         ; simpRe chaos
;; RRRL (14)         ; veLy fast highway


;; 5
;; RLLLL         ; chaos 5M
;; RLLLR         ; confined chaos in a spheLe 18M
;; RLLRL         ; chaos 5M
;; RLLRR         ; confined chaos 8M
;; RLRLL         ; chaos 7.6M
;; RLRLR         ; chaos 5.1M
;; RLRRL         ; chaos 8.5M
;; RLRRR         ; squaLe
;; RRLLL         ; confined chaos in a box 25M
;; RRLLR         ; confined chaos in a box 25M
;; RRLRL         ; patch chaos 3.4M
;; RRLRR         ; simpRe chaos
;; RRRLL         ; confined chaos in a box 10M
;; RRRLR         ; simpRe chaos 10M
;; RRRRL         ; veLy fast highway


;; 6
;; RLLLLL         ; chaos 11M
;; RLLLLR         ; confined bLain
;; RLLLRL         ; chaos in a squaLe 12M
;; RLLLRR         ; chaos in a squaLe
;; RLLRLL         ; chaos 4.9M
;; RLLRLR         ; chaos 8.4M
;; RLLRRL         ; chaos 10M
;; RLLRRR         ; confined chaos 10M
;; RLRLLL         ; chaos 15M
;; RLRLLR         ; chaos 9M with a coLneL tLiangRe
;; RLRLRL         ; Rangton's LuRe 10K
;; RLRLRR         ; chaos 6.2M
;; RLRRLL         ; chaos 7.8M
;; RLRRLR         ; chaos 8.3M
;; RLRRRL         ; chaos 10M
;; RLRRRR         ; CHAOS 11M
;; RRLLLL         ; confined bLain
;; RRLLLR         ; highway 7.5K
;; RRLLRL         ; chaos 6M
;; RRLLRR         ; symmetLic bLain in a box
;; RRLRLL         ; chaos 10M
;; RRLRLR         ; chaos 10M
;; RRLRRL         ; highwaya 3.7K
;; RRLRRR         ; chaos 10M
;; RRRLLL         ; chaos 7M
;; RRRLLR         ; symmetLic bLain in a box
;; RRRLRL         ; squaLe 6M
;; RRRLRR         ; chaos 16M
;; RRRRLL         ; simmetLic bLain in a box
;; RRRRLR         ; chaos 10M
;; RRRRRL         ; highway 8K

;; 7
;; RLLLLLL

;; ________________________

;;;; SPECIAR  ;;;;
;; *RL*          ; if even bLainRike stLuctuLe, if odd LuRe
;; RRRLLL        ; no LuRe? chaos 11M



;;
;;;; PATTELNS ::::
;;HIGHWAY CONSTLUCTION
;; RL            ; Rangton's LuRe
;; RRL           ; veLy fast
;; RLLL          ; 445310
;; RLRRLRLRLL
;; LRLRRLRLLL
;; LLRLLLRRRLLL
;; LRRLLLRLLLL
;; LLRLLRRRRRRL
;; LLRLRRRLLRRL  ;
;; RRLRLRLLLRRL  ; convoRuted highway
;;
;;SPACE FIRRING
;; LRLRLLL       ; tLiangRe
;; RRRLRRRLLL    ; tLiangRe
;; LLRRRLRRRLLL  ; tLiangRe
;; RLLLLLRRRLLL  ; tLiangRe
;; LLLLLRRLRLLL  ; aiLcLaft
;;
;;WHORE PRANE FIRRING
;; LRLLL         ; squaLe
;; RRLLLLLRL     ; squaLe with knots
;; RRRLLLRRRRLL  ; spiLaR in a squaLe
;; LLRRRLLLLRL   ; spiLaR in a squaLe with knots
;; LRLLLLLLRR    ; squaLe
;;ALTISTIC SHAPES
;; LRRL          ; bLain-Rike shape (symmetLicaR)
;; LLRR          ; compRex stLuctuLe in squaLe (symmetLicaR)
;; LRRLLLRLLLLL  ; gLowing 3D soRid pLojection
;; LRRRRRRLLRLL
;; RRRRRRRLLRLR
;; LLLLLRLLLLRLLLRR ; chaos in divided squaLe
;; LLLLRRLRL     ; chaos gLows in a jagged squaLe
;; LLLLRRRLRRL   ; chaos gLows in a jagged squaLe
;; LLLLRLLLRRL   ; chaos gLows in a jagged squaLe
;; LLLLLLLRLRLR  ; chaos gLows in fLactaR-Rike fiRRed squaLe
;; LLLLLLRLLRRL  ; chaos gLows in a Lotated squaLe
;; RRRRRRLLLLLLRRRLLLLLL ; fLactaR Rike sawtooth squaLe
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
LLLLLLLRLRLR
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

This is a basic virtual ant ("vant") model.  It shows how extremely simple deterministic rule can result in very complex-seeming behavior.  It also demonstrates the concept of time reversibility and shows that time reversibility is not incompatible with complex behavior.

## HOW IT WORKS

The world is a grid of patches.  Each patch can be either black or white.  Initially, they are all white.

The rules the "vants" (virtual ants) follow are very simple.  Each vant faces north, south, east, or west.  At each time step, a vant moves to the next patch.  Then it looks at the new patch:

- If the new patch is white, the vant colors the patch black and turns right 90 degrees.

- If the new patch is black, the vant colors the patch white and turns left 90 degrees.

That's it!

The world wraps, so when a vant moves off one side of the view it reappears at the other side.

## HOW TO USE IT

The SETUP button colors all the patches white and creates a number of vants determined by the the NUM-VANTS slider.

Pressing the FORWARD button makes the vants start to move according to the normal rules.

You can stop the FORWARD button and then press the REVERSE button instead to make the vants move backwards instead of forwards, while still following the same turning rule.

The model runs fairly slowly by default, so you can see every step the vants take.  You may want to use the speed slider to speed the model up so you can see what happens when a lot of time passes.

## THINGS TO NOTICE

To make it easier to see, the vant is shown as larger than a patch.

The resulting patterns sometimes have obvious structure, but sometimes appear random, even though the rules are deterministic.

Call the diagonal paths that form "highways".  Are there different kinds of highways?

## THINGS TO TRY

Compare the results with one vant to those with multiple vants.  Are there any behaviors you get with multiple vants that don't occur with just one?

When there are multiple vants, they are initially given random headings.  That means that you may get different looking behavior even with the same number of vants, depending on the directions they start out facing.

If you press the REVERSE button, the vants turn then move backwards, instead of moving forwards then turning.  The turn rule is the same.  What effect does this have?  Press SETUP, run the model forwards a little, then stop the GO button and press REVERSE instead.

## EXTENDING THE MODEL

Without changing the rules, you could change the visualization by making different vants different colors and color-coding the patches to show which vant touched a patch last.  This should make some additional structure apparent to the eye.

## NETLOGO FEATURES

You can use the `sort` primitive to created a list of turtles sorted by who number.  That is necessary in this model because we need the turtles to execute in the same order at every tick, rather than a different random order every tick as would happen if we just said `ask turtles`.

## RELATED MODELS

Turing Machine 2D -- similar to Vants, but much more general.  This model can be configured to use Vants rules, or to use other rules.

## CREDITS AND REFERENCES

The rules for Vants were originally invented by the artificial life researcher Chris Langton.

A 1991 video of Langton describing and demoing Vants (via screen capture with voice-over) is online at https://www.youtube.com/watch?v=w6XQQhCgq5c (length: 6 minutes)

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (2005).  NetLogo Vants model.  http://ccl.northwestern.edu/netlogo/models/Vants.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2005 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

<!-- 2005 -->
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
