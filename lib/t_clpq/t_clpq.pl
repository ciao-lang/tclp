:- package(t_clpq).

:- if(defined('SHELL')).
:- else.
:- export([
            call_domain_projection/2,
            answer_domain_projection/2,
            call_store_projection/3,
            answer_store_projection/3,
            call_entail/2,
            answer_check_entail/3,
            apply_answer/2
        ]).
:- endif.

:- use_module(library(clpq/clpq_dump), [clpqr_dump_constraints/3]).

:- use_package(tabling).
:- use_package(clpq).

:- active_tclp.

% ORIGINAL VERSION - PPDP

% call_domain_projection(_, _).
% call_entail(X, _, _, (X-S2)) :-
%       clpq_entailed(S2).
% call_store_projection(X, _, (V-S)) :-
%       clpqr_dump_constraints(X, V ,S).

% answer_domain_projection(X, (V1-S1)) :-
%       clpqr_dump_constraints(X, V1, S1).
% answer_check_entail(X, _, (X-S2), _, 1, _) :-
%       clpq_entailed(S2), !.
% answer_check_entail(_, (X-S1), (X-S2), _, -1,_) :-
%       clpq_meta(S2),
%       clpq_entailed(S1).
% answer_store_projection(_, _, _).

% apply_answer(X, (X-S1), _) :-
%       clpq_meta(S1).



%% NEW VERSION - TPLP
:- if(defined('SHELL')).
:- else.
%% option A: two-steps
call_domain_projection(Vars, Vars).
call_entail(Vars, (V2-S2)) :-
    \+ \+ (
              Vars = V2,
              clpq_entailed(S2)
          ).
call_store_projection(Vars, _, (F-S)) :-
    clpqr_dump_constraints(Vars, F ,S).

answer_domain_projection(X, (X-S1)) :-
    clpqr_dump_constraints(X, X, S1).
answer_check_entail((V1-_S1), (V2-S2), 1) :-
    \+ \+ (
              V1 = V2,
              clpq_entailed(S2)
          ),!.
answer_check_entail((V1-S1), (V2-S2), -1) :-
    \+ \+ (
              V1 = V2,
              clpq_meta(S2),
              clpq_entailed(S1)
          ).
answer_store_projection(_, St, St).

apply_answer(X, (X-S1)) :- 
    clpq_meta(S1).
:- endif.