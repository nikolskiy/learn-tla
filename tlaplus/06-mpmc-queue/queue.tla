---- MODULE queue ----

EXTENDS Sequences, Naturals

CONSTANTS
    BUFFER_SIZE,  (* Size of the queue buffer *)
    PRODUCERS,    (* Number of producer processes *)
    CONSUMERS     (* Number of consumer processes *)

VARIABLES buffer, wait_set

AllThreads == PRODUCERS \cup CONSUMERS
RunningThreads == AllThreads \ wait_set

Wait(t) ==
    /\ wait_set' = wait_set \cup {t}
    /\ UNCHANGED buffer

Notify ==
    IF wait_set # {}
    THEN \E x \in wait_set: wait_set' = wait_set \ {x}
    ELSE UNCHANGED wait_set

Put(t, d) ==
    \/ /\ Len(buffer) = BUFFER_SIZE
       /\ Wait(t)
    \/ /\ Len(buffer) < BUFFER_SIZE
       /\ buffer' = Append(buffer, d)
       /\ Notify

Get(t) ==
    \/ /\ buffer # <<>>
       /\ buffer' = Tail(buffer)
       /\ Notify
    \/ /\ buffer = <<>>
       /\ Wait(t)

Init ==
    /\ buffer = <<>>
    /\ wait_set = {}

Next ==
    \/ \E p \in PRODUCERS: Put(p, p)
    \/ \E c \in CONSUMERS: Get(c)

NoDeadlock == wait_set # AllThreads
====
