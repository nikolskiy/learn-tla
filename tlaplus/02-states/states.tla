---- MODULE states ----

(*
Describe transitions between 4 states.

      /----------\                             /----------\
     |   X = 0    | ----------- A0 ----------> |   X = 1   |
     |   Y = 0    |                            |   Y = 0   |
      \----------/                             \----------/
           ^                                        |
           |                                        |
        A3 |                                        | A1
           |                                        |
           |                                        v
      /----------\                             /----------\
     |   X = 1    | <---------- A2 ----------- |   X = 0   |
     |   Y = 1    |                            |   Y = 1   |
      \----------/                             \----------/

*)

EXTENDS Integers

VARIABLES x, y

Init ==
    /\ x = 0
    /\ y = 0

A0 ==
    /\ x = 0
    /\ y = 0
    /\ x' = 1 /\ UNCHANGED y

A1 ==
    /\ x = 1
    /\ y = 0
    /\ x' = 0
    /\ y' = 1

A2 ==
    /\ x = 0
    /\ y = 1
    /\ x' = 1
    /\ UNCHANGED y

A3 ==
    /\ x = 1
    /\ y = 1
    /\ x' = 0
    /\ y' = 0

TypeXOk == x \in {0, 1}
TypeYOk == y \in {0, 1}

Next == A0 \/ A1 \/ A2 \/ A3

====
