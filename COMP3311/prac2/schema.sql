-- COMP3311 Prac 03 Exercise
-- Schema for simple company database

create domain key as 
    
    char(11)  check (value ~ '[0-9]{3}-[0-9]{3}-[0-9]{3}');

create domain special as
    char(3) check (value ~ '[0-9]{3}');
    
create table Employees (
	tfn         key UNIQUE ,
	givenName   varchar(30) NOT NULL,
	familyName  varchar(30) NULL,
	hoursPweek  float  constraint invalid_hour check(hoursPweek > 0 AND 168 >= hoursPweek),
	PRIMARY KEY (tfn)
);

create table Departments (
	id          special UNIQUE ,
	name        varchar(100),
	manager     char(11) UNIQUE,
    primary key (id)    
);

create table DeptMissions (
	department  char(3),
	keyword     varchar(20) NOT NULL
);

create table WorksFor (
	employee    char(11),
	department  char(3),
	percentage  float check(percentage > 0 AND 100 >= percentage),
	primary key (employee ,department)
);
alter table WorksFor add foreign key (employee) references Employees(tfn) defferable;
alter table WorksFor add foreign key (department) references Departments(id) defferable;
alter table Departments add foreign key (manager) references Employees(tfn) defferable;
alter table DeptMissions add foreign key (department) references Departments(id) defferable;

