---- MODULE states ----
EXTENDS Integers, Sequences, TLC

VARIABLES x, y
vars == << x, y >>

Init ==
    /\ x = 0
    /\ y = 0

S0 ==
    /\ x = 0
    /\ y = 0
    /\
      \/ y' = 1 /\ UNCHANGED x
      \/ x' = 1 /\ UNCHANGED y

S1 ==
    /\ x = 0
    /\ y = 1
    /\ x' = 1
    /\ UNCHANGED y

S2 ==
    /\ x = 1
    /\ y = 1
    /\ x' = 0
    /\ y' = 0 \/ y' = 1


S3 ==
    /\ x = 1
    /\ y = 0
    /\ UNCHANGED << x, y >>

TypeXOk == x \in {0, 1}
TypeYOk == y \in {0, 1}

Next ==
    \/ S0
    \/ S1
    \/ S2
    \/ S3


Spec == Init /\ [][Next]_vars

====
