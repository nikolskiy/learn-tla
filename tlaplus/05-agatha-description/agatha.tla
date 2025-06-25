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
VARIABLES person, killer
CONSTANTS ALL

\* pick 1
\* Agatha hates everybody except the butler.
AgathaHates == {h \in ALL : h # "Butler"}

\* pick 2
\* Charles hates no one that Agatha hates.
CharlesHates == ALL \ AgathaHates

\* pick 3
\* The butler hates everyone whom Agatha hates.
ButlerHates == AgathaHates

\* pick 4
\* The butler hates everyone not richer than Aunt Agatha.
\* ButlerHates == {h \notin RicherThanAgatha}
RicherThanAgatha == ALL \ ButlerHates

\* TRUE if a hates b
Hates(a, b) ==
    (*
    Allow local definitions of operators or values within an expression.
    *)
    LET
        (*
        Records in TLA+ are used to group related data under named fields.
        [field1 |-> val1, field2 |-> val2,...]
        *)
        hate == [
            Agatha |-> AgathaHates,
            Charles |-> CharlesHates,
            Butler |-> ButlerHates
        ]
    (*
    Definitions within LET are scoped
    only to the corresponding IN expression.
    *)
    IN
        /\ a \in DOMAIN hate
        /\ b \in hate[a]

FitsDescription(p) ==
    \* A killer always hates
    /\ Hates(p, "Agatha")
    \* and is no richer than his victim.
    /\ p \notin RicherThanAgatha


CheckSuspect ==
    /\ FitsDescription(person)
    /\ killer' = person
    /\ UNCHANGED person

PickSuspect ==
    /\ person' \in ALL
    /\ UNCHANGED killer


Init ==
    /\ person = "No one"
    /\ killer = "No one"

Next ==
    \/ PickSuspect
    \/ CheckSuspect


NoKillers == killer = "No one"

\* No one hates everyone.
NoOneHatesEveryone ==
    ~(\E a \in ALL:
        \A b \in ALL:
            Hates(a, b)
     )

AgathaDoesntHateButler == ~Hates("Agatha", "Butler")


====
