/*
    INFO: This exercise is not timed, and you may use any available resources.
        https://extendsclass.com/postgresql-online.html# is a PostgreSQL 11.x sandbox if you need it.

    TODO: Please resolve the comments in the code below.
    TODO: Please refactor the code to make it more maintainable.
        - Add any new comments that you think would help.
*/


create or replace function sl_sql_exercise(numeric[])  # self explanotry, creates or replaces a function  which takes numeric[] as argument
   returns numeric as # what function returns as output
$func1$
   select avg(val) # selects average from arugment val 
       from (
         select val # from another query , a val  of unnest (expands an array to a set of rows)
            from unnest($1) val
            where val.val is not null # condition that obtained value is not empty, skips empty ones
            order by 1 # orders by the 1st obtained column
            limit  2 - mod(array_upper($1, 1), 2)
            offset ceil(array_upper($1, 1) / 2.0) - 1 #LIMIT and OFFSET allows  to retrieve just a portion of the rows that are generated by the rest of the query:
       ) sub;
$func1$
language 'sql' immutable;
#IMMUTABLE indicates that the function cannot modify the database and always returns the same result when given the same argument values; that is, it does not do database lookups or otherwise use information not directly present in its argument list.
drop aggregate if exists sl_sql_exercise(numeric);
create aggregate sl_sql_exercise(numeric) (
  sfunc=array_append,
  stype=numeric[],
  finalfunc=sl_sql_exercise,
  initcond='{}'
);


create or replace function sl_sql_exercise(text[]) returns text as # self explanotry, creates or replaces a function  which takes text[] as argument and returns text
$func2$
with q as (select val, index from unnest($1) with ordinality input(val, index) where val is not null) # defines q as value, which is not empty, and has a index from the array 
#When a function in the FROM clause is suffixed by WITH ORDINALITY, a bigint column is appended to the function's output column(s), which starts from 1 and increments by 1 for each row of the function's output.

select
    array_agg(val)::text as val # its a sum of the any non-array type values and converts text to value ( thus '::' sign)
    from q, (select max(index) as max_idx from q) as idx  
    where index between floor((max_idx+1)/2.0) and ceil((max_idx+1)/2.0) # from defined q it selects maximum index, with condition index is beetwen   2 rounded values : floor() (function is used to return the value after rounded up any positive or negative decimal value as smaller than the argument. The ceil() function is used for rounding a number up to the nearest integer.)
$func2$ language sql immutable; 
#IMMUTABLE indicates that the function cannot modify the database and always returns the same result when given the same argument values; that is, it does not do database lookups or otherwise use information not directly present in its argument list.



drop aggregate if exists sl_sql_exercise(text);
create aggregate sl_sql_exercise(text) (
  sfunc=array_append,
  stype=text[],
  finalfunc=sl_sql_exercise,
  initcond='{}'
);


-- TODO: Document these two functions - PEP257 may help.
comment on function sl_sql_exercise(numeric[]) is $$foo$$;
comment on function sl_sql_exercise(text[]) is $$bar$$;


-------------------------------------------------------------------------------

/* INFO: May be useful. */
-- with
--     a as (select generate_series((random()*10)::int, (random()*100)::int) as x),
--     b as (select chr(generate_series(0, (random()*100)::int%25) + 97) as x)
--
--
-- select to_char(sl_sql_exercise(a.x), 'FM99D0') from a
-- union select sl_sql_exercise(b.x)::text from b;


select
    p.proname as routine,
    pg_get_function_arguments(p.oid) as args,
    obj_description(p.oid) as docstring

    from pg_proc p
    left join pg_namespace n on p.pronamespace = n.oid
    left join pg_language l on p.prolang = l.oid
    left join pg_type t on t.oid = p.prorettype

    where p.proname = 'sl_sql_exercise'
        and obj_description(p.oid) is not null;


drop aggregate if exists sl_sql_exercise(numeric);
drop function if exists sl_sql_exercise(numeric[]);
drop aggregate if exists sl_sql_exercise(text);
drop function if exists sl_sql_exercise(text[]);
