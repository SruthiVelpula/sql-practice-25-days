-- Day 3: Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
-- Table: employees (id, name, dept, salary, city)

-- Q23. Total number of employees
SELECT COUNT(*) FROM employees;

-- Q24. Total salary of all employees
SELECT SUM(salary) FROM employees;

-- Q25. Highest salary
SELECT MAX(salary) AS max_salary FROM employees;

-- Q26. Average salary in Baltimore
SELECT AVG(salary) FROM employees WHERE city = 'Baltimore';

-- Q27. Number of employees in IT
SELECT COUNT(*) FROM employees WHERE dept = 'IT';

-- Q28. Lowest salary in Sales (text match is case-sensitive: 'Sales', not 'sales')
SELECT MIN(salary) FROM employees WHERE dept = 'Sales';

-- Q29. Number of different cities
SELECT COUNT(DISTINCT city) FROM employees;

-- Q30. Highest and lowest salary in one query
SELECT MAX(salary) AS max_salary, MIN(salary) AS min_salary FROM employees;

-- Q31. Gap between highest and lowest salary
SELECT MAX(salary) - MIN(salary) AS salary_gap FROM employees;

-- Q32. Employees earning more than 60000 in Chicago ("how many" = COUNT)
SELECT COUNT(*) FROM employees WHERE salary > 60000 AND city = 'Chicago';

-- W1 (review). IT or HR earning more than 56000 (AND runs before OR, so use parentheses)
SELECT * FROM employees WHERE (dept = 'IT' OR dept = 'HR') AND salary > 56000;
