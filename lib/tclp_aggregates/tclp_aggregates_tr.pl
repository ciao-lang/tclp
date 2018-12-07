:- module(tclp_aggregates_tr, _).

:- use_module(library(lists),
	    [
		append/3
	    ]).

:- use_module(engine(basic_props)).

:- dynamic 'trans$prolog'/1, 'trans$aggregate'/2.
:- dynamic 'trans$entail_agg'/1, 'trans$join_agg'/1.

do_term_expansion(0, _, _Module) :-
	retractall_fact('trans$prolog'(_)),
	retractall_fact('trans$aggregate'(_,_)),
	retractall_fact('trans$entail_agg'(_)),
	retractall_fact('trans$join_agg'(_)).

do_term_expansion(end_of_file, [end_of_file], _) :- !.

do_term_expansion(':-'(Com), Clauses, _) :- !,
	expand_command(Com, Clauses).
%% 	expand_command(Com,Clauses),
%% 	display(Clauses), nl.

do_term_expansion(Clause, Clauses, _) :-
	(
	    Clause = (Head :- Body) ->
	    true
	;
	    (Clause :- true) = (Head :- Body)
	),
	functor(Head, Name, Arity),
	(
	    'trans$aggregate'(Name/Arity, CompleteAggModes) ->
	    convert_agg_clause(Head, Body, CompleteAggModes, Clauses)
	;
	    Clauses = Clause
	).
%% 	),
%% 	display(Clauses), nl.

convert_agg_clause(Head, Body, AggModes, (NewHead :- (PreBody, Body, nop(NewVars)))) :-
	Head =.. [Name|Args],
	length(Args, Arity),
	name(Name,CodeName),
	append("$aggregate_", CodeName, NewCodeName),
	name(NewName, NewCodeName),
	length(NewVars, Arity),
	NewHead =.. [NewName|NewVars],
	convert_agg_clause_(Args,NewVars,AggModes,PreBodyList),
	list_to_conj(PreBodyList,PreBody).

convert_agg_clause_(_,_,[],[]).
convert_agg_clause_([A|Args],[A|NVars],['_'|Modes],Pres) :-	
	convert_agg_clause_(Args,NVars,Modes,Pres).
convert_agg_clause_([A|Args],[V|NVars],[M|Modes],[Pre|Pres]) :-
	Pre = ( get(V,(M,Att)), Att = A ),
	convert_agg_clause_(Args,NVars,Modes,Pres).
	
	
expand_command(table(Preds), Clauses) :- !,
	expand_command_table(Preds, Clauses, [], entail).
expand_command(join(Preds), Clauses) :- !,
	expand_command_table(Preds, Clauses, [],  join).
	

expand_command_table((Pred/A, Preds), [(:-table(Pred/A))|Clauses0], Clauses, Type) :- !,
	expand_command_table(Preds, Clauses0, Clauses, Type).
expand_command_table(Pred/A, [(:-table(Pred/A))|Clauses], Clauses, _) :- !.
expand_command_table((Pred, Preds), Clauses0, Clauses, Type) :-
	struct(Pred), !,
	expand_command_table_one(Pred, Clauses0, Clauses1, Type),
	expand_command_table(Preds, Clauses1, Clauses, Type).
expand_command_table(Pred, Clauses0, Clauses, Type) :- 
	struct(Pred), !,
	expand_command_table_one(Pred, Clauses0, Clauses, Type).
expand_command_table(_, Clauses, Clauses, _).

expand_command_table_one(Pred, Clauses0, Clauses, Type) :-
	Pred =.. [Name| AggModes],
	length(AggModes, Arity),
	(
	    'trans$aggregate'(Name/Arity,_) ->
	    print('Warning: aggregated predicate already declared\n'),
	    Clauses0 = Clauses
	;
	    add_aggregate_translation(Type, AggModes,  CompleteAggModes, AggTranslation),
	    change_entry_predicate(Name/Arity:CompleteAggModes, Tabled, ExpandedPred),
	    assert('trans$aggregate'(Name/Arity,CompleteAggModes)),
	    Clauses0 = [AggTranslation, Tabled, ExpandedPred|Clauses]
	).


change_entry_predicate(Name/Arity:Modes, (:- table(NewName/Arity)), (Head :- (PreBody,NewHead,PostBody))):-
	length(Args, Arity),
	Head =.. [Name|Args],
	length(NewVars, Arity),
	name(Name,CodeName),
	append("$aggregate_", CodeName, NewCodeName),
	name(NewName, NewCodeName),
	NewHead =.. [NewName|NewVars],
	change_entry_predicate_(Args,NewVars,Modes,PreBodyList,PostBodyList),
	list_to_conj(PreBodyList,PreBody),
	list_to_conj(PostBodyList,PostBody).

change_entry_predicate_([],[],[],[],[]).
change_entry_predicate_([A|Args],[A|NVars],['_'|Modes],Pre,Post) :- !,
	change_entry_predicate_(Args,NVars,Modes,Pre,Post).
change_entry_predicate_([A|Args],[V|NVars],[M/Arity|Modes],[Pre|Pres], [Pos|Posts]) :-
	Pre = (
		  put(V,(M/Arity,F))
	      ),
	Pos = (
		  ground(A) ->
		  entails(M,A,F)
	      ;
		  A = F
	      ),
	change_entry_predicate_(Args,NVars,Modes,Pres,Posts).


add_aggregate_translation(Type, Modes, CompModes, TranslationList) :-
	add_aggregate_translation_(Type, Modes, CompModes, TranslationList).
add_aggregate_translation_(_,[],[],[]).
add_aggregate_translation_(Type,['_'|Modes],['_'|CompModes],Trans) :- !,
	add_aggregate_translation_(Type,Modes,CompModes, Trans).
add_aggregate_translation_(entail,[M|Modes],[M/2|CompModes],Trans) :-	
	( 'trans$join_agg'(M) ; 'trans$entail_agg'(M) ), !,
	add_aggregate_translation_(entail,Modes,CompModes,Trans).
add_aggregate_translation_(entail,[M|Modes],[M/2|CompModes],Trans0) :-
	assert('trans$entail_agg'(M)),
	M =.. [AggName|AggArg],
	EntailCall =.. [AggName,B,A|AggArg],
	Trans0 = [ (entails(M,A,B) :- EntailCall) | Trans ],
	add_aggregate_translation_(entail,Modes,CompModes,Trans).
add_aggregate_translation_(join,[M|Modes],[M/3|CompModes],Trans) :-	
	( 'trans$join_agg'(M) ), !,
	add_aggregate_translation_(join,Modes,CompModes,Trans).
add_aggregate_translation_(join,[M|Modes],[M/3|CompModes],Trans0) :-
	assert('trans$join_agg'(M)),
	M =.. [AggName|AggArg],
	JoinCall =.. [AggName,A,B,C|AggArg],
	(
	    'trans$entail_agg'(M) ->
	    Trans0 = [
			 (join(M,A,B) :- JoinCall) | Trans
		     ]
	;
	    EntailCall =.. [AggName,B,A|AggArg],
	    Trans0 = [
			 (entails(M,A,B) :- EntailCall),
			  (join(M,A,B,C) :- JoinCall) | Trans
		     ]
	),
	add_aggregate_translation_(join,Modes,CompModes,Trans).

	


conj_to_list(Term, List) :-
	conj_to_list_3(Term, List, []).
conj_to_list_3(Term, List0, List) :-
	( Term = (T1, T2) ->
	    conj_to_list_3(T1, List0, List1),
	    conj_to_list_3(T2, List1, List)
	; Term == true ->
	    List0 = List
	; List0 = [Term|List]
	).

list_to_conj([],         true).
list_to_conj([Lit|List], G0) :-
	( List == [] ->
	    G0 = Lit
	; G0 = (Lit, G),
	    list_to_conj(List, G)
	).
