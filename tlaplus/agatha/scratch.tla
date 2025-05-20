---- MODULE scratch ----
EXTENDS Integers, Sequences, TLC

TruthTable == [p, q \in BOOLEAN |-> p => q]

result == TruthTable[FALSE, TRUE]

people == {"Agatha", "Butler", "Charles"}
agatha == {"Agatha", "Charles"}

agatha_hates == people \ agatha







====
