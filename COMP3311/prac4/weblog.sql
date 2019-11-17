-- COMP3311 Prac Exercise
--
-- Written by: YOU


-- Q1: how many page accesses on March 2

... replace this line by auxiliary views (or delete it) ...

create or replace view q1(num)                                         as                                                                              
select count(acctime) from accesses                                             
where acctime  between '2005-03-02 00:00:00' and '2005-03-02 23:59:59';


-- Q2: how many times was the MessageBoard search facility used?

... replace this line by auxiliary views (or delete it) ...

create or replace view q2(nsearches)                                   as                                                                              
select count(page) from accesses                                                
where params = 'state=search' and page = 'messageboard';


-- Q3: on which Tuba lab machines were there incomplete sessions?

create or replace view q3(hostname)
as 
select distinct (h.hostname) 
from hosts h join sessions s on s.host = h.id
where s.complete = 'f' and h.hostname ilike 'tuba%';


-- Q4: min,avg,max bytes transferred in page accesses

... replace this line by auxiliary views (or delete it) ...


create or replace view Q4(min,avg,max) as
select min(nbytes),round(avg(nbytes)),max(nbytes)
from accesses;



-- Q5: number of sessions from CSE hosts

... replace this line by auxiliary views (or delete it) ...

create or replace view Q5(nhosts) as                                   
select count(h.hostname)                                                        
from hosts h join sessions s on (h.id = s.host)                                
 where h.hostname ilike '%cse.unsw.edu.au' and h.hostname is not null
 ;


-- Q6: number of sessions from non-CSE hosts

... replace this line by auxiliary views (or delete it) ...

create or replace view Q6(nhosts) as                                   
select count(h.hostname)                                                        
from hosts h join sessions s on (h.id = s.host)                                
 where h.hostname not ilike '%cse.unsw.edu.au' and h.hostname is not null
 ;

-- Q7: session id and number of accesses for the longest session?

... replace this line by auxiliary views (or delete it) ...
create or replace view sessLength as
select session,count(*) as length
from   Accesses
group by session;

create or replace view Q7(session,length) as 
select session,length
from   sessLength
where  length = (select max(length) from sessLength);


-- Q8: frequency of page accesses

... replace this line by auxiliary views (or delete it) ...

create or replace view Q8(page,freq) as
select page,count(session)
from accesses
group by page;

;


-- Q9: frequency of module accesses

... replace this line by auxiliary views (or delete it) ...

create or replace view Q9(module,freq) as
... replace this line by your SQL query ...
;


-- Q10: "sessions" which have no page accesses

... replace this line by auxiliary views (or delete it) ...

create or replace view Q10(session) as
... replace this line by your SQL query ...
;


-- Q11: hosts which are not the source of any sessions

... replace this line by auxiliary views (or delete it) ...

create or replace view Q11(unused) as
... replace this line by your SQL query ...
;
