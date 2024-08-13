---- MODULE agatha ----
(*
This is work in progress.
*)

EXTENDS Integers, Sequences, TLC

VARIABLES killer, found
CONSTANTS suspects

\* Agatha hates everybody except the butler.
AgataHates == {p \in suspects: p # "Butler"}

\* Charles hates no one that Agatha hates.
CharlesHates == suspects \ AgataHates

\* The butler hates everyone whom Agatha hates.
ButlerHates == AgataHates

\* The butler hates everyone not richer than Aunt Agatha.
RicherThanAgatha == suspects \ ButlerHates

\* TRUE if the person is richer than Agatha
Richer(person) == person \in RicherThanAgatha

\* TRUE if a hates b
Hates(a, b) ==
    LET
        hate == [
            Agatha |-> AgataHates,
            Charles |-> CharlesHates,
            Butler |-> ButlerHates
        ]
    IN
        b \in hate[a]

\* A killer always hates, and is no richer than his victim.
FitsDescription(person) ==
    /\ Hates(person, "Agatha")
    /\ ~Richer(person)

\* Define posible states
Init ==
    /\ killer = "Charles"
    /\ found = FALSE

PickSuspect ==
    /\ ~found
    /\ killer' \in suspects
    /\ UNCHANGED found

CheckSuspect ==
    /\ FitsDescription(killer)
    /\ found' = TRUE
    /\ UNCHANGED << killer >>

\* Invariants that make sure our rules are correct

\* Based on "Agatha hates everybody except the butler" rule.
\* We can check that Agatha doesn't hate the Butler.
AgathaDoesntHateButler == ~Hates("Agatha", "Butler")

\* No one hates everyone.
NoOneHatesEveryone ==
    ~(
        \E a \in suspects:
            \A b \in suspects: Hates(a, b)
     )

\* Find who killed agatha invariant
KillerNotFound == ~found

\* We soleve the problem using two states
Next ==
    \/ PickSuspect
    \/ CheckSuspect

====
