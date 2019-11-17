-- COMP3311 19T3 Assignment 2
-- Written by <<insert your name here>>

-- Q1 Which movies are more than 6 hours long? 

create or replace view Q1(title)
as
select main_title 
from titles 
where runtime > 360 and format = 'movie' 
;


-- Q2 What different formats are there in Titles, and how many of each?

create or replace view Q2(format, ntitles)
as
select format,count (format) 
from titles 
group by format
;


-- Q3 What are the top 10 movies that received more than 1000 votes?

create or replace view Q3(title, rating, nvotes)
as
select main_title,rating,nvotes
from titles
where nvotes > 1000 and format = 'movie'
order by rating desc ,main_title asc
limit 10
;


-- Q4 What are the top-rating TV series and how many episodes did each have?

-- EXTRA VIEW
-----------------------------------------------------
create or replace view avg_rating_tv(title,rating,id)
as
select distinct main_title,avg(rating),id
from titles
where (format = 'tvSeries' or format = 'tvMiniSeries') and rating is not NULL
group by main_title,id
order by avg(rating) desc
;
-------------------------------------------------------
-------------------------------------------------------
create or replace view max_avg_rating_tv(rating)
as
select max(rating) 
from avg_rating_tv
;
-------------------------------------------------------


create or replace view Q4(title, nepisodes)
as
select distinct t.title as title,count(e.episode) as nepisodes
from avg_rating_tv  t join episodes e on (t.id = e.parent_id),
max_avg_rating_tv m
where m.rating = t.rating
group by t.title
;


-- Q5 Which movie was released in the most languages?
-----need to create view with each movie having each number of language
create or replace view movie_nl(title,nlanguages)                          
as  
select t.main_title , count(distinct a.language)                               
from Aliases a join titles t on (a.title_id = t.id)
where a.language is not null and t.format = 'movie'
group by t.main_title
order by t.main_title;



create or replace view Q5(title,nlanguages)
as
select title,nlanguages      
from movie_nl
where nlanguages = (select max(nlanguages) from movie_nl)
;


-- Q6 Which actor has the highest average rating in movies that they're known for?
--create a view to count how many movie did an actor act(known for )
create or replace view actor_in_movie(name,nmovie,rating,id)
as
select n.name,count(t.main_title),avg(t.rating),n.id
from names n 
inner join known_for k on k.name_id = n.id
inner join titles t on t.id = k.title_id
where t.format = 'movie' and t.rating is not null
group by n.name,n.id;


--create a view with average rating in movies for actor who act at least 2 times
create or replace view no_one_hit(name,nmovie,id,rating)
as
select name,nmovie,id,rating
from actor_in_movie 
where nmovie > 1;

--create view where someone has worked as actor;
create or replace view work_as_actor(id)
as
select name_id
from worked_as
where work_role = 'actor';  

create or replace view Q6(name)
as
select n.name
from no_one_hit n join work_as_actor w on n.id = w.id
where n.rating = (select max(n.rating) from no_one_hit n join work_as_actor w on n.id = w.id)
;

-- Q7 For each movie with more than 3 genres, show the movie title and a comma-separated list of the genres
---view with number of genre
create or replace view ngenre(id,ngenres)
as
select  distinct title_id,count(genre)
from title_genres
group by title_id
;

--view for movie with its genres
create or replace view movie_genre(title,genres,id)
as
select t.main_title , string_agg(g.genre,',' order by g.genre asc),t.id 
from titles t 
join Title_genres g on t.id = g.title_id
where g.genre is not null and t.format = 'movie' 
group by t.main_title,t.id
;

create or replace view Q7(title,genres)
as
select m.title,m.genres
from movie_genre m join ngenre n on (n.id = m.id)
where n.ngenres > 3;
;
-- Q8 Get the names of all people who had both actor and crew roles on the same movie

---view where ppl with both crew and actor roles in the same title 
create or replace view inter_title(id,title_id)
as
((select name_id,title_id from actor_roles)
intersect
(select name_id,title_id from crew_roles))
;
--view where ppl with both crew and actor roles in the same movie
create or replace view inter_movie(id)
as
select i.id 
from titles t,inter_title i
where t.id = i.title_id and t.format = 'movie'
;

create or replace view Q8(name)
as
select distinct n.name 
from names n join inter_movie i on i.id = n.id
;

-- Q9 Who was the youngest person to have an acting role in a movie, and how old were they when the movie started?
--view for movie id and start_year;
create or replace view movie(id,start_year)
as
select id,start_year
from titles  
where format = 'movie';

---view for actor id and its birth_year;
create or replace view actor_age(name,age)
as
select n.name,m.start_year-n.birth_year
from names n
inner join actor_roles a on a.name_id = n.id
inner join  movie m on a.title_id = m.id
;

create or replace view Q9(name,age)
as
select name,age 
from actor_age
where age = (select min(age) from actor_age)
;

-- Q10 Write a PLpgSQL function that, given part of a title, shows the full title and the total size of the cast and crew
--view to count crew




--union actor_and_crew and principals
--to eliminate duplicate name with many role
create or replace view ppl_size(title_id,name_id)
as
(select title_id,name_id from Actor_roles )
union 
(select title_id,name_id from crew_roles )
union
(select title_id,name_id from principals)
;

---there may be case where title main are the same 
---to prevent so we count by id first
create or replace view total_size(title_id,nsize)
as
select title_id,count(name_id)
from ppl_size
group by title_id;


create type str as (name text,n  text);
create or replace function
	Q10(partial_title text) returns setof text
as $$
declare 
_t str;
info text;
begin

    for _t in 
        (select t.main_title,p.nsize
        from titles t join total_size p on (t.id = p.title_id) 
        where t.main_title ilike '%'||partial_title||'%' 
        )
    
    loop

    
        info := _t.name||' has '||_t.n||' cast and crew';
        return next info;
    end loop;

    if not found then
        info := 'No matching titles';
        return next info;
    end if;    
        
end;
$$ language plpgsql;

