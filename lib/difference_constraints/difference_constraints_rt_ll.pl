:- module(difference_constraints_rt_ll,
        [
            %%          '$incr_dc_num_vars'/0,
            %%          '$decr_dc_num_vars'/0,
            %%          '$put_dc_value'/3,
            %%          '$put_dc_pi'/1,
            %%          '$put_dc_attr'/2,
            %%          '$put_dc_space'/1,
            %%  %%      difference_constraints_get_space/2,
            %%          difference_constraints_backtracking_space/2,
            difference_constraints_print/0,
            difference_constraints_print_variable/1,
            difference_constraints_LB/2,
            difference_constraints_UB/2,
            difference_constraints_var/1,
            difference_constraints_const/3,
            difference_constraints_min/2,
            difference_constraints_max/2,
            difference_constraints_difference/3,
            difference_constraints_delay/1,
            difference_constraints_reset/3,
            difference_constraints_full_abstraction/1,
            difference_constraints_normalize/3,
            difference_constraints_do_canonical/0,
    
            %% Tabling interface
            aux_project_domain/3,
            aux_project_gen_store/4,
            aux_project_gen_store_A/4,
            aux_project_gen_store_B/4,
            aux_project_answer_store/4,
            aux_entail/3,
            aux_check_entail/4,
            aux_check_entail_A/4,
            aux_check_entail_B/4,
            aux_apply_answer/4,
            aux_current_store/1,
            aux_reinstall_store/4
        ],
        [assertions, basicmodes, regtypes, foreign_interface]).

:- use_module(engine(attributes)).
:- use_module(library(tabling/forward_trail)).


%% :- extra_compiler_opts(['-DDEBUG_ALL -DDEBUG_GMORE_GENERAL -DDEBUG_ADD_CONSTRAINT_ANSWER -DDEBUG_DIJKSTRA -DDEBUG_MALLOC']).

%% :- extra_compiler_opts([' -DDEBUG_ALL']).

:- extra_compiler_opts(['-g']).

difference_constraints_print_variable(X) :-
    get_attribute(X, '$dbm_id'(Id, _)),
    difference_constraints_print_variable_aux(Id).

difference_constraints_var(X) :-
    var(X),
    difference_constraints_var_aux(Id),
    attach_attribute(X, '$dbm_id'(Id, X)).

difference_constraints_LB(X, LB) :-
    var(X), number(LB),
    get_attribute(X, '$dbm_id'(Id, _)),
    !,
    difference_constraints_LB_aux(Id, LB).
difference_constraints_LB(X, LB) :-
    var(X), number(LB),
    difference_constraints_var_aux(Id),
    attach_attribute(X, '$dbm_id'(Id, X)),
    difference_constraints_LB_aux(Id, LB).

difference_constraints_UB(X, UB) :-
    var(X), number(UB),
    get_attribute(X, '$dbm_id'(Id, _)),
    !,
    difference_constraints_UB_aux(Id, UB).
difference_constraints_UB(X, UB) :-
    var(X), number(UB),
    difference_constraints_var_aux(Id),
    attach_attribute(X, '$dbm_id'(Id, X)),
    difference_constraints_UB_aux(Id, UB).

difference_constraints_const(X, Y, D) :-
    var(X), var(Y), number(D),
    get_attr_id(X, Var1),
    get_attr_id(Y, Var2),
    difference_constraints_const_aux(Var1, Var2, D).

difference_constraints_min(X, V) :-
    var(X),
    get_attribute(X, '$dbm_id'(Id, _)),
    difference_constraints_get_value_aux(0, Id, V2),
    V is V2 * -1.

difference_constraints_max(X, V) :-
    var(X),
    get_attribute(X, '$dbm_id'(Id, _)),
    difference_constraints_get_value_aux(Id, 0, V).

difference_constraints_difference(X, Y, V) :-
    var(X),
    var(Y),
    get_attribute(X, '$dbm_id'(Id1, _)),
    get_attribute(Y, '$dbm_id'(Id2, _)),
    difference_constraints_get_value_aux(Id1, Id2, V).

difference_constraints_do_canonical :-
    difference_constraints_do_canonical_aux.

difference_constraints_delay(L) :-
    get_attr_id_list(L, LId),
    difference_constraints_delay_aux(LId).

difference_constraints_reset(X, Y, L) :-
    get_attribute(X, '$dbm_id'(Id1, _)),
    get_attribute(Y, '$dbm_id'(Id2, _)),
    get_attr_id_list(L, LId),
    difference_constraints_reset_aux(Id1, Id2, LId).

difference_constraints_full_abstraction(L) :-
    get_attr_id_list(L, LA),
    difference_constraints_full_abstraction_aux(LA).

difference_constraints_normalize(L, LB, UB) :-
    get_attr_id_list(L, LA),
    difference_constraints_normalize_aux([0|LA], LB, UB).

get_attr_id_list([],    []).
get_attr_id_list([H|R], [Id|RId]) :-
    get_attr_id(H, Id),
    get_attr_id_list(R, RId).

get_attr_id(X, Id) :-
    get_attribute(X, '$dbm_id'(Id, _)), !.

get_attr_id(X, Id) :-
    difference_constraints_var_aux(Id),
    attach_attribute(X, '$dbm_id'(Id, X)).

:- trust pred initial_space + foreign_low(initial_space_c)
# "Creates an initial difference_constraints space.".

:- initialization(initial_space).

:- trust pred '$incr_dc_num_vars' + foreign_low(incr_dc_num_vars_c)
# "Increments the number of constraint variables.".

:- trust pred '$decr_dc_num_vars' + foreign_low(decr_dc_num_vars_c)
# "Decrements the number of constraint variables.".

:- trust pred '$put_dc_value'(+X, +Y, +V) :: int * int * int
    + foreign_low(put_dc_value_c)
# "Reinstalls a value constraint between two variables.".

:- trust pred '$put_dc_pi'(+PI) :: int
    + foreign_low(put_dc_pi_c)
# "Reinstalls the value of pi.".

:- trust pred '$put_dc_attr'(+Var, +Attr) ::
    int * int + foreign_low(put_dc_attr_c)
# "Reinstalls the value of an attribute.".

:- trust pred '$put_dc_space'(+SPACE) :: int
    + foreign_low(put_dc_space_c)
# "Reinstalls the space value.".

:- trust pred difference_constraints_print + foreign_low(
        difference_constraints_print_c)
# "Prints difference_constraints space.".

:- trust pred difference_constraints_print_variable_aux(+Var) ::
    int + foreign_low(difference_constraints_print_variable_c)
# "Prints a constraint variable.".

%% :- trust pred difference_constraints_get_space(-Var, -Var) :: 
%% int * int + foreign_low(difference_constraints_get_space_c)
%%      # "Gets the current difference_constraints state.".
%% 
%% :- trust pred difference_constraints_backtracking_space(-Var, -Var) :: 
%% int * int + foreign_low(difference_constraints_backtracking_space_c)
%%      # "Backtracks over a previous difference_constraints state.".

:- trust pred difference_constraints_var_aux(-Id) :: int + foreign_low(
        difference_constraints_var_c)
# "Adds a new different constraint variable.".

:- trust pred difference_constraints_LB_aux(+Var, -Id) :: int * int
    + foreign_low(difference_constraints_LB_c)
# "Adds a new different constraint variable lower bound.".

:- trust pred difference_constraints_UB_aux(+Var, -Id) :: int * int
    + foreign_low(difference_constraints_UB_c)
# "Adds a new different constraint variable upper bound.".

:- trust pred difference_constraints_get_value_aux(+Var1, +Var2, -Id) :: int *
    int * int + foreign_low(difference_constraints_get_value_c) # "Get the
    value of a different constraint.".

:- trust pred difference_constraints_delay_aux(+L) :: int + foreign_low(
        difference_constraints_delay_c)
# "Delays constraints in L.".

:- trust pred difference_constraints_reset_aux(+X, +Y, +L) :: int *int * int
    + foreign_low(difference_constraints_reset_c)
# "Resets the constraint variable X.".

:- trust pred difference_constraints_full_abstraction_aux(+L) :: int
    + foreign_low(difference_constraints_full_abstraction_c)
# "Force full_abstraction between variables in L.".

:- trust pred difference_constraints_normalize_aux(+L, +LU, +UB) :: int * int *
    int + foreign_low(difference_constraints_normalize_c)
# "Force normalization of variables in L.".

:- trust pred difference_constraints_const_aux(+Var1, +Var2, +Value) ::
    int * int * int + foreign_low(difference_constraints_const_c)
# "Adds a new different constraint.".

:- trust pred difference_constraints_do_canonical_aux + foreign_low(
        difference_constraints_do_canonical_c)
# "Does the canonical form of the DBM.".


%% Tabling interface %%
:- trust pred aux_project_domain(+Vars, -Size, -Doms) ::
    int * int * int + foreign_low(project_domain_c)
# "dump the attributes variables Vars in Size and Doms.".

:- trust pred aux_project_gen_store(+Vars, +Size, +Doms, -ProjectStore) ::
    int * int * int * int + foreign_low(project_gen_store_c)
# "ProjectStore is the memory address of the projection over Vars.".

:- trust pred aux_project_gen_store_A(+Vars, +Size, +Doms, -ProjectStore) ::
    int * int * int * int + foreign_low(project_gen_store_A_c)
# "ProjectStore is the memory address of the projection over Vars.".

:- trust pred aux_project_gen_store_B(+Vars, +Size, +Doms, +ProjectStore) ::
    int * int * int * int + foreign_low(project_gen_store_B_c)
# "ProjectStore is the memory address of the projection over Vars.".

:- trust pred aux_project_answer_store(+Vars, +Size, +Doms, -ProjectStore) ::
    int * int * int * int + foreign_low(project_answer_store_c)
# "AnswerStore is the projection of the answer store over Vars.".

:- trust pred aux_entail(+SizeA, +DomsA, +StoreB) ::
    int * int * int + foreign_low(entail_c)
# "Evaluate if Doms entail with the GenStore".

:- trust pred aux_check_entail(+SizeA, +DomsA, +StoreB, -Result) ::
    int * int * int * int + foreign_low(check_entail_c)
# "Evaluate if Doms entail with the GenStore (Result = 1) or vice versa (Result = -1)".

:- trust pred aux_check_entail_A(+SizeA, +DomsA, +StoreB, -Result) ::
    int * int * int * int + foreign_low(check_entail_A_c)
# "Evaluate if Doms entail with the GenStore (Result = 1) or vice versa (Result = -1)".

:- trust pred aux_check_entail_B(+SizeA, +DomsA, +StoreB, -Result) ::
    int * int * int * int + foreign_low(check_entail_B_c)
# "Evaluate if Doms entail with the GenStore (Result = 1) or vice versa (Result = -1)".

:- trust pred aux_current_store(-OrigStore) ::
    int + foreign_low(current_store_c)
# "OrigStore is the memory address of the current store.".

:- trust pred aux_reinstall_store(+Vars, +Size, -Doms, +Store) ::
    int * int * int * int + foreign_low(reinstall_store_c)
# "reinstall the origin store of the generator.".

:- trust pred aux_apply_answer(+Vars, +Size, +Doms, +Store) ::
    int * int * int *int + foreign_low(apply_answer_c)
# "undump the atributes varialbes and check that the answer is correct.".
%% Tabling interface %%



:- use_foreign_source(['difference_constraints.c', 'difference_constraints_tab.c']).
