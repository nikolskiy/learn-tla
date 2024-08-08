---- MODULE agatha ----
(*
This is work in progress.
*)

EXTENDS Integers, Sequences, TLC

VARIABLES killer

Init == /\ killer = "None"
        /\ found = FALSE

FindKiller(person) ==
    /\ found
    /\ x' = x + 1

Next == \E self \in {'a', 'b', 'c'}: FindKiller(self)

====
