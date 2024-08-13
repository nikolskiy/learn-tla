---- MODULE agatha ----
(*
This is work in progress.
*)

EXTENDS Integers, Sequences, TLC

VARIABLES killer, found
CONSTANTS suspects

Init ==
    /\ killer = "None"
    /\ found = FALSE

FitsDescription(person) ==
    /\ person = "Charles"

PickSuspect ==
    /\ killer' \in suspects
    /\ UNCHANGED found

CheckSuspect ==
    /\ FitsDescription(killer)
    /\ found' = TRUE
    /\ UNCHANGED << killer >>

KillerNotFound == ~found

Next ==
    \/ PickSuspect
    \/ CheckSuspect

====
