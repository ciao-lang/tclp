:- discontiguous entails/3, join/4.


:- use_package(tabling).
:- active_tclp.

:- use_package(attr).
:- use_module(engine(attributes)).

:- multifile join/4, entails/3.

join(_,_,_,_) :- fail.
%entails(_,_,V) :-  var(V), !.
nop(_).

minimax_tabling_stats :- tabling_stats.

%%%%%%% attributes predicates %%%%%%%%%%%%%%%%%%%%
:- multifile attr_portray_hook/2.
:- multifile attr_unify_hook/2. %% needed
:- multifile attribute_goals/3.

attr_portray_hook(Att, Var) :-
	display(Var), display(', '), display(Att).

attr_unify_hook(_Att, _X) :-
	print(unify_hook),nl,
	true.

attribute_goals(X, [S|T], T) :-
	get_attr_local(X, Att),
	S = (abs(X, Att)).

put(Var,Att) :- put_attr_local(Var, Att).
get(Var,Att) :- get_attr_local(Var, Att).
del(Var) :- detach_attribute(Var).
%%%%%%% attributes predicates %%%%%%%%%%%%%%%%%%%%



%%%%%%% TCLP Interface %%%%%%%%%%%%%%%%%%%%
call_domain_projection([], []).
call_domain_projection([V|Vars], [A|Atts]) :-
	store_projection_(V,A),
	call_domain_projection(Vars, Atts).
answer_domain_projection([], []).
answer_domain_projection([V|Vars], [A|Atts]) :-
	store_projection_(V,A),
	answer_domain_projection(Vars,Atts).
call_store_projection(_, St, St).
answer_store_projection(_, St, St).

call_entail([], []).
call_entail([A1|Atts1], [A2|Atts2]) :-
	call_entail_(A1,A2),
	call_entail(Atts1, Atts2), !.

answer_check_entail([],[],agg([])) :- !.
answer_check_entail([],[],_) :- !.
answer_check_entail([A1|Atts1], [A2|Atts2] , 1) :-
	answer_compare_(A1,A2,1),
	answer_check_entail(Atts1, Atts2, 1).
answer_check_entail([A1|Atts1], [A2|Atts2] , -1) :-
	answer_compare_(A1,A2,-1),
	answer_check_entail(Atts1, Atts2, -1).
answer_check_entail([A1|Atts1], [A2|Atts2], agg([New|AttsAgg])) :-
	answer_compare_(A1,A2,agg(New)),
	answer_check_entail(Atts1, Atts2, agg(AttsAgg)).

apply_answer([], []).
apply_answer([V|Vars], [A|Atts]) :-
	apply_answer_(V,A),
	apply_answer(Vars,Atts).


%%%%%%% TCLP Interface %%%%%%%%%%%%%%%%%%%%

store_projection_(V, (Agg,A))             :- get(V, (Agg,A)).
call_entail_((_  ,_), (_  ,B))            :- var(B),!.
call_entail_((Agg/_,A), (Agg/_,B))            :- entails(Agg,A,B).
answer_compare_((Agg/_,A), (Agg/_,B),1)    :- entails(Agg,A,B),!.
answer_compare_((Agg/_,A), (Agg/_,B),-1)    :- entails(Agg,B,A),!.
answer_compare_((Agg/3,A), (Agg/3,B),agg((Agg/3,New))) :- join(Agg,A,B,New).
apply_answer_(V, (Agg,B))     :- get(V,(Agg,A)), \+ ground(A), !, A = B.
apply_answer_(V, (Agg/_,B))     :- get(V,(Agg/_,A)), ground(A), entails(Agg,A,B).
