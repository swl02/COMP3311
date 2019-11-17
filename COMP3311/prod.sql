create or replace function
    mult(state integer,x integer) returns integer
as $$
begin
    return state * x;
end;
$$ language plpgsql;

drop aggregate if exists prod(integer);

create aggregate prod(integer) (
    stype = integer,--the accumulator type
    initcond = 1,
    sfunc = mult
)

create or replace function
    stick(so far text,Newstr text) returns text
as $$
begin
    if (sofar = '') then
        return newstr;
    else
        return soFar||','||NEWSTR;
    END IF  ;
    
    
end;
$$ language plpgsql;

create aggregate if exist concat(text);

create aggregate concat(text) (
    stype = text,
    sfunc = stick
    initcond = ''
);

