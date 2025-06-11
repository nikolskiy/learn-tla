---- MODULE agatha ----
(*
Someone in Dreadsbury Mansion killed Aunt Agatha.
Agatha, the butler, and Charles live in Dreadsbury Mansion
and are the only ones to live there.
A killer always hates, and is no richer than his victim.
Charles hates no one that Agatha hates.
Agatha hates everybody except the butler.
The butler hates everyone not richer than Aunt Agatha.
The butler hates everyone whom Agatha hates.
No one hates everyone.
Who killed Agatha?
*)
VARIABLES suspects, person, killer

PickSuspect ==
    /\ person' \in suspects
    /\ UNCHANGED suspects
    /\ UNCHANGED killer


CheckSuspect ==
    /\ person = "Charles"
    /\ killer' = person
    /\ UNCHANGED suspects
    /\ UNCHANGED person

Init ==
    /\ suspects = { "Agatha", "Butler", "Charles" }
    /\ person = "No one"
    /\ killer = "No one"

Next ==
    \/ PickSuspect
    \/ CheckSuspect

KillerNotFound == killer = "No one"
====
