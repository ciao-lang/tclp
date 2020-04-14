:- package(difference_constraints_O).
:- export([
            call_domain_projection/2,
            answer_domain_projection/2,
            call_store_projection/3,
            answer_store_projection/3,
            call_entail/2,
            answer_check_entail/3,
            apply_answer/2,
            current_store/1,
            reinstall_store/3
        ]).


:- use_package(library(difference_constraints)).
:- active_tclp.

%% NEW VERSION
call_domain_projection(Vars, st(Size,Dom, _)) :-
    aux_project_domain(Vars, Size, Dom).
call_entail(st(SizeA, DomA, _), st(_,_,StoreB)) :-
    aux_entail(SizeA, DomA, StoreB).
call_store_projection(Vars, st(Size, Dom, _), st(Size, Dom, ProjectStore)) :-
    aux_project_gen_store(Vars, Size, Dom, ProjectStore).


answer_domain_projection(Vars, st(Size, Dom, _)) :-
    aux_project_domain(Vars, Size, Dom).
answer_check_entail(_, _, _Result) :-
    fail.
answer_store_projection(Vars, st(Size, Dom, _), st(Size, Dom, ProjectStore)) :-
    aux_project_answer_store(Vars, Size, Dom, ProjectStore).

apply_answer(Vars, st(Size, Dom, Store)) :-
    aux_apply_answer(Vars, Size, Dom, Store).


current_store(Store) :-
    aux_current_store(Store).
reinstall_store(Vars, st(Size, Dom, _), Store) :-
    aux_reinstall_store(Vars, Size, Dom, Store).
