
-- Create Employee Table
CREATE TABLE employees_records (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(30),
    dept VARCHAR(30),
    salary DECIMAL(10,2),
    manager_id INT FOREIGN KEY REFERENCES employees_records(emp_id),
    hire_date DATE
);

-- Insert Data
INSERT INTO employees_records VALUES
(101,'Sindura','IT',50000,NULL,'2025-05-05'),
(102,'Aakash','CSE',70000,101,'2025-03-15'),
(103,'Raja','Finance',60000,101,'2024-08-15'),
(104,'Raktim','EE',40000,102,'2023-07-25'),
(105,'Sampurna','Finance',50000,103,'2022-04-25'),
(106,'Divisha','IT',40000,104,'2021-08-15'),
(107,'Sindura','IT',50000,106,'2025-05-05');

-- View Table
SELECT * FROM employees_records;


------------------------------------------------
-- Find Second Highest Salary
------------------------------------------------
SELECT MAX(salary) AS second_highest_salary
FROM employees_records
WHERE salary < (
    SELECT MAX(salary) FROM employees_records
);


------------------------------------------------
-- Find Third Highest Salary
------------------------------------------------
SELECT MAX(salary) AS third_highest_salary
FROM employees_records
WHERE salary < (
    SELECT MAX(salary)
    FROM employees_records
    WHERE salary < (
        SELECT MAX(salary)
        FROM employees_records
    )
);


------------------------------------------------
-- Find Employees Who Earn More Than Their Manager
------------------------------------------------
SELECT 
    e.emp_name AS employee_name,
    m.emp_name AS manager_name,
    e.salary AS employee_salary,
    m.salary AS manager_salary
FROM employees_records e
JOIN employees_records m
ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;


------------------------------------------------
-- Count Number of Employees in Each Department
------------------------------------------------
SELECT 
    dept,
    COUNT(emp_id) AS total_employees
FROM employees_records
GROUP BY dept
ORDER BY total_employees DESC;


------------------------------------------------
-- Find Departments Having More Than 5 Employees
------------------------------------------------
SELECT 
    dept,
    COUNT(emp_id) AS Employees_Count
FROM employees_records
GROUP BY dept
HAVING COUNT(emp_id) > 5;


------------------------------------------------
-- Find Duplicate Employee Names
------------------------------------------------
SELECT *
FROM (
    SELECT 
        emp_name,
        emp_id,
        ROW_NUMBER() OVER(PARTITION BY emp_name ORDER BY emp_id) AS rnk
    FROM employees_records
) t
WHERE rnk > 1;


------------------------------------------------
-- Delete Duplicate Records But Keep One Copy
------------------------------------------------
WITH cte AS (
    SELECT *
    FROM (
        SELECT 
            emp_id,
            emp_name,
            dept,
            salary,
            ROW_NUMBER() OVER(PARTITION BY emp_name ORDER BY emp_id) AS duplicate_records
        FROM employees_records
    ) t
)
DELETE FROM cte
WHERE duplicate_records > 1;


------------------------------------------------
-- Find Employees Hired in the Last 6 Months
------------------------------------------------
SELECT 
    emp_name,
    salary,
    hire_date
FROM employees_records
WHERE hire_date >= DATEADD(MONTH,-6,GETDATE());


------------------------------------------------
-- Find Department with Highest Average Salary
------------------------------------------------
SELECT 
    dept,
    emp_name,
    AVG(salary) OVER(PARTITION BY dept) AS average_salary
FROM employees_records;


------------------------------------------------
-- Find Top 3 Highest Paid Employees
------------------------------------------------
SELECT TOP (3)
    emp_name,
    salary AS highest_paid_salary
FROM employees_records
ORDER BY salary DESC;


------------------------------------------------
-- Using Window Function (Dense Rank)
------------------------------------------------
SELECT *
FROM (
    SELECT 
        emp_name,
        salary,
        DENSE_RANK() OVER(ORDER BY salary DESC) AS rnk
    FROM employees_records
) t
WHERE rnk <= 3;


------------------------------------------------
-- Find Employees Whose Name Starts and Ends with a Vowel
------------------------------------------------
SELECT emp_name
FROM employees_records
WHERE emp_name LIKE '[aeiou]%'
AND emp_name LIKE '%[aeiou]';
