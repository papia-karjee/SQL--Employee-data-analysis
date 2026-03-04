use papia
create table employees_records(
	emp_id int primary key,
	emp_name varchar(30),
	dept varchar(30),
	salary decimal(10,2),
	manager_id int foreign key references employees_records(emp_id),
	hire_date date
)

insert into employees_records values(101,'Sindura','IT',50000,Null,'2025-05-05'),
                                 (102,'Aakash','CSE',70000,101,'2025-03-15'),
								   (103,'Raja','Finance',60000,101,'2024-08-15'),
								     (104,'Raktim','EE',40000,102,'2023-07-25'),
									   (105,'Sampurna','Finance',50000,103,'2022-04-25'),
									     (106,'Divisha','IT',40000,104,'2021-08-15'),
										  (107,'Sindura','IT',50000,106,'2025-05-05')



select * from employees_records

---- find the second highest salary
select max(salary) as second_highest_salary from employees_records
                    where salary <(select max(salary) from employees_records)


---- find the third highest salary
select max(salary)as third_highest_salary 
                from employees_records 
				     where salary <(select max(salary) from employees_records 
					    where salary <(select max(salary) from employees_records))

---- find employees who earn more than their manager
select e.emp_name as employee_name,
        m.emp_name as manager_name,
		  e.salary as employee_salary,
		    m.salary as manager_salary from employees_records e join employees_records m on e.manager_id = m.emp_id   
			         where e.salary > m.salary

---- count number of employees in each dept
select dept,
       count(emp_id)as total_employees
	      from employees_records group by dept order by total_employees desc

---- find departments having more than 5 employees

select dept,
        count(emp_id)as Employees_Count 
		    from employees_records group by dept having count(emp_id)>5

select * from   employees_records
---- find duplicate employee names
select *from(
select emp_name,
        emp_id,
		row_number()over(partition by emp_name order by emp_id)as rnk
		   from employees_records)t
		     where rnk > 1

        


---- delete duplicate records but keep one copy
with cte as(
select * from(
   select emp_id,
           emp_name,
		      dept,
			   salary,row_number()over(partition by emp_name order by emp_id)as duplicate_records
			      from employees_records)t
		)
delete from cte where duplicate_records>1

---- find employees hired in the last 6 months
select emp_name,
           salary,
		       hire_date from employees_records  where hire_date <= dateadd(Month,-6,getdate())

--- find dept with highest average salary
select dept,
        emp_name,
		  avg(salary)over(partition by dept)as average_salary
		      from employees_records


--- find top 3 highest paid employees
select top(3)emp_name,
        salary as highest_paid_salary 
		   from employees_records 
		      
		             order by highest_paid_salary  desc

--- using windows functions
select * from(
select emp_name,
           salary,
		    dense_rank()over(order by salary desc)as rnk
			     from employees_records)t
				     where rnk <=3

---- find employees whose name starts and ends with vowel
select emp_name from employees_records where emp_name like 
                        '[aeiou]%' and 
						    emp_name like '%[aeiou]';












 



                             

