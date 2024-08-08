------------------------------- MODULE bucket -------------------------------

EXTENDS Integers
VARIABLE big, small

TypeOk == /\ big \in 0..5
          /\ small \in 0..3

Init == /\ big = 0
        /\ small = 0

FillBig == /\ big' = 5
           /\ small' = small

FillSmall == /\ big' = big
             /\ small' = 3

EmptyBig == /\ big' = 0
            /\ small' = small

EmptySmall == /\ big' = big
              /\ small' = 0

Small2Big == IF big + small <= 5
             THEN /\ big' = big + small
                  /\ small' = 0
             ELSE /\ big' = 5
                  /\ small' = small - (5 - big)

Big2Small == IF big + small <= 3
             THEN /\ small' = big + small
                  /\ big' = 0
             ELSE /\ small' = 3
                  /\ big' = big - (3 - small)

(*
This produces an error but that is what we are looking for
Error gives us a path how to get to exactly 4 gallons.
*)
Inv == big /= 4

Next == \/ FillBig
        \/ FillSmall
        \/ EmptyBig
        \/ EmptySmall
        \/ Small2Big
        \/ Big2Small

=============================================================================
