
-- 1.    Create and invoke the ADD_LOC procedure and consider the results.

-- a)    Create a procedure called ADD_LOC to insert a new Location into the LOCATIONS Provide the LOCATION_ID    , STREET_ADDRESS, POSTAL_CODE    , CITY, STATE_PROVINCE, COUNTRY_ID   parameters.


-- b)    Compile the code; invoke (call ) the procedure. Query the Locations table to view the results.

-- c)    Handle Error for the Invalid Country IDs


create or replace procedure ADD_LOC (v_location_id number, v_street_address varchar2, v_postal_code varchar2, v_city varchar2, v_state_province varchar2, v_country_id char)
is

    invalid_country_ids exception;
    pragma exception_init(invalid_country_ids, -02291);  

begin

        insert into locations (LOCATION_ID    , STREET_ADDRESS, POSTAL_CODE    , CITY, STATE_PROVINCE, COUNTRY_ID)
        values (v_location_id, v_street_address, v_postal_code,  v_city, v_state_province, v_country_id);
        
        exception
        when invalid_country_ids THEN
        dbms_output.put_line('Invalid COUNTRY_ID -> try it upper case like for Egypt : EG etc.');
        
end;
show errors;


select * from locations;
declare
      
begin
        
        ADD_LOC(3800, 'Assiut University', '71515', 'Assiut', 'Egypt', 'EG');
        

end;
select * from locations;




--Create and Invoke the Query_loc Function to display the data for a certain region from Locations, Countries, regions tables in the following format       
 --" Region Name , Country Name , LOCATION_ID  , STREET_ADDRESS  , POSTAL_CODE , CITY  "   Pass Location ID as an input parameter
--Hint : concat them in a single character variable and return it

create or replace function Query_loc(v_location_id number)
return varchar2
is
        v_region_name varchar2(25); 
        v_country_name varchar2(40);
        v_location number(4);
        v_street_address varchar2(40);
        v_postal_code varchar2(12);
        v_city varchar2(30);
        total_data varchar2(500);

begin

        select r.region_name, c.country_name, l.location_id, l.street_address, l.postal_code, l.city
        into v_region_name, v_country_name, v_location, v_street_address, v_postal_code, v_city
        from regions r join countries c
        on r.region_id = c.region_id
        join locations l
        on c.country_id = l.country_id
        where l.location_id = v_location_id;
        
        
        total_data := v_region_name || ', ' || v_country_name || ', ' ||v_location || ', ' ||v_street_address || ', ' ||v_postal_code || ', ' || v_city;
        return total_data;
        
end;
show errors;


set serveroutput on
declare

        return_result varchar2(500);

begin
        
        return_result := Query_loc(2000);
        dbms_output.put_line(return_result);

end;
show errors;




--3.    Create and invoke the GET_LOC function to return the street address, city for a specified LOCATION_ID. 
-- Hint : use out parameters for the city

create or replace function GET_LOC(v_city out varchar2, v_location_id in number)
return varchar2
is

     v_street_address varchar2(40);

begin

        select street_address, city
        into v_street_address, v_city
        from locations
        where location_id = v_location_id;
        
        return v_street_address;

end;
show errors;


declare

        street varchar2(40);
        city varchar2(25);

begin

        street := GET_LOC(city, 1000);
        dbms_output.put_line(street || ' , ' || city);
        
end;



--4.    Create a function called GET_ANNUAL_COMP to return the annual salary computed from an employee’s monthly salary and commission passed as parameters.  Use the following basic formula to calculate the annual salary: 
--(Salary*12) + (commission_pct*salary*12)

--Use the function in a SELECT statement 
--Hint: Function call prototype GET_ANNUAL_COMP(7000, 0.15)

create or replace function GET_ANNUAL_COMP(v_salary number, v_commission_pct number)
return number
is

    annual_salary number(10,2);

begin
        
        annual_salary := (v_salary*12) + (coalesce(v_commission_pct,0)*v_salary*12);
        
        return annual_salary;

end;
show errors;

select employee_id, last_name, salary, GET_ANNUAL_COMP(salary, commission_pct) as annual_salary
from employees;


--5. a- add RETIRED NUMBER(1) column to employees table using alter

--b- Create and call
--CHECK_RETIRED FUNCTION(V_EMP_ID NUMBER, V_MAX_HIRE_YEAR NUMBER) RETURN Number;
--that will return 1 if employee has passed no of years >=  V_MAX_HIRE_YEAR, return 0 for otherwise

--c- create anonymous block to update the emp with set retired = 1  if this employee will retired

--alter table employees add RETIRED number(1);


create or replace function check_retired(V_EMP_ID NUMBER, V_MAX_HIRE_YEAR NUMBER)
return number
is
        v_retired number(1);
        total_years number(6);
        v_hire_date Date;
begin

        select hire_date
        into v_hire_date
        from employees
        where employee_id = v_emp_id;
        
        total_years := months_between(sysdate, v_hire_date)/12;
        
        if total_years >= V_MAX_HIRE_YEAR then v_retired := 1;
        elsif total_years < V_MAX_HIRE_YEAR then v_retired := 0;
        end if;
        
        return v_retired;

end;
show errors;

create or replace procedure update_retired(v_emp_id number, v_retired number)
is
begin
            update employees
            set retired = v_retired
            where employee_id = v_emp_id;
end; 
show errors;            

set serveroutput on

select * from employees;
declare 

        cursor emp_cursor is 
            select * from employees;
        
        retired_or_not number(1);

begin

        for v_emp_record in emp_cursor loop
        
                retired_or_not := check_retired(v_emp_record.employee_id, 20);
                if retired_or_not = 1 then
                
                        update_retired(v_emp_record.employee_id, retired_or_not);
                                     
                end if;
        
        end loop;

end;
select * from employees;
