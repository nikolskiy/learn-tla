---- MODULE simple ----

EXTENDS Integers, TLC

(*--algorithm simple

variables
     x = 1

begin
    A:
        x := x + 1;
    B:
        x := x + 2;

end algorithm; *)

\* BEGIN TRANSLATION (chksum(pcal) = "e372bf1f" /\ chksum(tla) = "cb71d360")
VARIABLES x, pc

vars == << x, pc >>

Init == (* Global variables *)
        /\ x = 1
        /\ pc = "A"

A == /\ pc = "A"
     /\ x' = x + 1
     /\ pc' = "B"

B == /\ pc = "B"
     /\ x' = x + 2
     /\ pc' = "Done"

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == A \/ B
          \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION

====
