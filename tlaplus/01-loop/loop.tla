---- MODULE loop ----
(*
Describe a simple loop.

 /----------\             /----------\           /----------\
 |  X = 1   |-----------> |   X = 2  |..........>| X = 10   |
 \----------/             \----------/           \----------/

*)

EXTENDS Integers

VARIABLES x

Init == x = 1

Next ==
    /\ x <= 10
    /\ x' = x + 1

====
