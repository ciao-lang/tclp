%% Common aggregates examples to be used under tclp_aggregates%%

:- use_package(hiord).
:- use_module(library(sets)).
:- use_module(library(terms_check)).
:- use_module(library(hiordlib)).

    
:- push_prolog_flag(multi_arity_warnings, off).

%% Entailment-based aggregates %%
interval(A1-A2,B1-B2):- A1=<B1, A2>=B2. 

set(A,B):- ord_subset(B,A).

sub(A,B):- instance(B,A).

frontier(Op,As,Bs):- maplist(Op,As,Bs).

n_frontier([],[],[]).
n_frontier([Op | Ops],[A | As],[B | Bs]):-
    Op(A,B), n_frontier(Ops,As,Bs).


%% Join-based aggregates %%
interval(A1-A2,B1-B2,C1-C2):-
    (A1=<B1 -> C1=A1; C1=B1),
     (A2>=B2 -> C2=A2; C2=B2).


set(A,B,C):- ord_union(A,B,C).



%% non-lattice aggregaets %%
first(_,_):- true.

last(_,_):- fail.
last(_,B,B).

all(_,_):- fail.

threshold(Epsilon,A,B):- A < Epsilon*B.

add(_,_):- fail.
add(A,B,C):- C is A+B.

mlt(_,_):- fail.
mlt(A,B,C):- C is A*B.

:- push_prolog_flag(multi_arity_warnings, on).


