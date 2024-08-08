---- MODULE dub ----
EXTENDS Integers, Sequences, TLC

(*--algorithm dub
  variable
    seq = <<1, 2, 3, 2>>;
    index = 1;
    seen = {};
    is_unique = TRUE;
begin
    Iterate:
      while index <= Len(seq) do
        if seq[index] \notin seen then
          seen := seen \union {seq[index]};
        else
          is_unique := FALSE;
        end if;
          index := index + 1;
      end while;
end algorithm; *)

\* BEGIN TRANSLATION (chksum(pcal) = "951b6ccd" /\ chksum(tla) = "6a0eb72e")
VARIABLES seq, index, seen, is_unique, pc

vars == << seq, index, seen, is_unique, pc >>

Init == (* Global variables *)
        /\ seq = <<1, 2, 3, 2>>
        /\ index = 1
        /\ seen = {}
        /\ is_unique = TRUE
        /\ pc = "Iterate"

Iterate == /\ pc = "Iterate"
           /\ IF index <= Len(seq)
                 THEN /\ IF seq[index] \notin seen
                            THEN /\ seen' = (seen \union {seq[index]})
                                 /\ UNCHANGED is_unique
                            ELSE /\ is_unique' = FALSE
                                 /\ seen' = seen
                      /\ index' = index + 1
                      /\ pc' = "Iterate"
                 ELSE /\ pc' = "Done"
                      /\ UNCHANGED << index, seen, is_unique >>
           /\ seq' = seq

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Iterate
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION

====
