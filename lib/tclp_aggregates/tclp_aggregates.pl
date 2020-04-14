:- package(tclp_aggregates).


:- set_prolog_flag( multi_arity_warnings   , off ).
:- set_prolog_flag( discontiguous_warnings , off ).

:- use_package(assertions).

:- doc(nodoc, assertions).

:- doc(filetype, package).

:- doc(author,"Joaquin Arias Herrero").
:- doc(author,"The Ciao Development Team").

:- doc(title,"ATCLP -  Aggregates").

:- doc(stability,beta).

:- doc(module, "Aggregates are used to compute single items of
information from separate pieces of data, such as answers to a query
to a logic program. Some examples are the maximum / minimum or the set
of answers. The computation of aggregates in Prolog or variant-based
tabling can infinitely loop even if the aggregate only requires a
finite amount of computations / answers. When answer subsumption /
mode-directed tabling is used, termination improves but its behavior
is not consistent. We present a framework to incrementally compute
aggregates for elements in a lattice. 

We use the entailment and join relations of the lattice to define (and
compute) aggregates and decide whether some atom is compatible with
(entails) the aggregate. The semantics of the aggregates so defined is
consistent with the LFP semantics of tabling. Our implementation is
based on the TCLP framework available in Ciao Prolog and improves its
termination properties w.r.t. similar approaches. 

Users can define aggregation operators and how answers are
aggregated. Describing aggregates that do not fit into the lattice
structure is possible, but some properties guaranteed by the lattice
may not hold. However, the flexibility provided by this possibility
justifies its inclusion. We validate our design with several examples
and we evaluate their performance.").


:- doc(aggregate/1,"Declaration not supported - use agg_entail/1 or agg_join/1 instead.").

:- doc(agg_entail/1,"It declares a tabled / entailment-based aggregated predicate.").

:- doc(agg_join/1,"It declares a tabled / join-based aggregated predicate.").


:- include(library(tclp_aggregates/tclp_aggregate_rt)).

:- new_declaration(aggregate/1).
:- new_declaration(agg_entail/1).
:- new_declaration(agg_join/1).

:- op(1150, fx, [ aggregate, agg_entail, agg_join ]).

:- load_compilation_module(library(tclp_aggregates/tclp_aggregates_tr)).
:- add_sentence_trans(tclp_aggregates_tr:do_term_expansion/3, 700). % TODO: Probably not right priority





