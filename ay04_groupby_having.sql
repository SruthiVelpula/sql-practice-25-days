-- Day 4: GROUP BY and HAVING
-- Table: employees (emp_id, name, dept, salary, city)
-- GROUP BY = one result per group. HAVING = filter groups (after grouping).
-- WHERE filters rows BEFORE grouping; HAVING filters groups AFTER grouping.
-- Clause order: SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY -> LIMIT

-- Q33. Number of employees in each city
SELECT city, COUNT(*) AS num_employees
FROM employees
GROUP BY city;

-- Q34. Total salary for each department
SELECT dept, SUM(salary) AS total_salary
FROM employees
GROUP BY dept;

-- Q35. Average salary per department, highest to lowest
SELECT dept, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept
ORDER BY avg_salary DESC;

-- Q36. Departments with more than 2 employees
SELECT dept, COUNT(*) AS num_employees
FROM employees
GROUP BY dept
HAVING COUNT(*) > 2;

-- Q37. Cities with an average salary above 70000
SELECT city, AVG(salary) AS avg_salary
FROM employees
GROUP BY city
HAVING AVG(salary) > 70000;
