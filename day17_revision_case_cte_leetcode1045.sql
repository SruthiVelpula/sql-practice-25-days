-- =====================================================
-- Day 17: Revision (CASE WHEN, CTE) + LeetCode #1045
-- Date: November 14, 2026
-- =====================================================

-- Setup (SQLite Online)
CREATE TABLE students (student_id INT, name TEXT, city TEXT, course_id INT, score INT);
INSERT INTO students VALUES
(1,'Anu','Chicago',1,88), (2,'Ben','Dallas',2,72), (3,'Chitra','Baltimore',3,95),
(4,'David','Denver',2,64), (5,'Esha','Boston',1,79), (6,'Farah','Chicago',3,91),
(7,'Gopi','Atlanta',1,55), (8,'Hima','Dallas',2,83);

CREATE TABLE courses (course_id INT, course_name TEXT);
INSERT INTO courses VALUES (1,'SQL'), (2,'Python'), (3,'Power BI'), (4,'Excel');


-- R1. Grade for each student (CASE WHEN)
SELECT name,
       CASE
           WHEN score >= 90 THEN 'A'
           WHEN score BETWEEN 75 AND 89 THEN 'B'
           ELSE 'C'
       END AS grade
FROM students;
-- Result: Chitra A, Farah A, Anu B, Esha B, Hima B, Ben C, David C, Gopi C
-- Mistakes I fixed:
--   * "90 or more" means >= 90 (not > 90).
--   * "75 to 89" means BETWEEN 75 AND 89 (includes both ends).
-- Win: the CASE structure (WHEN ... WHEN ... ELSE ... END AS) was correct on the first try!


-- R2. Courses with an average score above 80 (CTE)
WITH course_avg AS (
    SELECT course_id, AVG(score) AS avg_score
    FROM students
    GROUP BY course_id
)
SELECT course_id, avg_score
FROM course_avg
WHERE avg_score > 80;
-- CTE table: course 1 - 74, course 2 - 73, course 3 - 93
-- Result: course 3 (93)
-- Mistakes I fixed:
--   * Include course_id inside the CTE, or you can't tell which average is which.
--   * Name the average (AS avg_score).
--   * Don't calculate AVG again in WHERE; use the name from the CTE.
-- Rule: calculate inside the CTE (with a name) -> use the name outside.


-- R3. Courses with no students (NOT IN) - practice again tomorrow
WITH courses_with_students AS (
    SELECT course_id
    FROM students            -- step 1: which courses HAVE students? -> 1, 2, 3
)
SELECT course_name
FROM courses                 -- step 2: start from ALL courses
WHERE course_id NOT IN (SELECT course_id FROM courses_with_students);
                             -- step 3: keep the ones NOT in that list
-- Result: Excel
-- Shorter (no CTE):
--   SELECT course_name FROM courses
--   WHERE course_id NOT IN (SELECT course_id FROM students);
-- What I mixed up: inside = the "activity" table (students), outside = the "main" table (courses).


-- -----------------------------------------------------
-- LeetCode #1045 Customers Who Bought All Products (Medium, Nov 13)
-- -----------------------------------------------------
WITH customer_products AS (
    SELECT customer_id, COUNT(DISTINCT product_key) AS num_products
    FROM Customer
    GROUP BY customer_id
)
SELECT customer_id
FROM customer_products
WHERE num_products = (SELECT COUNT(*) FROM Product);
-- "Bought all" = number of DIFFERENT products bought equals the total number of products.
-- Lessons:
--   * The table has duplicates -> COUNT(DISTINCT ...) counts each product once.
--   * Use the real column name (product_key), not the table name.
--   * The total comes from another table -> a small subquery: (SELECT COUNT(*) FROM Product).
