-- =====================================================
-- Day 13: SUBQUERIES + LeetCode SQL 50 #1633
-- Date: November 10, 2026
-- =====================================================

-- KEY IDEAS
-- 1. A subquery is a query inside ( ) that runs FIRST.
-- 2. A one-value subquery can go anywhere a number can go (WHERE, SELECT, math).
-- 3. Percent = part / whole * 100. PART (per group) goes in the OUTER query with GROUP BY.
--    WHOLE (total) goes in the SUBQUERY with no GROUP BY.

-- S1. Employees who earn less than the average salary
SELECT name, salary
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees);

-- S2. Percentage of all employees in each city
SELECT city,
       ROUND(COUNT(emp_id) * 100 / (SELECT COUNT(*) FROM employees), 2) AS pct
FROM employees
GROUP BY city;

-- LeetCode #1633 Percentage of Users Attended a Contest
SELECT Register.contest_id,
       ROUND(COUNT(Register.contest_id) * 100 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM Register
GROUP BY Register.contest_id
ORDER BY percentage DESC, Register.contest_id ASC;
-- Mistakes I fixed: the WHOLE must come from Users (3 users), not Register (12 rows);
-- the outer FROM must be Register; GROUP BY was missing; the subquery needs its own ( ).
