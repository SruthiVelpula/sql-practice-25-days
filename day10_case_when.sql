-- =====================================================
-- Day 10: CASE WHEN
-- Date: November 7, 2026
-- =====================================================

-- KEY IDEAS
-- 1. CASE WHEN is SQL's "if... then... else". It creates a NEW column.
-- 2. SQL checks the WHENs from top to bottom and stops at the FIRST true one.
-- 3. ELSE catches everything else. Without ELSE, the result is NULL.
-- 4. Always close with END, then name the new column with AS.
-- 5. You can GROUP BY the new CASE column to count each group.
--
-- Syntax:
--   CASE
--       WHEN condition1 THEN 'value1'
--       WHEN condition2 THEN 'value2'
--       ELSE 'other value'
--   END AS new_column_name

-- Setup
CREATE TABLE employees (emp_id INT, name TEXT, dept TEXT, salary INT, city TEXT);
INSERT INTO employees VALUES
(1,'Asha','Sales',60000,'Baltimore'), (2,'Ben','IT',85000,'Chicago'),
(3,'Cara','IT',72000,'Baltimore'),   (4,'Dev','HR',55000,'Atlanta'),
(5,'Ella','Sales',67000,'Chicago'),  (6,'Farid','IT',91000,'Baltimore'),
(7,'Gina','HR',58000,'Chicago'),     (8,'Hana','Marketing',62000,'Atlanta');


-- C1. Label each employee's city as East, Central, or Other
SELECT name, city,
       CASE
           WHEN city = 'New York' THEN 'East'
           WHEN city = 'Chicago'  THEN 'Central'
           ELSE 'Other'
       END AS location_type
FROM employees;
-- Note: select only the columns the question asks for.


-- C2. How many employees are in each salary level?
SELECT CASE
           WHEN salary >= 80000 THEN 'High'
           WHEN salary >= 60000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_level,
       COUNT(*) AS num_employees
FROM employees
GROUP BY salary_level;
-- Result: High 2, Low 2, Medium 4

-- Mistakes I fixed today:
--   * Put a comma between columns in SELECT (COUNT(*) and the CASE column).
--   * Spelling: THEN, not TEHN.
--   * COUNT(*) needs GROUP BY to know what to group.
--   * Select the CASE column (salary_level), not the raw salary column.
