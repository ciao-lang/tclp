:- package(one_difference_constraints_tab).
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


call_domain_projection(Vars, (Size,Dom)) :-
    aux_project_domain(Vars, Size, Dom).

answer_domain_projection(Vars, (Size,Dom)) :-
    aux_project_domain(Vars, Size, Dom).

call_store_projection(Vars, (Size, Dom), ProjectStore) :-
    aux_project_gen_store(Vars, Size, Dom, ProjectStore).

answer_store_projection(Vars, (Size, Dom), ProjectStore) :-
    aux_project_answer_store(Vars, Size, Dom, ProjectStore).

call_entail(_Vars, (SizeA, DomA), _DomB, StoreB) :-
    aux_entail(SizeA, DomA, StoreB).

answer_check_entail(_Vars, (SizeA, DomA), _DomB, StoreB, Result,_) :-
    aux_check_entail(SizeA, DomA, StoreB, Result).

apply_answer(Vars, (Size, Dom), Store) :-
    aux_apply_answer(Vars, Size, Dom, Store).

current_store(Store) :-
    aux_current_store(Store).

reinstall_store(Vars, (Size, Dom), Store) :-
    aux_reinstall_store(Vars, Size, Dom, Store).


% :- use_module(library(difference_constraints/difference_constraints_rt), []).
% :- use_foreign_library('Win32i686', [difference_constraints_rt_Win32i686]). % TODO: why?

%% :- extra_compiler_opts(['-DDEBUG_ALL']).

%% :- use_foreign_source(['difference_constraints_tab.c']).
