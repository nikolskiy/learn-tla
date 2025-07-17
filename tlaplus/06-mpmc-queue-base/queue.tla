---- MODULE queue ----
EXTENDS Sequences, Integers
\* https://apalache-mc.org/docs/lang/sequences.html

CONSTANTS
    BUFFER_SIZE,
    PRODUCERS,
    CONSUMERS

VARIABLES
    buffer

Produce(t, d) ==
    /\ Len(buffer) < BUFFER_SIZE
    /\ buffer' = Append(buffer, d)

Consume(t) ==
    /\ Len(buffer) # 0
    /\ buffer' = Tail(buffer)

Init ==
    /\ buffer = <<>>

Next ==
    \/ \E p \in PRODUCERS: Produce(p, 0)
    \/ \E c \in CONSUMERS: Consume(c)
====
