-- .read Lessons/1.21/1.21_DDL_DML_Pt1.sql

use data_jobs;

create database if not exists jobs_mart;

show databases;

-- drop database if exists jobs_mart;

select *
from information_schema.schemata;

use jobs_mart;

create schema if not exists staging;

-- drop schema staging;


create table if not exists staging.preferred_roles (
    role_id integer primary key,
    role_name varchar 
);

select 
    * 
from 
    information_schema.tables 
where 
    table_catalog = 'jobs_mart';

delete from staging.preferred_roles;

insert into staging.preferred_roles(role_id, role_name)
values
(1, 'Data Engineer'),
(2, 'Senior Data Engineer'),
(3, 'Software Engineer');

select *
from staging.preferred_roles;

alter table staging.preferred_roles
add column if not exists preferred_role boolean;


update staging.preferred_roles
set preferred_role = true
where role_id = 1 or role_id = 2;


update staging.preferred_roles
set preferred_role = false
where role_id = 3;

drop table if exists staging.priority_roles;

alter table staging.preferred_roles
rename to priority_roles;

select *
from staging.priority_roles;

alter table staging.priority_roles
rename column preferred_role to priority_levels;


alter table staging.priority_roles
alter column priority_levels type integer;

update staging.priority_roles
set priority_levels = 3
where role_id =3;

select *
from staging.priority_roles;