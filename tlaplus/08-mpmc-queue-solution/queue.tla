---- MODULE queue ----
EXTENDS Sequences, Integers
\* https://apalache-mc.org/docs/lang/sequences.html

CONSTANTS
    BUFFER_SIZE,
    PRODUCERS,
    CONSUMERS

VARIABLES
    buffer,
    wait_set

Count == Len(buffer)

Wait(t) ==
    /\ wait_set' = wait_set \cup {t}
    /\ UNCHANGED buffer

\* g is a group that needs to be notified
Notify(g) ==
    \/ /\ (wait_set \cap g) # {}
       /\ \E t \in (wait_set \cap g): wait_set' = wait_set \ {t}
    \/ /\ (wait_set \cap g) = {}
       /\ UNCHANGED wait_set

Produce(t, d) ==
    \/ /\ Count < BUFFER_SIZE
       /\ buffer' = Append(buffer, d)
       /\ Notify(CONSUMERS)
    \/ /\ Count = BUFFER_SIZE
       /\ Wait(t)

Consume(t) ==
    \/ /\ Count # 0
       /\ buffer' = Tail(buffer)
       /\ Notify(PRODUCERS)
    \/ /\ Count = 0
       /\ Wait(t)

Init ==
    /\ buffer = <<>>
    /\ wait_set = {}

Next ==
    \/ \E p \in (PRODUCERS \ wait_set): Produce(p, 0)
    \/ \E c \in (CONSUMERS \ wait_set): Consume(c)

NoDeadlock == wait_set # (PRODUCERS \cup CONSUMERS)
====
