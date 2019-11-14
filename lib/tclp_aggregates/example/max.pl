:- module(max,_).


:- use_package(tclp_aggregates).

:- table p(max).

p(0).
p(1).
p(2) :- p(1).
p(3) :- p(0).

max(A,B) :- A >= B.
