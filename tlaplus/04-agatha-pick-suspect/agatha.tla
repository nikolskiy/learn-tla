---- MODULE agatha ----
(*
Someone in Dreadsbury Mansion killed Aunt Agatha.

Agatha, the Butler, and Charles
live in Dreadsbury Mansion
and are the only ones to live there.

A killer always hates, and is no richer than his victim.
Charles hates no one that Agatha hates.
Agatha hates everybody except the butler.
The butler hates everyone not richer than Aunt Agatha.
The butler hates everyone whom Agatha hates.
No one hates everyone.

Who killed Agatha?

This is a partial of a solution.
Here we just practice picking an element and applying some actions to it.

*)
VARIABLES
    person,
    killer

ALL == {"Agatha", "Butler", "Charles"}

PickSuspect ==
    /\ person' \in ALL
    /\ UNCHANGED killer

CheckSuspect ==
    /\ person = "Charles"
    /\ killer' = person
    /\ UNCHANGED person

Init ==
    /\ killer = "No one"
    /\ person = "No one"

Next ==
    \/ PickSuspect
    \/ CheckSuspect

\* Invariant
NoKillers == killer = "No one"
====
