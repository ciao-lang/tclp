 %% - Call examples: f(10,F), f(N,89).

:- module(fibo_dc, 
    [
        fib/2
    ], []).


:- use_package(library(difference_constraints)).

fib(N, F) :- 
    N #= 0, 
    F #= 0.
fib(N, F) :- 
    N #= 1,
    F #= 1.
fib(N, F):-
    N #>= 2,
    N1 #= N - 1,
    N2 #= N - 2,
    F1 #=< F,
    F2 #=< F1,
    fib(N1, F1),
    fib(N2, F2),
    F #= F1 + F2. %this is possible since F1, F2 are always integers here.

