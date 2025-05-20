---- MODULE agatha ----
(*
Check README.md in the same folder for the description of the puzzle.
*)

EXTENDS Integers, Sequences, TLC

VARIABLES killer, found
CONSTANTS suspects

\* Agatha hates everybody except the butler.
AgathaHates == {p \in suspects: p # "Butler"}

\* Charles hates no one that Agatha hates.
CharlesHates == suspects \ AgathaHates

\* The butler hates everyone whom Agatha hates.
ButlerHates == AgathaHates

\* The butler hates everyone not richer than Aunt Agatha.
RicherThanAgatha == suspects \ ButlerHates

\* TRUE if the person is richer than Agatha
Richer(person) == person \in RicherThanAgatha

\* TRUE if a hates b
Hates(a, b) ==
    LET
        hate == [
            Agatha |-> AgathaHates,
            Charles |-> CharlesHates,
            Butler |-> ButlerHates
        ]
    IN
        b \in hate[a]

FitsDescription(person) ==
       \* A killer always hates,
    /\ Hates(person, "Agatha")
       \* and is no richer than his victim.
    /\ ~Richer(person)


\* Define possible states
Init ==
    \* Innocent until 'found' guilty ;)
    /\ killer = "Charles"
    /\ found = FALSE

PickSuspect ==
    /\ ~found
    /\ killer' \in suspects
    /\ UNCHANGED found

CheckSuspect ==
    /\ FitsDescription(killer)
    /\ found' = TRUE
    /\ UNCHANGED killer

\* Invariants that make sure our rules are correct

\* Based on "Agatha hates everybody except the butler" rule,
\* we can check that Agatha doesn't hate the Butler.
AgathaDoesntHateButler == ~Hates("Agatha", "Butler")

\* No one hates everyone.
NoOneHatesEveryone ==
    ~( \* There exists 'a' such that
        \E a \in suspects:
            \* the person hates all 'b' in suspects.
            \A b \in suspects: Hates(a, b)
     )

\* Who killed agatha invariant.
KillerNotFound == ~found

\* We solve the puzzle using two states.
Next ==
    \/ PickSuspect
    \/ CheckSuspect

====
