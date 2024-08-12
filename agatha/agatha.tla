---- MODULE agatha ----
(*
This is work in progress.
*)

EXTENDS Integers, Sequences, TLC

VARIABLES killer, suspects, found

Init ==
    /\ killer = "None"
    /\ found = FALSE
    /\ suspects = {"Agatha", "Butler", "Charles"}

FitsDescription(person) ==
    /\ person = "Charles"

PickSuspect ==
    /\ killer' \in suspects
    /\ suspects' = {s \in suspects: s # killer}

CheckSuspect ==
    /\ PickSuspect
    /\ FitsDescription(killer)
    /\ found' = TRUE

KillerFound == killer # "Charles"

Next == CheckSuspect

====
