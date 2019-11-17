-- COMP3311 19T3 Assignment 3
-- Helper views and functions (if needed)

-- FOR Q1
----get number of student enrolled
create or replace view nEnrolledStudents(id,n)
as
select course_id,count(person_id)
from Course_Enrolments
group by course_id
;

create or replace view q1(course,n,total)
as
select s.code,n.n ,c.quota
from courses c inner join subjects s on (c.subject_id = s.id)
inner join terms t on (c.term_id = t.id)
inner join nEnrolledStudents n on (n.id = c.id)
where t.name = '19T3' and c.quota > 50 and n.n > c.quota
order by s.code asc
;

---FOR Q2
-------get course where n represent sharing the same course code number 
---get the number of course code and its corresponding course
create or replace view codenum(id,course,num)
as
select id,code ,substring(code,5,8)
from subjects 
;

create or replace view q2(course,total,val)
as
select c.num,count(c.num),string_agg(substring(s.code,1,4),' ' order by s.code asc)
from subjects s join codenum c on (c.id = s.id)
where s.code ilike '%'||c.num
group by c.num
;

---FOR Q3
------GET COURSE AND ITS CORRESPONDING BUILDING
create or replace view q3(course,building)
as
select distinct s.code,b.name
from subjects s join courses c on (c.subject_id = s.id)
join classes a on (c.id = a.course_id)
join meetings m on (m.class_id = a.id)
join rooms r on (m.room_id = r.id)
join buildings b on (b.id = r.within)
join terms t on (t.id = c.term_id)
where t.name = '19T2'
;

---FOR Q4
-----GET TERMS AND ITS CORRESPONDING COURSE
create or replace view q4(term,course,total)
as
select t.name,s.code,count(n.person_id)
from subjects s join courses c on (c.subject_id = s.id)
join terms t on (c.term_id =  t.id)
inner join course_enrolments n on (n.course_id = c.id) 
inner join People p on (p.id = n.person_id) 
group by t.name,s.code
;

---FOR Q5
-------get ,class type
create or replace view q5(classtype,tag,quota,total,course)
as
select ct.name,a.tag,a.quota,count(e.person_id),s.code
from subjects s join courses c on (c.subject_id = s.id)
join terms t on (c.term_id = t.id)
join classes a on (a.course_id = c.id)
join classtypes ct on (a.type_id = ct.id)
join class_enrolments e on (e.class_id = a.id)
where t.name like '19T3'
group by ct.name,a.tag,a.quota,s.code
;

---FOR Q7;
create or replace view q7(id,start_time,end_time,term,day,bin)
as
select r.id,m.start_time,m.end_time,t.name,m.day,substring(m.weeks_binary,1,10)
from terms t join courses c on (c.term_id = t.id)
join classes a on (a.course_id = c.id)
join meetings m on (m.class_id = a.id)
join rooms r on (m.room_id = r.id)where r.code ilike 'K-%'
;




--total number of room
create or replace view total_room(num)
as
select id 
from rooms 
where code ilike 'K-%';
;





















create or replace view diff_bin(name,start_time,end_time,term,day,bin)
as
select a.name,a.start_time,a.end_time,a.term,a.day,a.bin | b.bin
from q7  a join q7 b on (a.id = b.id and a.start_time = b.start_time and a.end_time=b.end_time and a.day = b.day and a.term = b.term)
;

create type meeting as (name text,start_time daytime,end_time daytime,term text,day weekday,bin bit(10));
create or replace function
    places(_n text,_t text) returns setof meeting
as $$

declare
    _tup1 meeting;
    _tup2 meeting;
begin

    for _tup1 in (select * from diff_bin where name ilike _n || '%' and _t = term order by day asc) loop
        for _tup2 in (select * from diff_bin where name ilike _n || '%' and _t = term order by day asc) loop
            if _tup1 != _tup2 then
                if _tup1.day = _tup2.day then
                    if _tup1.bin = _tup2.bin then
                        if _tup1.start_time > _tup2.start_time then
                            _tup1.start_time := _tup2.start_time;
                        end if;

                        if _tup1.end_time < _tup2.end_time then
                            _tup1.end_time := _tup2.end_time;
                        end if;
                        
                     end if;
                end if;
            end if;        
        end loop;    
        return next _tup1;
    
    end loop;
end
$$ language plpgsql;    




