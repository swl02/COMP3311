

create or replace view q1(num)                                         as                                                                              
select count(acctime) from accesses                                             
where acctime  between '2005-03-02 00:00:00' and '2005-03-02 23:59:59';


create or replace view q2(nsearches)                                   as                                                                              
select count(page) from accesses                                                
where params = 'state=search' and page = 'messageboard';


create or replace view q3(hostname)
as 
select distinct (h.hostname) 
from hosts h join sessions s on s.host = h.id
where s.complete = 'f' and h.hostname ilike 'tuba%';
