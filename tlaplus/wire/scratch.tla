---- MODULE scratch ----
EXTENDS Integers, Sequences

Num == 5

Square(x) == x # 1

B == FALSE
A == TRUE


seq == << 1, 2, 3 >>

current == << 23, 15, 12 >>
later == << 24, 15, 12 >>

ToSeconds(t) == t[1] * 3600 + t[2] * 60 + t[3]
Earlier(one, two) == ToSeconds(one) < ToSeconds(two)

res == Earlier(current, later)

res2 == (0..3) \X (0..3)
res3 == { x \in 1..20: x % 2 = 0 }

a == { 1, 2, 3 }

res4 == a \X a

====
