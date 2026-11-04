-- Day 7: LEFT JOIN vs INNER JOIN
-- Key idea: SELECT chooses the columns; the JOIN chooses the rows.
-- INNER JOIN = only rows that match in both tables.
-- LEFT JOIN  = all rows from the left table (after FROM) + matching rows from the right; no match -> NULL.

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

-- LJ1. Every employee's name, dept, and floor (Hana stays, floor = NULL)
SELECT emp.name, emp.dept, dep.floor
FROM employees emp
LEFT JOIN departments dep
ON emp.dept = dep.dept;

-- J1. INNER JOIN: each employee's name and manager -> 7 rows (Hana missing: no Marketing row)
SELECT employees.name, departments.manager
FROM employees
INNER JOIN departments
ON employees.dept = departments.dept;

-- J2. LEFT JOIN: every employee's name and manager -> 8 rows (Hana's manager = NULL)
SELECT employees.name, departments.manager
FROM employees
LEFT JOIN departments
ON employees.dept = departments.dept;

-- J3. Every department and its employees -> departments on the LEFT
-- (Finance appears with name = NULL; Hana disappears)
SELECT departments.dept, employees.name
FROM departments
LEFT JOIN employees
ON employees.dept = departments.dept;

-- LJ4. Every employee earning more than 60000, with their manager -> 5 rows (Hana's manager = NULL)
SELECT employees.name, employees.salary, departments.manager
FROM employees
LEFT JOIN departments
ON employees.dept = departments.dept
WHERE employees.salary > 60000;

-- LJ5. Every department and how many employees it has (Finance = 0)
-- Use COUNT(employees.emp_id), not COUNT(*): COUNT(*) would count Finance's NULL row as 1.
SELECT departments.dept, COUNT(employees.emp_id) AS num_employees
FROM departments
LEFT JOIN employees
ON employees.dept = departments.dept
GROUP BY departments.dept;
