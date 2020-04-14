/*
 *  space_tab.h
 */

/* TODO (JFMC): depends on particular 32-bit tagging scheme */

#ifndef _CIAO_DIFFERENCE_CONSTRAINTS_SPACE_TAB_H
#define _CIAO_DIFFERENCE_CONSTRAINTS_SPACE_TAB_H

struct space
{
  intmach_t size;
  intmach_t limit;
  intmach_t **edges;
  intmach_t *pi;
};

CFUN__PROTO(create_space, struct space*);
CFUN__PROTO_N(clone_space, struct space*, struct space *s);
CVOID__PROTO_N(change_space, struct space *space); 
CFUN__PROTO(current_space, struct space*); 

void delete_space(struct space *space);
void print_space(struct space *space);
CFUN__PROTO_N(proy_space, struct space *, intmach_t size, tagged_t* vars, intmach_t* attrs, intmach_t undo); //
void print_variable_space(struct space *s, intmach_t id);
intmach_t isValue_space(struct space*s, intmach_t id);
CVOID__PROTO_N(delay_space, struct space *s, intmach_t v);
CVOID__PROTO_N(reset_space, struct space *s, intmach_t x, intmach_t y, intmach_t v);
CVOID__PROTO_N(full_abstraction_space, struct space *s, intmach_t v1, intmach_t v2);
CVOID__PROTO_N(normalize_space, struct space *s, intmach_t i, intmach_t j, intmach_t L, intmach_t U);
CFUN__PROTO_N(new_diff_var_space, int, struct space *s); //
CBOOL__PROTO_N(add_diff_const_space, struct space *s, intmach_t x, intmach_t y, intmach_t d); //
CVOID__PROTO_N(dijkstra_space, struct space*s, intmach_t v);
CVOID__PROTO_N(get_shortest_path_space, struct space *s, intmach_t size, intmach_t *orig_vars); //
intmach_t is_more_general_space(struct space *s1, intmach_t size, 
                          struct space *s2, intmach_t *vars); //


#endif /* _CIAO_DIFFERENCE_CONSTRAINTS_SPACE_TAB_H */
