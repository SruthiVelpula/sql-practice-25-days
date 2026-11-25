-- =====================================================
-- Day 19: Revision (GROUP BY/HAVING, CASE, LEFT JOIN + IFNULL) + LeetCode #1251
-- Date: November 25, 2026
-- =====================================================

-- Setup (SQLite Online)
CREATE TABLE departments (dept_id INT, dept_name TEXT);
INSERT INTO departments VALUES (10,'Analytics'), (20,'Sales'), (30,'HR'), (40,'Legal');

CREATE TABLE employees (emp_id INT, name TEXT, dept_id INT, salary INT, city TEXT, manager_id INT);
INSERT INTO employees VALUES
(1,'Asha',10,95000,'Baltimore',NULL),(2,'Ben',10,72000,'Chicago',1),
(3,'Sara',10,64000,'Baltimore',1),(4,'Dev',20,58000,'Dallas',6),
(5,'Arun',20,61000,'Chicago',6),(6,'Maya',20,88000,'Baltimore',NULL),
(7,'Leo',30,52000,'Denver',1),(8,'Sam',20,49000,'Chicago',6);

CREATE TABLE sales (sale_id INT, emp_id INT, amount INT);
INSERT INTO sales VALUES (1,4,500),(2,4,700),(3,5,1200),(4,6,300),(5,8,400),(6,5,100);


-- -----------------------------------------------------
-- PART 1: Revision
-- -----------------------------------------------------

-- R1. Departments with more than 2 employees
SELECT dept_id, COUNT(emp_id) AS num_employees
FROM employees
GROUP BY dept_id
HAVING COUNT(emp_id) > 2;
-- Result: 10 - 3, 20 - 4
-- Correct on the first try!
-- Note: HAVING num_employees > 2 (alias) works in SQLite/MySQL but not in
--   PostgreSQL or SQL Server. Safe habit: repeat COUNT(...) in HAVING.


-- R2. Salary level for each employee (CASE)
SELECT name,
       CASE
           WHEN salary >= 80000 THEN 'High'
           WHEN salary BETWEEN 60000 AND 79999 THEN 'Medium'
           ELSE 'Low'
       END AS salary_level
FROM employees;
-- Result: Asha High, Ben Medium, Sara Medium, Dev Low, Arun Medium, Maya High, Leo Low, Sam Low
-- Mistakes I fixed:
--   * Every condition starts with WHEN. ELSE has no condition (ELSE 'Low').
--   * After END AS comes the column name (salary_level), not a value.
--   * Copy numbers exactly from the question (79999, not 79000).


-- R3. Every employee's total sales (0 if no sales)
SELECT employees.name, IFNULL(SUM(sales.amount), 0) AS total_sales
FROM employees
LEFT JOIN sales
  ON employees.emp_id = sales.emp_id
GROUP BY employees.emp_id, employees.name;
-- Result: Asha 0, Ben 0, Sara 0, Dev 1200, Arun 1300, Maya 300, Leo 0, Sam 400
-- Mistakes I fixed:
--   * No match after LEFT JOIN = NULL, not 0. IFNULL(SUM(...), 0) fixes it.
--   * IFNULL goes in SELECT (changes what a column shows), not WHERE (filters rows).
--   * WHERE runs before SELECT, so it cannot see the alias total_sales.
--   * GROUP BY id + name keeps two people with the same name separate.


-- -----------------------------------------------------
-- PART 2: LeetCode #1251 Average Selling Price (Easy) - ACCEPTED, beats 95.28%
-- -----------------------------------------------------
SELECT Prices.product_id,
       IFNULL(ROUND(SUM(Prices.price * UnitsSold.units) / SUM(UnitsSold.units), 2), 0) AS average_price
FROM Prices
LEFT JOIN UnitsSold
  ON Prices.product_id = UnitsSold.product_id
 AND UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date
GROUP BY Prices.product_id;
-- Ideas:
--   * Weighted average = total money / total units = SUM(price * units) / SUM(units).
--     AVG(price) is wrong: it ignores how many units sold at each price.
--   * Join with TWO conditions: same product AND the sale date is inside the price period.
--   * LEFT JOIN keeps products with no sales; IFNULL(..., 0) turns their NULL into 0.
--   * Name the output column exactly as asked (AS average_price).
