:- module(forw_trail,
    [
        p/1
    ],[]).

:- use_package(library(tabling)).
:- use_package(library(difference_constraints/difference_constraints_tab)).

:- table t/1.

p(X) :-
    abolish_all_tables,
    difference_constraints_var(X),
    t(X).

t(X) :-
    X #>= 0,
    Z #= X + 1,
    Y #= X + 1,
    t(Z),
    t(Y).

t(X) :- X #= 1.
    
