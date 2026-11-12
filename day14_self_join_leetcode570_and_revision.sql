-- =====================================================
-- Day 14: LeetCode #570 (self join) + Revision (IN, LIMIT, JOIN, GROUP BY, CASE WHEN)
-- Date: November 11, 2026
-- =====================================================


-- -----------------------------------------------------
-- PART 1: LeetCode #570 Managers with at Least 5 Direct Reports (MySQL)
-- -----------------------------------------------------
-- Idea: self join Employee to itself.
--   w = worker copy, b = boss copy
--   group by boss, count workers, keep bosses with 5 or more.
SELECT b.name
FROM Employee w
INNER JOIN Employee b
  ON w.managerId = b.id
GROUP BY b.id, b.name
HAVING COUNT(w.id) >= 5;
-- Lessons:
--   * HAVING filters groups with COUNT, not with a plain id.
--   * Output only the columns the question asks for.
--   * Group by the columns you SELECT.


-- -----------------------------------------------------
-- PART 2: Revision (SQLite Online)
-- -----------------------------------------------------
CREATE TABLE courses (course_id INT, course_name TEXT, fee INT);
INSERT INTO courses VALUES
(1,'SQL Basics',200), (2,'Python',350), (3,'Power BI',300),
(4,'Machine Learning',500), (5,'Excel',150);

CREATE TABLE students (student_id INT, name TEXT, age INT, city TEXT, course_id INT);
INSERT INTO students VALUES
(1,'Anu',19,'Chicago',1),   (2,'Ben',22,'Dallas',2),
(3,'Chitra',27,'Baltimore',4), (4,'David',24,'Denver',2),
(5,'Esha',18,'Boston',3),   (6,'Farah',30,'Chicago',4),
(7,'Gopi',21,'Atlanta',1),  (8,'Hima',25,'Dallas',5);


-- Q1. Students who live in Chicago, Dallas, or Denver
SELECT name
FROM students
WHERE city IN ('Chicago', 'Dallas', 'Denver');
-- Result: Anu, Ben, David, Farah, Hima
-- Mistake I fixed: WHERE city = 'Chicago' OR 'Dallas' OR 'Denver' only returns Chicago.
--   With OR, write the column every time. IN is shorter and safer.


-- Q2. The 3 most expensive courses
SELECT course_name, fee
FROM courses
ORDER BY fee DESC
LIMIT 3;
-- Result: Machine Learning 500, Python 350, Power BI 300
-- Order: SELECT > FROM > WHERE > GROUP BY > HAVING > ORDER BY > LIMIT


-- Q3. Each student's name with their course name
SELECT s.name, c.course_name
FROM students s
INNER JOIN courses c
  ON s.course_id = c.course_id;
-- Tip: start FROM the main table the question is about (students).


-- Q4. Number of students in each course
SELECT course_id, COUNT(*) AS num_students
FROM students
GROUP BY course_id;
-- Result: 1-2, 2-2, 3-1, 4-2, 5-1
-- Tip: JOIN only when you need a column from another table (like course_name).


-- Q5. Age group for each student
SELECT name,
       CASE
           WHEN age < 20 THEN 'Teen'
           WHEN age BETWEEN 20 AND 25 THEN 'Young Adult'
           ELSE 'Adult'
       END AS age_group
FROM students;
-- Mistakes I fixed:
--   * ELSE has no condition: ELSE 'Adult' (not ELSE age > 25 THEN ...).
--   * Do not forget FROM.
--   * Name the CASE column with AS.
--   * BETWEEN includes both ends (20 and 25).
