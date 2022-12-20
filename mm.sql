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

--
DECLARE 
  emp_id EMPLOYEES.EMPLOYEE_ID%TYPE;
  emp_sal EMPLOYEES.SALARY%TYPE;
  bonus EMPLOYEES.SALARY%TYPE;
BEGIN
  emp_id := '&EMPLOYEE_ID';  
  
  SELECT SALARY INTO emp_sal
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID = emp_id;
  
  IF (emp_sal < 1000) THEN
    bonus := (emp_sal * 0.1);
  ELSIF (emp_sal > 1000 AND emp_sal <= 1500) THEN
    bonus := (emp_sal * 0.15);
  ELSIF (emp_sal > 1500) THEN
    bonus := (emp_sal * 0.2);
  ELSIF (emp_sal = NULL) THEN
    bonus := 0;  
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(bonus);
END;


DECLARE
    emp_id EMPLOYEES.EMPLOYEE_ID%TYPE;
    emp_commission EMPLOYEES.COMMISSION_PCT%TYPE;
BEGIN
    emp_id := '&EMPLOYEE_ID';
    
    SELECT COMMISSION_PCT INTO emp_commission
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = emp_id;
    
    IF (emp_commission = NULL) THEN
        UPDATE EMPLOYEES
        SET SALARY = SALARY + COMMISSION_PCT
        WHERE EMPLOYEE_ID = emp_id;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(emp_commission);
END;

DECLARE
    dept_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    SELECT DEPARTMENT_NAME INTO dept_name
    FROM DEPARTMENTS
    WHERE DEPARTMENT_ID = 30;
    
    DBMS_OUTPUT.PUT_LINE(dept_name);
END;


CREATE OR REPLACE PROCEDURE JOB_ID_CHECK(DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE)

IS JOB_ID_RETURN EMPLOYEES.JOB_ID%TYPE;

CURSOR C IS 
SELECT JOB_ID INTO JOB_ID_RETURN 
FROM EMPLOYEES 
WHERE DEPARTMENT_ID = DEPT_ID;

BEGIN 
OPEN C;
    LOOP
    FETCH C INTO JOB_ID_RETURN;
    EXIT WHEN C%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(JOB_ID_RETURN);
    END LOOP;
    CLOSE C;
END;

EXEC JOB_ID_CHECK(20);


~~TASK-5

CREATE OR REPLACE PROCEDURE SALARY_CHECK(DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE)

IS SALARY_RETURN EMPLOYEES.SALARY%TYPE;

CURSOR C IS 
SELECT SALARY INTO SALARY_RETURN 
FROM EMPLOYEES 
WHERE DEPARTMENT_ID = DEPT_ID;

BEGIN 
OPEN C;
    LOOP
    FETCH C INTO SALARY_RETURN;
    EXIT WHEN C%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(SALARY_RETURN);
    END LOOP;
    CLOSE C;
END;

EXEC SALARY_CHECK(20);



CREATE OR REPLACE PROCEDURE UPDATE_SALARY(emp_id EMPLOYEES.EMPLOYEE_ID%TYPE)
IS
BEGIN
    UPDATE EMPLOYEES
    SET SALARY = SALARY + SALARY*0.10
    WHERE EMPLOYEE_ID = emp_id;
END;

EXEC UPDATE_SALARY(&emp_id);


CREATE OR REPLACE PROCEDURE ADD_SALARY(dept_no EMPLOYEES.DEPARTMENT_ID%TYPE)
IS
BEGIN
    UPDATE EMPLOYEES
    SET SALARY = SALARY + 1000
    WHERE DEPARTMENT_ID = dept_no
    AND SALARY > 5000;
END;

SET SERVEROUTPUT ON
EXEC ADD_SALARY(&dept_no);


ASK
a)
CREATE OR REPLACE VIEW JOBS_COUNT AS
SELECT JOBS.JOB_TITLE as JOB_NAME, COUNT(EMPLOYEE_ID) as EMPLOYEE_COUNT
FROM EMPLOYEES, JOBS
WHERE EMPLOYEES.JOB_ID = JOBS.JOB_ID
GROUP BY JOBS.JOB_TITLE
WITH READ ONLY;

b)
CREATE OR REPLACE VIEW DETAILS AS
SELECT EMPLOYEE_ID AS EMP_NO,
       FIRST_NAME || ' ' || LAST_NAME AS NAME,
       EMPLOYEES.DEPARTMENT_ID AS DEPART_NO,
       DEPARTMENT_NAME AS DEPART_NAME
FROM EMPLOYEES, DEPARTMENTS
WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID AND 
FIRST_NAME != 'King' AND LAST_NAME != 'King'
WITH READ ONLY;

c)
CREATE OR REPLACE VIEW DETAILS_ALL AS
SELECT EMPLOYEE_ID AS EMP_NO,
       FIRST_NAME || ' ' || LAST_NAME AS NAME,
       EMPLOYEES.DEPARTMENT_ID AS DEPART_NO,
       DEPARTMENT_NAME AS DEPART_NAME
FROM EMPLOYEES, DEPARTMENTS
WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
WITH READ ONLY;   

DECLARE
    x INTEGER;
    y INTEGER;
    z INTEGER;
BEGIN
    x := '&INPUT_NUM_1';
    y := '&INPUT_NUM_2';
    z := a + b;
    DBMS_OUTPUT.PUT_LINE(z);
END;

DECLARE
    x INTEGER;
    y INTEGER;
    z INTEGER := 0;
    i INTEGER;
BEGIN
    x := '&INPUT_BOUNDARY_1';
    y := '&INPUT_BOUNDARY_2';
    
    FOR i IN x..y LOOP
        z := z + i;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(z);
END;

DECLARE
    emp_id EMPLOYEES.EMPLOYEE_ID%TYPE;
    emp_fname EMPLOYEES.FIRST_NAME%TYPE;
    emp_lname EMPLOYEES.LAST_NAME%TYPE; 
    emp_hdate EMPLOYEES.HIRE_DATE%TYPE; 
    emp_dept DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    emp_id := '&EMPLOYEE_ID';
    
    SELECT FIRST_NAME, LAST_NAME, HIRE_DATE, DEPARTMENT_NAME
    INTO emp_fname, emp_lname, emp_hdate, emp_dept
    FROM EMPLOYEES, DEPARTMENTS
    WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
    AND EMPLOYEE_ID = emp_id;
    
    dbms_output.put_line('EMPLOYEE ID: ' ||emp_id);
    dbms_output.put_line('EMPLOYEE First Name: ' ||emp_fname);
    dbms_output.put_line('EMPLOYEE Last Name: ' ||emp_lname);
    dbms_output.put_line('DEPARTMENT Name: ' ||emp_dept);
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE Hire Date: ' || emp_hdate);
END;

DECLARE
    x NUMBER;
    temp NUMBER := 0;
    y NUMBER;
    rem NUMBER;
BEGIN
    x := '&ENTER_NUMBER';
    y := x;
    
    WHILE x > 0
    LOOP
        rem := mod(x,10);
        temp := (temp*10)+rem;
        x := trunc(x/10);
    END LOOP;
    
    IF y = temp THEN
        DBMS_OUTPUT.PUT_LINE('PALINDROME');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NOT PALINDROME');
    END IF;
END;

DECLARE
emp_id EMPLOYEES.EMPLOYEE_ID%type;
fname EMPLOYEES.first_name%type;
lname EMPLOYEES.last_name%type;
mail EMPLOYEES.email%type;
phone EMPLOYEES.phone_number%type;
hire EMPLOYEES.hire_date%type;
jobid EMPLOYEES.job_id%type;
sal EMPLOYEES.salary%type;
comm EMPLOYEES.commission_pct%type;
mg_id EMPLOYEES.manager_id%type;
dept_id EMPLOYEES.department_id%type;

BEGIN
emp_id := '&emp_id';
fname := '&fname';
lname := '&lname';
mail := '&mail';
phone := '&phone';
hire := '&hire';
jobid := '&jobid';
sal := '&sal';
comm := '&comm';
mg_id := '&mg_id';
dept_id := '&dept_id';

insert into EMPLOYEES values(emp_id, fname, lname, mail, phone, hire, jobid, sal, comm, mg_id, dept_id);
insert into DEPARTMENTS values(dept_id, NULL, mg_id, NULL);

END;

DECLARE
   salary EMPLOYEES.SALARY%TYPE;
   mg_num EMPLOYEES.MANAGER_ID%TYPE;
   starting_empno EMPLOYEES.EMPLOYEE_ID%TYPE := 7499;
BEGIN
   SELECT MANAGER_ID INTO mg_num 
   FROM EMPLOYEES 
      WHERE EMPLOYEE_ID = starting_empno;
   WHILE SALARY <= 2500 
    LOOP
        SELECT SALARY, MANAGER_ID INTO salary, mg_num
        FROM EMPLOYEES 
        WHERE EMPLOYEE_ID = mg_num;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE(mg_num);
END;

DECLARE
    x INTEGER := 1;
    y INTEGER := 100;
    z INTEGER := 0;
    i INTEGER;
BEGIN
    FOR i IN x..y LOOP
        z := z + i;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(z);
END;
