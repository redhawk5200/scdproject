--
use myfirstdb
switch to db myfirstdb
db.myfirstdb.insert({"name":"aa"})
db.dropDatabase()

db.createCollection("myCollection")
db.myCollection.drop()
db.collection_name.insert([{},{}])

db.collection.find().pretty()

--
create table reporter(
    
    ddl_date date,
    user_name varchar(50),
    obj_type varchar(50),
    obj_name varchar(50),
    obj_event varchar(50)
    
);
create or replace trigger audit_hr
after ddl on schema
begin
insert into repoter values(
sysdate,
sys_context('USERENV','CURRENT_USER'),
ora_dict_obj_type,
ora_dict_obj_name,
ora_sysevent);
end;
create or replace trigger  DDLTrigger  AFTER Create ON DATABASE
begin
INSERT INTO employees VALUES (800,'','','','',NULL,NULL,10000,NULL,NULL,90);
end;

--
select department_id, count(EMPLOYEE_ID), avg(salary) from employees group by department_id;

select job_id, count(employee_id) from employees group by job_id;

select first_name, hire_date from employees where hire_date > (select hire_date from employees where employee_id = 110);

select department_id from employees group by department_id having max(salary) >= 15000;

select employee_id, first_name || ' ' || last_name, job_id, salary from employees where salary < ANY (select salary from employees where job_id = 'IT_PROG');

select * from employees where employee_id != ALL (select employee_id from job_history);

select manager_id, min(salary) from employees where salary > ALL (select salary from employees where salary <= 2000) and manager_id is not null group by manager_id order by min(salary);

insert into employees_BKP select * from employees where employee_id IN (select employee_id from job_history where start_date = '13-JAN-01');

update employees set salary = salary + (salary*0.2) where employee_id  IN (select employee_id from employees where salary < 6000);

delete from emp_bkp where job_id = 'FI_MGR';

select department_id, count(employee_id) from employees where salary > 20000 group by department_id;

select d.department_name, e.first_name || '' || e.last_name as Fullname, l.city
from employees e inner join departments d 
on e.manager_id = d.manager_id
inner join locations l
on d.location_id=l.location_id;

select to_date(sysdate,'DD-MM-YYYY')-to_date(e.hire_date,'DD-MM-YYYY') as noofdaysworked, e.employee_id, e.job_id
from employees e inner join departments d
on e.department_id=d.department_id
where d.department_id=80;

select e.first_name || '' || e.last_name as Fullname, e.job_id, j.start_date, j.end_date
from employees e right outer join job_history j 
on e.employee_id=j.employee_id
where e.commission_pct is null;

select d.department_name, d.department_id, count(*) 
from employees e inner join departments d 
on e.department_id=d.department_id
group by d.DEPARTMENT_ID, d.DEPARTMENT_NAME;

select e.first_name || '' || e.last_name as Fullname, e.salary 
from employees e inner join departments d
on e.department_id=d.department_id
inner join locations l
on l.location_id=d.location_id
where l.city='London';

select e.first_name || '' || e.last_name as Fullname
from employees e inner join job_history j
on e.employee_id=j.employee_id
where j.employee_id is null;

select c.country_name
from countries c inner join regions r
on c.region_id=r.region_id
where r.region_name='Asia';

select e.first_name || '' || e.last_name as Fullname, j.job_title as Jobname, d.department_name, e.salary
from employees e inner join departments d
on e.department_id=d.department_id
inner join jobs j
on j.job_id=e.job_id
order by d.DEPARTMENT_NAME asc;

select d.department_name
from employees e inner join departments d 
on e.department_id=d.department_id
group by d.DEPARTMENT_NAME
having (count(*)>=2);

select *
from employees e inner join jobs j
on j.job_id=e.job_id
where e.salary<j.min_salary;

select e.first_name || '' || e.last_name as Fullname, j.job_title as jobname, e.salary*12, d.department_id, d.department_name, l.city
from employees e inner join jobs j 
on e.job_id=j.job_id
inner join departments d
on e.department_id=d.department_id
inner join locations l
on l.location_id=d.location_id
where e.salary*12 > 60000 and j.job_title <> 'Analyst';

select *
from employees e1 join employees e2
on e1.employee_id=e2.manager_id;


select  d.department_id,d.department_name
from departments d left outer join employees e
on d.department_id=e.department_id
group by d.department_id,d.department_name 
having count(d.department_id) = 0;

select e.first_name || '' || e.last_name as Fullname,e.salary, d.department_name
from employees e left outer join departments d 
on e.department_id=d.department_id;

select e.first_name || '' || e.last_name as Fullname, e.job_id, d.department_name
from employees e inner join departments d
on e.department_id=d.department_id
inner join locations l
on d.location_id=l.location_id
where l.state_province is null;

select e.department_id
from employees e left join departments d
on e.department_id=d.department_id 
where d.department_id is null;

select *
from employees e inner join departments d
on e.department_id=d.department_id
inner join locations l 
on d.location_id=l.location_id
where l.country_id='US' and l.state_province <> 'Washington';

alter table Driver
add foreign key (bus_id) references Bus(bus_id);

alter table Reservation
add constraint destination_check check (destination<>'Johar');
