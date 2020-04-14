/*
 *  space.h
 */

/* TODO (JFMC): depends on particular 32-bit tagging scheme */

#ifndef _CIAO_DIFFERENCE_CONSTRAINTS_SPACE_H
#define _CIAO_DIFFERENCE_CONSTRAINTS_SPACE_H

#include <limits.h>

#define INI_SIZE_G      10
#define FACTOR_G        2
#define MAX             INT_MAX

struct space
{
  intmach_t size;
  intmach_t limit;
  intmach_t **edges;
  intmach_t *pi;
};


extern struct space *space;

CFUN__PROTO(create_space, struct space*);
CFUN__PROTO(clone_space, struct space*, struct space *s);
CVOID__PROTO(change_space, struct space *space); 
CFUN__PROTO(current_space, struct space*); 

void delete_space(struct space *space);
void print_space(struct space *space);

CFUN__PROTO(proy_space, struct space *, intmach_t size, tagged_t* vars, intmach_t* attrs, intmach_t undo);

void print_variable_space(struct space *s, intmach_t id);
intmach_t isValue_space(struct space*s, intmach_t id);
CVOID__PROTO(delay_space, struct space *s, intmach_t v);
CVOID__PROTO(reset_space, struct space *s, intmach_t x, intmach_t y, intmach_t v);
CVOID__PROTO(full_abstraction_space, struct space *s, intmach_t v1, intmach_t v2);
CVOID__PROTO(normalize_space, struct space *s, intmach_t i, intmach_t j, intmach_t L, intmach_t U);
CFUN__PROTO(new_diff_var_space, int, struct space *s);
CBOOL__PROTO(add_diff_const_space, struct space *s, intmach_t x, intmach_t y, intmach_t d);
CVOID__PROTO(dijkstra_space, struct space*s, intmach_t v);
CVOID__PROTO(get_shortest_path_space, struct space *s, intmach_t size, intmach_t *orig_vars);
intmach_t is_more_general_space(struct space *s1, intmach_t size, 
                          struct space *s2, intmach_t *vars);
intmach_t is_more_particular_space(struct space *s1, intmach_t size, 
                          struct space *s2, intmach_t *vars);


#endif /* _CIAO_DIFFERENCE_CONSTRAINTS_SPACE_H */
