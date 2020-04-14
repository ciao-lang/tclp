/*
 *  difference_constraints.h
 */

#ifndef _CIAO_DIFFERENCE_CONSTRAINTS_H
#define _CIAO_DIFFERENCE_CONSTRAINTS_H

#if !defined(TRUE)
#define TRUE            1
#define FALSE           0
#endif

/* Global vars */

/* TODO (JFMC): improper use of a header file (vars should be locally defined in the .c file) */

extern tagged_t args[3];
extern tagged_t tmp_term1, tmp_term2, undo_term;
extern intmach_t index_macro;

extern tagged_t atom_incr_dc_num_vars;
extern tagged_t atom_decr_dc_num_vars;
extern tagged_t functor_forward_trail;
extern tagged_t functor_put_dc_value;
extern tagged_t functor_put_dc_pi;
extern tagged_t functor_put_dc_space;
extern tagged_t functor_dbm_id;

CBOOL__PROTO(difference_constraints_print_c);


#define PRINT_TERM(ARG, TEXT, TERM)                   \
  {                                                   \
    printf(TEXT);                                     \
    display_term(ARG,TERM,Output_Stream_Ptr, TRUE);   \
    printf("\n");                                     \
  }     

#endif /* _CIAO_DIFFERENCE_CONSTRAINTS_H */
