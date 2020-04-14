struct space *space;

CFUN__PROTO(create_space, struct space*)
{
  struct space* space = (struct space*) checkalloc (sizeof(struct space));
  space->size = 1;
  space->limit = INI_SIZE_G;
  space->edges = (intmach_t**) checkalloc (INI_SIZE_G * sizeof(intmach_t*));

  intmach_t i;
  for (i = 0; i < INI_SIZE_G; i++) {
    space->edges[i] = (intmach_t*) checkalloc (INI_SIZE_G * sizeof(intmach_t));
  }
  space->edges[0][0] = 0;

  space->pi = (intmach_t*) checkalloc (INI_SIZE_G * sizeof(intmach_t));
  space->pi[0] = 0;
  return space;
}

void delete_space(struct space *space)  
{
  intmach_t i;
  for (i = 0 ; i < space->limit; i++) {
    checkdealloc((tagged_t *)space->edges[i],space->limit * sizeof(intmach_t));
  }
  checkdealloc((tagged_t *)space->edges,space->limit * sizeof(intmach_t*));
  checkdealloc((tagged_t *)space->pi, space->limit * sizeof(intmach_t));
  checkdealloc((tagged_t *)space,sizeof(struct space));
}

void print_space(struct space *space)
{
  printf("\n\tSEPARATION LOGIC SPACE:\n"); fflush(stdout);
  intmach_t i,j;
  for (i = 0; i < space->size; i++) {
    printf("\nE %ld:",(long)i);
    for (j = 0; j < space->size; j++) {
      printf("\t%ld",(long)space->edges[i][j]);
    }
  }
  printf("\nPI :");
  for (j = 0; j < space->size; j++) {
    printf("\t%ld",(long)space->pi[j]);
  }
}

CFUN__PROTO(clone_space, struct space*, struct space *s)
{
//  struct timeval t_ini, t_fin;
//  gettimeofday(&t_ini,NULL);
//  ALLOC_GLOBAL_TABLE(res,struct space*,sizeof(struct space));
  struct space *res = (struct space*) checkalloc (sizeof(struct space));
  res->size = s->size;
  res->limit = s->size * FACTOR_G;

//  ALLOC_GLOBAL_TABLE(res->edges,intmach_t**,res->limit*sizeof(intmach_t*));
  res->edges = (intmach_t**) checkalloc (res->limit*sizeof(intmach_t*));
  intmach_t i;
  for (i = 0; i < res->limit; i++) {
//      ALLOC_GLOBAL_TABLE(res->edges[i],intmach_t*,res->limit*sizeof(intmach_t));
    res->edges[i] = (intmach_t*) checkalloc (res->limit * sizeof(intmach_t));
    intmach_t j;
    if (i >= res->size) continue;
    for (j = 0; j < res->size; j++) {
      res->edges[i][j] = s->edges[i][j];
    }
  }

//  ALLOC_GLOBAL_TABLE(res->pi,intmach_t*,res->limit*sizeof(intmach_t));
  res->pi = (intmach_t*) checkalloc (res->limit*sizeof(intmach_t));
  for (i = 0; i < res->size; i++) res->pi[i] = s->pi[i];
//  gettimeofday(&t_fin,NULL);
//  trail_time = trail_time + timeval_diff(&t_fin, &t_ini);
  return res;
}

CFUN__PROTO(proy_space, struct space*,
            intmach_t size, tagged_t* vars, intmach_t* orig_attrs, intmach_t undo) {
//  struct timeval t_ini, t_fin;
//  gettimeofday(&t_ini,NULL);
  //Make an array of attr_index from vars
  intmach_t i;
  if (undo) {
    for (i = 0; i < size; i++) {
      //Update attributtes 
      MAKE_UNDO_ATTR(w, vars[i], i+1);
    }
  }

  struct space *res = (struct space*) checkalloc (sizeof(struct space));
  res->size = size + 1;
  res->limit = res->size;

  res->edges = (intmach_t**) checkalloc (res->limit * sizeof(intmach_t*));
  for (i = 0; i < res->limit; i++) {
    res->edges[i] = (intmach_t*) checkalloc (res->limit * sizeof(intmach_t));
    intmach_t ii;
    if (i == 0) ii = 0;
    else ii = orig_attrs[i-1];
    intmach_t j;
    for (j = 0; j < res->limit; j++) {
      intmach_t jj;
      if (j == 0) {
        jj = 0;
      } else {
        jj = orig_attrs[j-1];
      }
      res->edges[i][j] = space->edges[ii][jj];
    }
  }

  res->pi = (intmach_t*) checkalloc (res->limit*sizeof(intmach_t));
  res->pi[0] = space->pi[0];
  for (i = 1; i < res->size; i++) {
    res->pi[i] = space->pi[orig_attrs[i-1]];
  }

//  gettimeofday(&t_fin,NULL);
//  trail_time = trail_time + timeval_diff(&t_fin, &t_ini);
  return res;
}

void print_variable_space(struct space *s, intmach_t id) 
  {
    printf("[%ld,%ld]",-(long)s->edges[0][id],(long)s->edges[id][0]); 
  }

intmach_t isValue_space(struct space*s, intmach_t id) 
{
  return (s->edges[id][0] == -s->edges[0][id]);
}

CVOID__PROTO(delay_space, struct space *s, intmach_t v) {
  //Creating undo/1 predicate
  MAKE_UNDO_DC(Arg,v,0,s->edges[v][0],MAX);
  s->edges[v][0] = MAX;
}

CVOID__PROTO(reset_space, struct space *s, intmach_t x, intmach_t y, intmach_t v) {
  add_diff_const_space(Arg,s,y,v,s->edges[0][v]);
  add_diff_const_space(Arg,s,v,y,s->edges[v][0]);

  //Creating undo/1 predicates
  MAKE_UNDO_DC(Arg,x,v,s->edges[x][v],MAX);
  MAKE_UNDO_DC(Arg,v,x,s->edges[v][x],MAX);

  s->edges[x][v] = MAX;
  s->edges[v][x] = MAX;
}

CVOID__PROTO(full_abstraction_space, struct space *s, intmach_t v1, intmach_t v2) {
  if (s->edges[v1][v2] == 0) 
    {
      //Creating undo/1 predicate
      MAKE_UNDO_DC(Arg,v1,v2,s->edges[v1][v2],s->edges[v2][v1]);
      s->edges[v1][v2] = s->edges[v2][v1];
    }
  if (s->edges[v2][v1] == 0) 
    {
      //Creating undo/1 predicate
      MAKE_UNDO_DC(Arg,v2,v1,s->edges[v2][v1],s->edges[v1][v2]);
      s->edges[v2][v1] = s->edges[v1][v2];
    }
}

CVOID__PROTO(normalize_space, struct space *s, intmach_t i, intmach_t j, intmach_t L, intmach_t U) {
  if (s->edges[i][j] >= L) 
    {
      //Creating undo/1 predicate
      MAKE_UNDO_DC(Arg,i,j,s->edges[i][j],MAX);
      s->edges[i][j] = MAX;
    }
  else if (-s->edges[0][i] >= L) 
    {
      //Creating undo/1 predicate
      MAKE_UNDO_DC(Arg,i,j,s->edges[i][j],MAX);
      s->edges[i][j] = MAX;
    }
  else if ((-s->edges[0][j] >= U) && (i != 0))
    {
      //Creating undo/1 predicate
      MAKE_UNDO_DC(Arg,i,j,s->edges[i][j],MAX);
      s->edges[i][j] = MAX;
    }
  else if ((-s->edges[0][j] >= U) && (i == 0)) 
    {
      //Creating undo/1 predicate
      MAKE_UNDO_DC(Arg,i,j,s->edges[i][j],-U);
      s->edges[i][j] = -U;
    }
}

//Create a new different constraint variable
CFUN__PROTO(new_diff_var_space, int, struct space *s) {
  intmach_t id = s->size;
  intmach_t i;

  //Creating undo/1 predicate
  MAKE_UNDO_VAR(Arg);
  s->size++;

  if (s->size > s->limit) 
    {
      intmach_t old_limit = s->limit;
      s->limit = FACTOR_G * s->limit;
      s->edges = (intmach_t**) checkrealloc((tagged_t *)s->edges, 
                                      old_limit * sizeof(intmach_t*), 
                                      s->limit * sizeof(intmach_t*));
      for (i = 0; i < id; i++) {
        s->edges[i] = (intmach_t*) checkrealloc((tagged_t *)s->edges[i], 
                                          old_limit * sizeof(intmach_t),
                                          s->limit * sizeof(intmach_t));
      }
      for (i = id; i < s->limit; i++) {
        s->edges[i] = (intmach_t*) checkalloc(s->limit * sizeof(intmach_t));
      }
    
      s->pi = (intmach_t*) checkrealloc((tagged_t*)s->pi, old_limit * sizeof(intmach_t),
                                   s->limit * sizeof(intmach_t));
    }

  for (i = 0; i < id; i++) s->edges[i][id] = MAX;
  for (i = 0; i < id; i++) s->edges[id][i] = MAX;
  s->edges[id][id] = 0;
  s->pi[id] = 0;
  
  return id;
}

//Adds a new different constraint 
CBOOL__PROTO(add_diff_const_space, struct space *s, intmach_t x, intmach_t y, intmach_t d) {
  if ((x >= s->size) || (x < 0)) 
    {
      printf("\nDiff Const Var out of range\n");
      return FALSE;
    }

  if ((y >= s->size) || (y < 0)) 
    {
      printf("\nDiff Const Var out of range\n");
      return FALSE;
    }

  //It is subsumed.
  if (d >= s->edges[x][y]) return TRUE;
    
  if (d == -MAX) return FALSE;

  //Creating undo/1 predicate
  MAKE_UNDO_DC(Arg,x,y,s->edges[x][y],d);
  s->edges[x][y] = d;
  if ((s->pi[x] + d - s->pi[y]) >= 0) return TRUE;

  //Initialazing structures
  intmach_t *gamma = (intmach_t*) checkalloc (s->size * (sizeof(intmach_t)));
  intmach_t *newpi = (intmach_t*) checkalloc (s->limit * (sizeof(intmach_t)));
  intmach_t i;
  for (i = 0; i < s->size; i++) {
    gamma[i] = 0;
    newpi[i] = s->pi[i];
  }
  gamma[y] = s->pi[x] + d - s->pi[y];

  //loop
  intmach_t min = gamma[y];
  intmach_t current = y;
  while ((min < 0) && (gamma[x] == 0))
    {
      newpi[current] = s->pi[current] + gamma[current];
      gamma[current] = 0;
        
      intmach_t e;
      for (e = 0; e < s->size; e++) {
        if ((e != current) && (s->edges[current][e] != MAX) && 
            (newpi[e] == s->pi[e])) {
          intmach_t tmp = newpi[current] + s->edges[current][e] - newpi[e];
          if (tmp < gamma[e]) gamma[e] = tmp;
        }
      }
      //argmin
      min = 0;
      for (e = 0; e < s->size; e++) {
        if (gamma[e] < min) {
          min = gamma[e];
          current = e;
        }
      }
    }

    intmach_t res = gamma[x];

    //Freeing structures
    checkdealloc((tagged_t *)gamma, s->size * (sizeof(intmach_t)));
    //Creating undo/1 predicate
    MAKE_UNDO_PI(Arg,s->pi,newpi);

    checkdealloc((tagged_t *)s->pi, s->limit * (sizeof(intmach_t)));
    s->pi = newpi;

    return (res >= 0);
  }

//Computes shortest paths
CVOID__PROTO(dijkstra_space, struct space*s, intmach_t v) {
  intmach_t *dist = (intmach_t*) checkalloc (s->size * sizeof(intmach_t));
  intmach_t *visit = (intmach_t*) checkalloc (s->size * sizeof(intmach_t));
  intmach_t i;
  for (i = 0; i < s->size; i++) {
    visit[i] = 0;
    dist[i] = MAX;
  }
  dist[v] = 0;
  visit[v] = 1;
  
  intmach_t end = FALSE;
  intmach_t u = v;
  
  while (!end) {
    intmach_t e;
    for (e = 0; e < s->size; e++) {
      if (s->edges[u][e] != MAX) {
        intmach_t tmp = dist[u] + s->edges[u][e] + s->pi[u] - s->pi[e];
        if (tmp < dist[e]) {
          dist[e] = tmp;
          //Better implications in the graph
          // edges[v][e] = tmp + pi[e] - pi[v]; 
          add_diff_const_space(Arg, s, v, e, tmp + s->pi[e] - s->pi[v]); 
        }
      }
    }
      
    intmach_t min = MAX;
    intmach_t i;
    for (i = 0; i < s->size; i++) {
      if (!visit[i] && (dist[i] < min)) {
        u = i;
        min = dist[i];
      }
    }
      
    visit[u] = 1;
    if (min == MAX) end = TRUE;
  }        

  checkdealloc((tagged_t *)dist, s->size * sizeof(intmach_t));
  checkdealloc((tagged_t *)visit, s->size * sizeof(intmach_t));
}

CVOID__PROTO(get_shortest_path_space, struct space *s, intmach_t size, intmach_t *orig_vars) {
  //Executing Dijkstra
  dijkstra_space(Arg,s,0);
  intmach_t i;
  for (i = 0; i < size; i++) {
    dijkstra_space(Arg,s,orig_vars[i]);
  }
}

intmach_t is_more_general_space(struct space *s1, intmach_t size, 
                          struct space *s2, intmach_t *vars) 
{
  //Checking for entailment
  intmach_t i, j;
  for (j = 0; j < size; j++) {
    if (s1->edges[0][j+1] < s2->edges[0][vars[j]]) 
      return FALSE;
  }

  for (i = 0; i < size; i++) {
    if (s1->edges[i+1][0] < s2->edges[vars[i]][0]) 
      return FALSE;
  }
    
  for (i = 0; i < size; i++) {
    for (j = 0; j < size; j++) {
      if (s1->edges[i+1][j+1] < s2->edges[vars[i]][vars[j]]) 
        return FALSE;
    }
  }
  
  return TRUE;
}
intmach_t is_more_particular_space(struct space *s1, intmach_t size, 
                          struct space *s2, intmach_t *vars) 
{
  //Checking for entailment in the other direction
  intmach_t i, j;
  for (j = 0; j < size; j++) {
    if (s1->edges[0][j+1] > s2->edges[0][vars[j]]) 
      return FALSE;
  }

  for (i = 0; i < size; i++) {
    if (s1->edges[i+1][0] > s2->edges[vars[i]][0]) 
      return FALSE;
  }
    
  for (i = 0; i < size; i++) {
    for (j = 0; j < size; j++) {
      if (s1->edges[i+1][j+1] > s2->edges[vars[i]][vars[j]]) 
        return FALSE;
    }
  }
  
  return TRUE;
}


CVOID__PROTO(change_space, struct space *newspace)
{
  MAKE_UNDO_CHANGE_SPACE(Arg, (newspace));      
  space = (newspace);
}
 
CFUN__PROTO(current_space, struct space*)
{
  return space;
}


