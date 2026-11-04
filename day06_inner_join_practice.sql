-- Day 6: INNER JOIN practice (JOIN + WHERE + GROUP BY + HAVING + ORDER BY)
-- Tables:
--   employees   (emp_id, name, dept, salary, city)  -> nickname emp
--   departments (dept, manager, floor)              -> nickname dep
-- Bridge: ON emp.dept = dep.dept
-- FROM/JOIN lines: table + space + nickname (FROM employees emp). Everywhere else: nickname.column (emp.salary)
-- Order: SELECT -> FROM -> JOIN -> ON -> WHERE -> GROUP BY -> HAVING -> ORDER BY
-- WHERE = condition on one row; HAVING = condition with COUNT/SUM/AVG/MIN/MAX

-- JL6. Total salary on each floor
SELECT dep.floor, SUM(emp.salary) AS total_salary
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
GROUP BY dep.floor;

-- JL7. Managers who manage more than 2 employees
SELECT dep.manager, COUNT(emp.emp_id) AS num_employees
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
GROUP BY dep.manager
HAVING COUNT(emp.emp_id) > 2;

-- IJ1. Name, city, and manager of employees on floor 1
SELECT emp.name, emp.city, dep.manager
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE dep.floor = 1;

-- IJ2. Each manager and the average salary of their team
SELECT dep.manager, AVG(emp.salary) AS avg_salary
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
GROUP BY dep.manager;

-- IJ3. For Baltimore employees, how many work on each floor
SELECT dep.floor, COUNT(emp.emp_id) AS num_employees
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE emp.city = 'Baltimore'
GROUP BY dep.floor;

-- IJ4. Managers whose team average salary is above 60000, highest first
SELECT dep.manager, AVG(emp.salary) AS avg_salary
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
GROUP BY dep.manager
HAVING AVG(emp.salary) > 60000
ORDER BY avg_salary DESC;

-- ===== Evening ladder (IJ5-IJ11) =====
-- Habits: write conditions as comments first; numbers have NO quotes; text has 'quotes'
-- GROUP BY = the "each ___" column; HAVING = condition on COUNT/SUM/AVG

-- IJ5. Name and floor of employees in IT
SELECT emp.name, dep.floor
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE emp.dept = 'IT';

-- IJ6. Name, salary, and manager of employees earning less than 60000
SELECT emp.name, emp.salary, dep.manager
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE emp.salary < 60000;

-- IJ7. Number of employees on each floor
SELECT dep.floor, COUNT(*) AS num_emp
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
GROUP BY dep.floor;

-- IJ8. For Chicago employees, each manager and how many of their employees live there
SELECT dep.manager, COUNT(*) AS num_emp
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE emp.city = 'Chicago'
GROUP BY dep.manager;

-- IJ9. Each manager's team total salary, only above 120000, highest first
SELECT dep.manager, SUM(emp.salary) AS total_salary
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
GROUP BY dep.manager
HAVING SUM(emp.salary) > 120000
ORDER BY total_salary DESC;

-- IJ10. Among employees earning more than 55000, each floor's average salary,
--       only averages above 60000, highest first
SELECT dep.floor, AVG(emp.salary) AS avg_salary
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE emp.salary > 55000
GROUP BY dep.floor
HAVING AVG(emp.salary) > 60000
ORDER BY avg_salary DESC;

-- IJ11. Employees managed by Omar who earn more than 80000 (filter on a joined column)
SELECT emp.name
FROM employees emp
INNER JOIN departments dep
  ON emp.dept = dep.dept
WHERE dep.manager = 'Omar' AND emp.salary > 80000;
