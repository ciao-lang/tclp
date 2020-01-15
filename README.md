# TCLP - tabled constraint logic programming

This bundle contains several interfaces/framework based on tabled constraint logic programming:

* `tclp_aggregates`: is a framework to incrementally compute aggregates using TCLP:
    * Details about its design, expressiveness and syntax are described in the paper:
    ``
    J. Arias, M. Carro, "Incremental Evaluation of Lattice-Based Aggregates in Logic Programming Using Modular TCLP"
    ``
* `tclp_ground`: is a framework to compute entailment/join of herbrand
terms using TCLP:
    * It has been used to reimplement PLAI, the fixpoint used by
      CiaoPP. Details about its design, expressiveness and syntax are
      described in the paper:
      ``
      J. Arias, M. Carro, "Evaluation of the Implementation of an Abstract Interpretation Algorithm using Tabled CLP"
      ``
* `difference_constraint`: is a constraint domain written in `C` with a TCLP interface.
* `t_clpq`: is the TCLP interface of CLP(Q).
* `t_clpr`: is the TCLP interface of CLP(R).

Some packages in this bundler are experimental and needs some improvements:
* `abs_interval`, `abs_solver` and `clp_lattice`: are experimental constraint domain to be used in with an abstract interpreter under TCLP.

# Examples
Some examples of the use of TCLP with different constraint domains are included under the `examples/` directory.

Other examples related with a framework available in this bundler are included under a specific directory of its corresponding directory (e.g., see `tclp_aggregate/example` for examples of the tclp_aggregate framework).
