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
VARIABLES killer

ALL == {"Agatha", "Butler", "Charles"}
ALL2 == {"Charles", "Charles", "Charles"}

CheckSuspect(p) ==
    /\ p = "Charles"
    /\ killer' = p

Init == killer = "No one"

Next ==
    \E p \in ALL :
        CheckSuspect(p)

NoKillers == killer = "No one"
====
