---- MODULE loop ----
(*
Describe a simple loop.
*)

EXTENDS Integers

VARIABLES x

Init == x = 1

Next ==
    /\ x <= 10
    /\ x' = x + 1

====
