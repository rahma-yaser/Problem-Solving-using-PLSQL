-- 1.    Create plsql block to calculate the retired salary for the employee no = 105
-- Retired salary = no of working months * 10 % of his current salary

declare

        v_employee_id number(6) := 105;
        v_last_name varchar2(25);
        v_hire_date date;
        v_salary number(8,2);
        v_retired_salary number(8,2);

begin

        select employee_id, last_name, hire_date, salary
        into v_employee_id, v_last_name, v_hire_date, v_salary
        from employees
        where employee_id = v_employee_id;
        
        v_retired_salary := months_between(sysdate, v_hire_date)*(v_salary*0.1);
        
         
        dbms_output.put_line(v_last_name || ' his retried salary is ' || v_retired_salary);   
        

end;


--2.    Create plsql block to print last name, department name, city, country name for employee whose id = 105 ( without using join | sub query )


declare
        
        v_employee_id number(6) := 105;
        v_last_name varchar2(25); 
        v_department_id number(4);      
        v_department_name varchar2(30);      
        v_location_id number(4);      
        v_city varchar2(30);       
        v_country_id char(2);      
        v_country_name varchar2(40);

begin

        select last_name, department_id
        into v_last_name, v_department_id
        from employees
        where employee_id  =  v_employee_id;
        
        select department_name, location_id
        into v_department_name, v_location_id
        from departments
        where department_id = v_department_id;
        
        select city, country_id
        into v_city, v_country_id
        from locations
        where location_id = v_location_id;
        
        select country_name
        into v_country_name
        from countries
        where country_id = v_country_id;
        
        dbms_output.put_line(v_last_name ||' , ' ||  v_department_name || ' , ' ||  v_city ||' , ' || v_country_name);         

end;


--3.    Create a PL/SQL block to calculate the bonus for employee number = 102. Bonus = 5% of current salary.

declare

        v_emp_id number(6) := 102;
        v_last_name varchar2(25);
        v_salary number(8,2);
        v_bonus_salary number(8,2);

begin

        select last_name , salary
        into v_last_name, v_salary
        from employees
        where employee_id = v_emp_id;
        
        v_bonus_salary := v_salary*0.05;
        
        DBMS_OUTPUT.PUT_LINE(v_last_name || ' his total bonus is ' || v_bonus_salary);

end;


--4.    Create a PL/SQL block to count the number of employees in the department with ID = 10.

declare

        v_total_emp number(6);
        
begin

        select count(employee_id) as total_emp
        into v_total_emp
        from employees
        where department_id = 10;
        
        dbms_output.put_line(v_total_emp);

end;


--5.    Create a PL/SQL block to find the employee id, last name with the maximum salary.

declare

        v_emp_id number(6);
        v_last_name varchar2(25);
        v_salary number(8,2);
        
begin

        select employee_id, last_name, salary
        into v_emp_id, v_last_name, v_salary
        from employees
        where salary = (select max(salary) from employees);
        
        
        dbms_output.put_line( v_last_name|| ' whose id is ' || v_emp_id || ' has the max salary which is ' || v_salary);     
        
end;


--6.    Create a PL/SQL block to calculate the total salary of all employees.

declare

        v_total_salary number(10,2);
        
begin

        select sum(salary) as total_salary
        into v_total_salary
        from employees;
        
        
        dbms_output.put_line( 'The summation of total salaries is  ' || v_total_salary);     
        
end;
