-- Day 5: INNER JOIN + GROUP BY/HAVING review
-- Tables:
--   employees   (emp_id, name, dept, salary, city)  -> nickname emp
--   departments (dept, manager, floor)              -> nickname dep
-- The bridge: dept is in both tables -> ON emp.dept = dep.dept
-- INNER JOIN (same as JOIN) keeps only rows that match in both tables.
-- Order: SELECT -> FROM -> JOIN -> ON -> WHERE -> GROUP BY -> HAVING -> ORDER BY

-- Setup (re-runnable)
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
CREATE TABLE employees (emp_id INT, name TEXT, dept TEXT, salary INT, city TEXT);
INSERT INTO employees VALUES
(1,'Asha','Sales',60000,'Baltimore'), (2,'Ben','IT',85000,'Chicago'),
(3,'Cara','IT',72000,'Baltimore'),   (4,'Dev','HR',55000,'Atlanta'),
(5,'Ella','Sales',67000,'Chicago'),  (6,'Farid','IT',91000,'Baltimore'),
(7,'Gina','HR',58000,'Chicago'),     (8,'Hana','Marketing',62000,'Atlanta');
CREATE TABLE departments (dept TEXT, manager TEXT, floor INT);
INSERT INTO departments VALUES
('Sales','Priya',1), ('IT','Omar',2), ('HR','Lena',3), ('Finance','Raj',4);

-- JL1. Each employee's name and manager
-- (Hana is missing: no Marketing row in departments. Finance is missing: no employees.)
SELECT emp.name, dep.manager
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept;

-- JL2. Each employee's name, salary, and floor
SELECT emp.name, emp.salary, dep.floor
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept;

-- JL3. Name and manager of employees who live in Chicago (WHERE comes after ON)
SELECT emp.name, dep.manager
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE emp.city = 'Chicago';

-- JL4. Name and floor of employees earning more than 70000
SELECT emp.name, dep.floor
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE emp.salary > 70000;

-- JL5. Each manager and how many employees they manage (JOIN + GROUP BY)
SELECT dep.manager, COUNT(*) AS num_employees
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
GROUP BY dep.manager;


-- =====================================================================
-- Part 2: GROUP BY and HAVING review ladder (from Day 4)
-- WHERE    = filters ONE row (before grouping)
-- GROUP BY = makes groups ("each", "per")
-- HAVING   = filters GROUPS (conditions with COUNT/SUM/AVG/MIN/MAX)
-- =====================================================================


-- L1. Number of employees in each department
SELECT dept, COUNT(*)
FROM employees
GROUP BY dept;

-- L2. Average salary in each city
SELECT city, AVG(salary) AS avg_salary
FROM employees
GROUP BY city;

-- L3. For each department, number of employees earning more than 60000 (WHERE before GROUP BY)
SELECT dept, COUNT(*)
FROM employees
WHERE salary > 60000
GROUP BY dept;

-- L4. Departments with total salary above 120000 (HAVING filters groups)
-- Note: repeat the aggregate in HAVING; aliases in HAVING fail in PostgreSQL/SQL Server
SELECT dept, SUM(salary) AS total_salary
FROM employees
GROUP BY dept
HAVING SUM(salary) > 120000;

-- L5. Among Baltimore or Chicago employees, departments with more than 1 employee
SELECT dept, COUNT(*)
FROM employees
WHERE city IN ('Baltimore', 'Chicago')
GROUP BY dept
HAVING COUNT(*) > 1;

-- L6. Among IT or Sales employees earning more than 60000,
--     each city's average salary, only averages above 65000, highest first
SELECT city, AVG(salary)
FROM employees
WHERE dept IN ('IT', 'Sales') AND salary > 60000
GROUP BY city
HAVING AVG(salary) > 65000
ORDER BY AVG(salary) DESC;
