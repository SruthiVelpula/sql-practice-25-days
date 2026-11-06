-- Day 8: LeetCode SQL 50 (#1-6, MySQL) + LEFT JOIN with COUNT (SQLite)
-- Lessons: AND/OR, IS NULL, >= for "at least", comparing two columns, DISTINCT, CHAR_LENGTH, LEFT JOIN

-- 1757. Recyclable and Low Fat Products
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

-- 584. Find Customer Referee
-- != skips NULL rows, so add OR ... IS NULL
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

-- 595. Big Countries
-- "at least" means >=
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;

-- 1148. Article Views I
-- Author viewed their own article: compare two columns
SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;

-- 1683. Invalid Tweets
-- CHAR_LENGTH = number of characters
SELECT tweet_id
FROM Tweets
WHERE CHAR_LENGTH(content) > 15;

-- 1378. Replace Employee ID With The Unique Identifier
-- LEFT JOIN keeps every employee; no match -> NULL
SELECT EmployeeUNI.unique_id, Employees.name
FROM Employees
LEFT JOIN EmployeeUNI
ON Employees.id = EmployeeUNI.id;

-- ============================================================
-- Part 2: LEFT JOIN + COUNT (SQLite, sample tables)
-- Rule: COUNT(*) counts rows (even NULL rows), while COUNT(column) skips NULLs.
-- With LEFT JOIN, count a column from the right table so empty groups show 0.
-- Rule: every non-aggregate column in SELECT must be in GROUP BY.
-- ============================================================
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

-- LJ5. Every department and its number of employees (Finance = 0)
SELECT departments.dept, COUNT(employees.emp_id) AS num_employees
FROM departments
LEFT JOIN employees
ON employees.dept = departments.dept
GROUP BY departments.dept;

-- LJ6. Every department, its manager, and number of employees, most to fewest
SELECT departments.dept, departments.manager, COUNT(employees.emp_id) AS num_employees
FROM departments
LEFT JOIN employees
ON departments.dept = employees.dept
GROUP BY departments.dept, departments.manager
ORDER BY num_employees DESC;
