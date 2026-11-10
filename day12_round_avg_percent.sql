-- =====================================================
-- Day 12: LeetCode SQL 50 - ROUND, AVG, and math in SQL
-- Date: November 9, 2026
-- =====================================================

-- KEY IDEAS
-- 1. ROUND(value, 2) rounds to 2 decimals. Without ', 2' it rounds to 0 decimals.
-- 2. ROUND is not a last step. It WRAPS the value inside SELECT.
-- 3. SQL math: + - * /   A ratio is a / b.
-- 4. Percent trick: CASE gives 1 or 0 -> AVG = fraction -> * 100 = percent.
-- 5. An alias made with AS cannot be used in the same SELECT.

-- LeetCode #1075 Project Employees I (JOIN + GROUP BY + ROUND(AVG(), 2))
SELECT Project.project_id,
       ROUND(AVG(Employee.experience_years), 2) AS average_years
FROM Project
INNER JOIN Employee
  ON Project.employee_id = Employee.employee_id
GROUP BY Project.project_id;
-- Lesson: ROUND is not a last step. It WRAPS the value inside SELECT.
-- After GROUP BY, the query ends.

-- LeetCode #1211 Queries Quality and Percentage (Nov 9)
-- Math in SQL: + - * /   |  ratio = rating / position
-- Percent trick: CASE gives 1 (poor) or 0, AVG of 1s/0s = fraction, * 100 = percent
SELECT query_name,
       ROUND(AVG(rating / position), 2) AS quality,
       ROUND(AVG(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100, 2) AS poor_query_percentage
FROM Queries
GROUP BY query_name;
-- Lessons: build nested functions from the inside out (CASE -> AVG -> *100 -> ROUND).
-- GROUP BY takes a COLUMN name (query_name), not values (Dog, Cat).
