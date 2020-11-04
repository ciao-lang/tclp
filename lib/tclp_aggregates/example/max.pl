:- module(max,_).


:- use_package(tclp_aggregates).

:- agg_entail p(>=).
% :- agg_entail p(max).
% max(A,B) :- A >= B.

p(0).
p(1).
p(2) :- p(1).
p(3) :- p(0).




%% %% Example using join and an aggregate with arguments
%% :- agg_join k(join('aggregate argument')).

%% k(1).
%% k(2).

%% % the argument(s) of the aggregate are place at the beginning
%% join(_D,_A,_B) :- fail.
%% join(D, A,B,C) :- C is A+B, display(D),nl.


:- agg_join i(interval).

i(i(1,10)).
i(i(12,25)).
i(i(8,15)).


interval(i(A,B), i(C,D)) :-
    A =< C, B >= D.
interval(A,B,_) :-
    display(join(A,B)),nl,fail.
interval(i(A,B), i(C,D), i(E,F)) :-
    B =< C,
    min(A,C,E), max(B,D,F).
interval(i(A,B), i(C,D), i(E,F)) :-
    A =< D,
    min(A,C,E), max(B,D,F).

max(A,B,A) :- A >= B, !.
max(_,B,B).
min(A,B,A) :- A =< B, !.
min(_,B,B).