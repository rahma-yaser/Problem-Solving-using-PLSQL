set serveroutput on size 1000000
-- 1.    Create plsql block and to check for all employees using cursor; and update their commission_pct based on the salary
/*
SALARY < 7000  :                    COMM = 0.1
7000 <= SALARY < 10000      COMM = 0.15
10000 <= SALARY < 15000    COMM = 0.2
15000 <= SALARY                      COMM = 0.25
*/

/*
select * from employees;
declare

        cursor emp_cursor is
        select * from employees;

begin

        for v_emp_record in emp_cursor loop
                
                if v_emp_record.salary < 7000 
                then
                        update employees
                        set commission_pct = 0.1
                        where employee_id = v_emp_record.employee_id;
                elsif v_emp_record.salary < 10000
                then
                        update employees
                        set commission_pct = 0.15
                        where employee_id = v_emp_record.employee_id;
                elsif v_emp_record.salary < 15000
                then
                        update employees
                        set commission_pct = 0.2
                        where employee_id = v_emp_record.employee_id;       
                 else       
                        update employees
                        set commission_pct = 0.25
                        where employee_id = v_emp_record.employee_id; 
                 end if;
                        
                   
        end loop;

end;
select * from employees;
*/

--2.    Alter table employees then add column retired_bonus
/*
Create plsql block to calculate the retired salary for all employees using cursor and update retired_bonus column
Retired bonus = no of working months * 10 % of his current salary
Only for those employees have passed 18 years of their hired date
*/
/*
alter table employees add retired_bonus number(8,2);
select * from employees;
declare

        cursor v_emp_cursor is
            select * from employees;
        v_working_years number(2);

begin

        for v_emp_record in v_emp_cursor loop
        
                v_working_years := months_between(sysdate, v_emp_record.hire_date)/12;
        
                if  v_working_years > 18 then
                    update employees
                    set retired_bonus = v_working_years * 0.1 * v_emp_record.salary
                    where employees.employee_id = v_emp_record.employee_id;
                end if;
                
        end loop;

end;
select * from employees;
*/

-- 3.    Create plsql block using cursor to print last name, department name, city, country name for all employees employee ( without using join | sub query )
--without join
/*
declare

        cursor emp_cursor is 
        select * from employees;
        
     
        v_department_name varchar2(30);
        v_location_id number(4);
        v_city varchar2(30);
        v_country_id char(2);
        v_country_name varchar2(40);       
        v_counter number(4) := 0;
        
begin

        for v_emp_record in emp_cursor loop
                
                if   v_emp_record.department_id is not null then             
      
                    select department_name, location_id
                    into v_department_name, v_location_id
                    from departments
                    where department_id = v_emp_record.department_id;
                    
                    select city, country_id
                    into v_city, v_country_id
                    from locations
                    where location_id = v_location_id;
                    
                    select country_name
                    into v_country_name
                    from countries
                    where country_id = v_country_id;
                
                    dbms_output.put_line('The employee ' ||  v_emp_record.last_name || ' in department' || v_department_name || ' located in ' || v_city || ' a city in ' || v_country_name);
                    v_counter := v_counter + 1;
                    
               end if;
               
              
        end loop;
        
        dbms_output.put_line(v_counter);

end;
*/
--join
/*
declare

        cursor join_cursor is
            select last_name, department_name, city, country_name
            from employees join departments
            on employees.department_id = departments.department_id
            join locations
            on departments.location_id = locations.location_id
            join countries
            on locations.country_id = countries.country_id;

begin

        for v_join_record in join_cursor loop
        
            dbms_output.put_line('The employee name ' || v_join_record.last_name || ' in department' || v_join_record.department_name || ' located in ' || v_join_record.city || ' a city in ' || v_join_record.country_name);
        
        end loop;
        

end;
*/
--4.    Create plsql block that loop over employees table and Increase only those working in ‘IT’ department by 10% of their salary. 
--without join
/*
select * from employees;
declare

        cursor emp_cursor is
        select * from employees;
        
        v_department_name varchar2(25);


begin

        for v_emp_record in emp_cursor loop
        
                if v_emp_record.department_id is not null then
                    select department_name
                    into v_department_name
                    from departments
                    where department_id = v_emp_record.department_id;
                    
                        if v_department_name = 'IT'
                        then
                            update employees
                            set salary = salary + (0.1 * salary)
                            where employee_id =  v_emp_record.employee_id;
                        end if;
                    
                end if;
                
        end loop;
        
end;
select * from employees;
*/
-- with join
/*
select * from employees;
declare

        cursor emp_dept_cursor is
        select employees.* , department_name
        from employees, departments
        where employees.department_id = departments.department_id;        

begin

        for v_emp_dept_record in emp_dept_cursor loop
            
                if v_emp_dept_record.department_id is not null and v_emp_dept_record.department_name = 'IT' then
                        
                        update employees
                        set salary = salary + (0.1 * salary)
                        where employee_id = v_emp_dept_record.employee_id;
                        
                end if;
        
        end loop;

end;
select * from employees;
*/
