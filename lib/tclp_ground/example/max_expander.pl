:- module(max_expander,_).

:- use_package(expander).
:- use_package(tclp_ground).

:- table p(max).

p(0).
p(1).
p(2) :- p(1).
p(3) :- p(0).

ground_entail(_,_,B) :- var(B), !.
ground_entail(max,A,B) :- B >= A.
ground_compare(max,A,B,1) :- B >= A.
%ground_compare(max,A,B,-1) :- B < A.
ground_join(max,A,B,A).
ground_apply(max,A,B) :-
	( ground(A)
	-> ground_compare(max,A,B,1)
	; A = B ).
