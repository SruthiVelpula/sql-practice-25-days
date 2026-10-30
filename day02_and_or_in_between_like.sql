-- Day 2: AND, OR, IN, BETWEEN, LIKE, DISTINCT

-- Warm-up: Baltimore employees, highest salary first
SELECT name, salary FROM employees WHERE city = 'Baltimore' ORDER BY salary DESC;

-- Q16: IT employees in Baltimore
SELECT * FROM employees WHERE dept = 'IT' AND city = 'Baltimore';

-- Q17: Sales or HR (using OR)
SELECT name, dept FROM employees WHERE dept = 'Sales' OR dept = 'HR';

-- Q18: Sales or HR (using IN)
SELECT name, dept FROM employees WHERE dept IN ('Sales', 'HR');

-- Q19: Salary between 58,000 and 72,000 (both ends included)
SELECT name, salary FROM employees WHERE salary BETWEEN 58000 AND 72000;

-- Q20: Name starts with G or ends with a
SELECT name FROM employees WHERE name LIKE 'G%' OR name LIKE '%a';

-- Q21: Unique cities
SELECT DISTINCT city FROM employees;

-- Q22: IT or Sales earning more than 65,000, highest first
SELECT name, dept, salary FROM employees
WHERE dept IN ('IT', 'Sales') AND salary > 65000
ORDER BY salary DESC;
