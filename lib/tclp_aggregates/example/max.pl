:- module(max,_).


:- use_package(tclp_aggregates).

:- agg_entail p(>=).
% :- agg_entail p(max).
% max(A,B) :- A >= B.

p(0).
p(1).
p(2) :- p(1).
p(3) :- p(0).




%% Example using join and an aggregate with arguments
:- agg_join k(join('aggregate argument')).

k(1).
k(2).

% the argument(s) of the aggregate are place at the beginning
join(_D,_A,_B) :- fail.
join(D, A,B,C) :- C is A+B, display(D),nl.
