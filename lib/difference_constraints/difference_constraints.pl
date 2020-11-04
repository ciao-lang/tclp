:- package(difference_constraints).

:- use_package(runtime_ops).

:- include(library(difference_constraints/difference_constraints_ops)).

:- if(defined('SHELL')).
:- else.
:- use_module(library(difference_constraints/difference_constraints_rt_ll)).
:- use_module(library(difference_constraints/difference_constraints_rt)).
:- include(library(difference_constraints/difference_constraints_attributes)).

:- reexport(library(difference_constraints/difference_constraints_rt_ll), [
    % '$forward_trail'/2,
    % '$incr_dc_num_vars'/0,
    % '$decr_dc_num_vars'/0,
    % '$put_dc_value'/3,
    % '$put_dc_pi'/1,
    % '$put_dc_attr'/2,
    % '$put_dc_space'/1,
    difference_constraints_print/0,
    difference_constraints_print_variable/1,
    difference_constraints_var/1,
    difference_constraints_min/2,
    difference_constraints_max/2,
    difference_constraints_difference/3,
    difference_constraints_delay/1,
    difference_constraints_reset/3,
    difference_constraints_full_abstraction/1,
    difference_constraints_normalize/3,
    difference_constraints_do_canonical/0
]).

:- reexport(library(difference_constraints/difference_constraints_rt), [
    '#='/2,
    '#>'/2,
    '#<'/2,
    '#>='/2,
    '#=<'/2,
    '#<>'/2
]).
:- endif.