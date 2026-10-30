-- Day 1: SELECT, FROM, WHERE, ORDER BY, LIMIT
-- Dataset: employees (emp_id, name, dept, salary, city)

-- Q1: All columns
SELECT * FROM employees;

-- Q3: Name and salary
SELECT name, salary FROM employees;

-- Q6: Employees in Chicago
SELECT * FROM employees WHERE city = 'Chicago';

-- Q7: Salary above 65,000
SELECT name, salary FROM employees WHERE salary > 65000;

-- Q9: Salary at most 58,000
SELECT name FROM employees WHERE salary <= 58000;

-- Q10: Not in Baltimore
SELECT name, city FROM employees WHERE city != 'Baltimore';

-- Q13: Top 2 highest-paid
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 2;

-- Q14: IT employees, highest salary first
SELECT name, dept, salary FROM employees WHERE dept = 'IT' ORDER BY salary DESC;

-- Q15: Lowest-paid employee
SELECT * FROM employees ORDER BY salary LIMIT 1;
