:- package(tclp_ground).


:- set_prolog_flag( multi_arity_warnings   , off ).
:- set_prolog_flag( discontiguous_warnings , off ).

:- use_package(assertions).

:- doc(nodoc, assertions).

:- doc(filetype, package).

:- doc(author,"Joaquin Arias Herrero").
:- doc(author,"The Ciao Development Team").

:- doc(title,"TCLP -  Ground").

:- doc(stability,beta).

:- doc(module, "TCLP ground is an instanciation of TCLP where instead
of implementing a generic constraint solver, the interface is able to
provide the generic predicaates to check call / answer entailment and
the apply predicate to check the consistency of the answers.").


:- doc(table/1,"It declares a tabled predicate with answer entailment check.").

:- doc(join/1,"It declares a tabled  predicate wiht answer join check.").


:- include(library(tclp_ground/tclp_ground_rt)).

:- new_declaration(join/1).

:- op(1150, fx, [ join ]).

:- load_compilation_module(library(tclp_ground/tclp_ground_tr)).
:- add_sentence_trans(tclp_ground_tr:do_term_expansion/3, 700). % TODO: Probably not right priority





