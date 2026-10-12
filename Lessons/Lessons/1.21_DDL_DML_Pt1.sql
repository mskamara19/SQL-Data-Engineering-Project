drop database if exists jobs_mart;

create database if not exists jobs_mart;

use data_jobs;

show databases;

select *
from information_schema.schemata;

use jobs_mart;

create schema if not exists staging;

--drop schema staging;

create table staging.preferred_roles (
    role_id integer primary key,
    role_name varchar
);



select *
from information_schema.tables = 'jobs_mart';

insert into staging.preferred_roles(role_id, role_name)
values
(3,'Software Engineer');

select * from staging.preferred_roles;

alter table staging.preferred_roles
add column preferred_role boolean;

update staging.preferred_roles
set preferred_role = false
where role_id = 3;
