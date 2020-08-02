// difference_constraints_tab.c

#include <ciao/ciao_prolog.h>
#include <ciao/attributes.h>
#include <ciao/termdefs.h>
#include "ciao/support_macros.h"

#include "engine.h"
#include "terms.h"
#include "difference_constraints.h"
#include "space.h"
// #include "../difference_constraints.h"



#ifndef _CIAO_DIFFERENCE_CONSTRAINTS_TAB_C
#define _CIAO_DIFFERENCE_CONSTRAINTS_TAB_C

#if defined(TABLING)


#define DiffIntOfTerm(X) TermToPointer(((tagged_t)X))
#define DiffMkIntTerm(X) PointerToTerm(((tagged_t)X))


CBOOL__PROTO(current_store_c)
{
#if defined(DEBUG_ALL)
  printf("\nSTART/END current_store_c\n");
#endif

  return Unify(X(0), DiffMkIntTerm((intmach_t)current_space(Arg)));
}

CBOOL__PROTO(project_gen_store_c)
{
#if defined(DEBUG_ALL)
  printf("\nSTART project_gen_store_c\n");
#endif

  struct space *project;

  intmach_t size = IntOfTerm(X(1));

  if (size == 0)
    {
      project = create_space(Arg);
    }
  else
    {
      tagged_t car, list;
      intmach_t i;
      tagged_t vars[size];
      
      DEREF(list, X(0));
      for (i = 0; i < size; i++)
        {      
          DerefCar(car, list);
          DerefCdr(list, list);
          vars[i] = car;
        }
      
      intmach_t *attrs = (intmach_t*)DiffIntOfTerm(X(2));
      project = proy_space(Arg, size, vars, attrs, 1);
      
#if defined(DEBUG_ALL)
      printf("\nPROJEC\n");
      print_space(project);
      printf("\nORIG\n");
      print_space(current_space(Arg));
#endif
    }

  change_space(Arg, clone_space(Arg, project));

#if defined(DEBUG_ALL)
  printf("\nEND project_gen_store_c\n");
#endif

  return Unify(X(3), DiffMkIntTerm((intmach_t)project));
}


CBOOL__PROTO(project_gen_store_A_c)
{
#if defined(DEBUG_ALL)
  printf("\nSTART project_gen_store_A_c\n");
#endif

  struct space *project;
  DEREF(X(1),X(1));
  intmach_t size = IntOfTerm(X(1));

  if (size == 0)
    {
      project = create_space(Arg);
    }
  else
    {
      tagged_t car, list;
      intmach_t i;
      tagged_t vars[size];
      
      /* DEREF(list, X(0)); */
      /* for (i = 0; i < size; i++) */
      /*        {       */
      /*          DerefCar(car, list); */
      /*          DerefCdr(list, list); */
      /*          vars[i] = car; */
      /*        } */

      DEREF(X(2),X(2));
      intmach_t *attrs = (intmach_t*)DiffIntOfTerm(X(2));
      project = proy_space(Arg, size, vars, attrs, 0);  ///// NOTE - it does not update vars
    }

  //  change_space(Arg, clone_space(Arg, project));   NOTE - it does not change the store

#if defined(DEBUG_ALL)
  printf("\nEND project_gen_store_A_c\n");
#endif

  return Unify(X(3), DiffMkIntTerm(project));
}

CBOOL__PROTO(project_gen_store_B_c)
{
#if defined(DEBUG_ALL)
  printf("\nSTART project_gen_store_B_c\n");
#endif

  intmach_t size = IntOfTerm(X(1));
  DEREF(X(3),X(3));
  struct space *project = (struct space*)DiffIntOfTerm(X(3));
      
   if (size == 0)
    { }
  else
    {
      tagged_t car, list;
      intmach_t i;
      tagged_t vars[size];
      
      DEREF(list, X(0));
      for (i = 0; i < size; i++)
        {      
          DerefCar(car, list);
          DerefCdr(list, list);
          //Update attributtes
          MAKE_UNDO_ATTR(w, car, i+1); 
        }
    }

    change_space(Arg, clone_space(Arg, project));  

#if defined(DEBUG_ALL)
  printf("\nEND project_gen_store_B_c\n");
#endif

  return TRUE;
}

CBOOL__PROTO(project_answer_store_c)
{
  //  printf("START answer_store_c\n");


  tagged_t car, list;
  intmach_t i, size, * attrs;
  struct space *answer;

  size = IntOfTerm(X(1));
  tagged_t vars[size];
  if (size == 0)
    attrs = NULL;
  else
    {
      DEREF(list, X(0));
      for (i = 0; i < size; i++)
        {      
          DerefCar(car, list);
          DerefCdr(list, list);
          vars[i] = car;
        }
      attrs = (intmach_t*)DiffIntOfTerm(X(2));
    }

  answer = proy_space(Arg, size, vars, attrs, 0);
  
#if defined(DEBUG_ALL)
  print_space(answer); 
#endif

  return Unify(X(3), DiffMkIntTerm((intmach_t)answer));
}


CBOOL__PROTO(entail_c)
{
  //  printf("START entail_c\n");


  intmach_t size = IntOfTerm(X(0));
  intmach_t *vars = (intmach_t*)DiffIntOfTerm(X(1));

  struct space *space1 = (struct space *)DiffIntOfTerm(X(2));
  struct space *space2 = current_space(Arg);

  return is_more_general_space(space1, size, space2, vars);
  
}

CBOOL__PROTO(check_entail_c)
{
  //  printf("START check_entail_c\n");


  intmach_t size = IntOfTerm(X(0));
  intmach_t *vars = (intmach_t*)DiffIntOfTerm(X(1));
  intmach_t result = 0;

  struct space *space1 = (struct space *)DiffIntOfTerm(X(2));
  struct space *space2 = current_space(Arg);

  if (is_more_general_space(space1, size, space2, vars))
    result = 1;
  else if (is_more_particular_space(space1, size, space2, vars))
    result = -1;
  else return FALSE;

  return Unify(X(3), MkIntTerm((intmach_t)result));
  
}

CBOOL__PROTO(check_entail_A_c)
{
  //  printf("START check_entail_c\n");


  intmach_t size = IntOfTerm(X(0));
  intmach_t *vars = (intmach_t*)DiffIntOfTerm(X(1));
  intmach_t result = 0;

  struct space *space1 = (struct space *)DiffIntOfTerm(X(2));
  struct space *space2 = current_space(Arg);

  if (is_more_general_space(space1, size, space2, vars))
    result = 1;
  else return FALSE;

  return Unify(X(3), MkIntTerm((intmach_t)result));
  
}

CBOOL__PROTO(check_entail_B_c)
{
  //  printf("START check_entail_c\n");


  intmach_t size = IntOfTerm(X(0));
  intmach_t *vars = (intmach_t*)DiffIntOfTerm(X(1));
  intmach_t result = 0;

  struct space *space1 = (struct space *)DiffIntOfTerm(X(2));
  struct space *space2 = current_space(Arg);

 if (is_more_particular_space(space1, size, space2, vars))
    result = -1;
  else return FALSE;

  return Unify(X(3), MkIntTerm((intmach_t)result));
  
}


CBOOL__PROTO(project_domain_c)
{
  //  printf("START project_domain_c\n");

  tagged_t list, car;
  intmach_t size, i;
  intmach_t * res;
  
  DEREF(list, X(0));
  for (size = 0; list != atom_nil; size++)
    {
      DerefCdr(list, list);
    }

  if (size == 0) 
    {
      res = (intmach_t*)DiffIntOfTerm(atom_nil);
    }
  else
    {
      DEREF(list, X(0));
      res = (intmach_t*) checkalloc (size * sizeof(intmach_t)); // Create memory for constraint store to free when abolish_constraint_tables/0
      for (i = 0; i < size; i++)
        {
          DerefCar(car, list);
          DerefCdr(list, list);
          tagged_t attr = fu1_get_attribute(NULL,car);
          DEREF(attr,ArgOfTerm(1, attr));
          res[i] = IntOfTerm(attr);
        }
      
      get_shortest_path_space(Arg, space, size, res);

    }
  
  return Unify(X(1), MkIntTerm(size)) &&
    Unify(X(2), DiffMkIntTerm(res));
}



CBOOL__PROTO(reinstall_store_c)
{
  struct space * orig = (struct space*)DiffIntOfTerm(X(3));

  tagged_t list, car, cdr;
  intmach_t i;
  
#if defined(DEBUG_ALL)
  printf("\nPROY STATE\n"); 
  print_space(current_space(Arg)); 
#endif 
  change_space(Arg, orig);
#if defined(DEBUG_ALL)
  printf("\nORIG STATE\n");
  print_space(current_space(Arg));
#endif
  intmach_t size = IntOfTerm(X(1));
  if (size == 0)
    {}
  else
    {
      intmach_t *res = (intmach_t*)DiffIntOfTerm(X(2));
      
      DEREF(list, X(0));
      for (i = 0; i < size; i++)
        {
          DerefCar(car, list);
          DerefCdr(list, list);
          MAKE_UNDO_ATTR(w, car, res[i]);
        }
    }

  return TRUE;

}

CBOOL__PROTO(apply_answer_c)
{
  //  printf("START apply_answer_c\n");

  tagged_t list;
  DEREF(list, X(0));
  intmach_t size = IntOfTerm(X(1));
  // Instead of fu1_get_attribute again maybe make sense use Attrs (X(2))
  struct space * answ_space = (struct space*)DiffIntOfTerm(X(3));

  tagged_t car, cdr;
  intmach_t i;
  intmach_t *attr_values = (intmach_t*) checkalloc ((size+1) * sizeof(intmach_t));

#if defined(DEBUG_ALL)
  printf("\nsize %d \n",size);
#endif
  
  attr_values[0] = 0;
  DEREF(list, X(0));
  for (i = 0; i < size; i++)
    {
      DerefCar(car,list);
      DerefCdr(list,list);
      if (!TagIsCVA(car))
        {
#if defined(DEBUG_ALL)
          printf("\nCreating aux CVA %x\n",car);
#endif
          tagged_t term = car;
          DEREF(term,term);
          intmach_t id = new_diff_var_space(Arg,current_space(Arg));
          args[0] = MkIntTerm(id);
          args[1] = MkIntTerm(term);
          bu2_attach_attribute(Arg,term, MkApplTerm(functor_dbm_id,2,args));
          attr_values[i+1] = id;
#if defined(DEBUG_ALL)
          printf("\nEND Creating aux CVA\n");
#endif
        }
      else
        {
          // Instead of fu1_get_attribute again maybe make sense use Attrs (X(2))
          tagged_t attr = fu1_get_attribute(NULL,car);
          DEREF(attr,ArgOfTerm(1, attr));
          attr_values[i+1] = IntOfTerm(attr);
        }
#if defined(DEBUG_ALL)
      tagged_t term = fu1_get_attribute(NULL,car);
      DEREF(term,ArgOfTerm(1, term));
      printf("\nATTR ANSWER %d = %i(%d)\n",i,IntOfTerm(term),attr_values[i+1]);
#endif      
    }

#if defined(DEBUG_ALL)
  printf("\nInserting answer in\n");
  print_space(current_space(Arg));
  printf("\nTHE ANSWER %p\n",answ_space); fflush(stdout);
  print_space(answ_space); fflush(stdout);
#endif
  intmach_t j;
  for (i = 0; i <= size; i++)
    {
      for (j = 0; j <= size; j++)
        {
#if defined(DEBUG_ALL)
          printf("\nAnswer [%d,%d] = %d\n",attr_values[i],attr_values[j],
                 ((struct space*)answ_space)->edges[i][j]);
#endif
          if (!add_diff_const_space(Arg,current_space(Arg),attr_values[i],attr_values[j],
                                    ((struct space*)answ_space)->edges[i][j]))
            break;
        }
    }

  checkdealloc((tagged_t *)attr_values, (size + 1) * sizeof(intmach_t));

#if defined(DEBUG_ALL)
  printf("\nconsume_attr_answer END\n"); fflush(stdout);
#endif

  intmach_t value = ((i-1) == size) && ((j-1) == size);
  return value;

}

#endif

#endif /* _CIAO_DIFFERENCE_CONSTRAINTS_TAB_C */
