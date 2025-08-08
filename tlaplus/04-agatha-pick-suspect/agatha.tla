---- MODULE agatha ----
(*
Someone in Dreadsbury Mansion killed Aunt Agatha.

Agatha, the butler, and Charles
live in Dreadsbury Mansion
and are the only ones to live there.

A killer always hates, and is no richer than his victim.
Charles hates no one that Agatha hates.
Agatha hates everybody except the butler.
The butler hates everyone not richer than Agatha.
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

\* Agatha hates everybody except the butler.
AgathaHates == {p \in ALL: p # "Butler"}

\* Charles hates no one that Agatha hates.
CharlesHates == ALL \ AgathaHates

\* The butler hates everyone whom Agatha hates.
ButlerHates == AgathaHates

\* The butler hates everyone not richer than Agatha.
\* not richer than agatha == butler hates
NotRicherThanAgatha == ButlerHates

\* TRUE if a hates b
Hates(a, b) ==
    \/ a = "Agatha" /\ b \in AgathaHates
    \/ a = "Butler" /\ b \in ButlerHates
    \/ a = "Charles" /\ b \in CharlesHates

PickSuspect ==
    /\ person' \in ALL
    /\ UNCHANGED killer

FitsDescription(p) ==
    \* /\ p # "Agatha"
    \* A killer always hates
    /\ Hates(p, "Agatha")
    \* is no richer than his victim
    /\ p \in NotRicherThanAgatha

CheckSuspect ==
    /\ FitsDescription(person)
    /\ killer' = person
    /\ UNCHANGED person

Init ==
    /\ killer = "No one"
    /\ person = "No one"

Next ==
    \* Explain why this is not parallel
    \/ PickSuspect
    \/ CheckSuspect

\* Invariant
NoKillers == killer = "No one"

\* No one hates everyone.
NoOneHatesAll ==
    /\ AgathaHates # ALL
    /\ CharlesHates # ALL
    /\ ButlerHates # ALL

OnlyOneKiller ==
    \A p \in ALL \ {"Agatha"}: ~FitsDescription(p)

====
