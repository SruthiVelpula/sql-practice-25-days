-- =====================================================
-- Day 18: NOT IN practice (subquery across two tables)
-- Date: November 16, 2026
-- =====================================================

-- Setup (SQLite Online)
CREATE TABLE students (student_id INT, name TEXT, city TEXT, course_id INT, score INT);
INSERT INTO students VALUES
(1,'Anu','Chicago',1,88), (2,'Ben','Dallas',2,72), (3,'Chitra','Baltimore',3,95),
(4,'David','Denver',2,64), (5,'Esha','Boston',1,79), (6,'Farah','Chicago',3,91),
(7,'Gopi','Atlanta',1,55), (8,'Hima','Dallas',2,83);

CREATE TABLE courses (course_id INT, course_name TEXT);
INSERT INTO courses VALUES (1,'SQL'), (2,'Python'), (3,'Power BI'), (4,'Excel');


-- N1. Students who are NOT in the 'SQL' or 'Python' courses
SELECT name
FROM students
WHERE course_id NOT IN (SELECT course_id
                        FROM courses
                        WHERE course_name IN ('SQL', 'Python'));
-- Inside list: course_ids 1, 2
-- Result: Chitra, Farah
-- Mistakes I fixed (4 tries):
--   * Course names live in the courses table, not students.
--   * The column is course_name, not name.
--   * "SQL or Python" -> IN ('SQL', 'Python'). Never "= 'SQL' AND 'Python'" (mistake #1 again).
--   * Count brackets: every ( needs a ).
-- Rule: inside = build the list from the table that HAS that information;
--       outside = filter the main table with NOT IN.


-- N2. Courses where NO student scored above 90
SELECT course_name
FROM courses
WHERE course_id NOT IN (SELECT course_id FROM students WHERE score > 90);
-- Inside list: course 3 (Chitra 95, Farah 91)
-- Result: SQL, Python, Excel (Excel has no students, so it also counts)
-- Mistakes I fixed:
--   * Scores live in students, not courses; students has course_id, not course_name.
--   * "No one scored above 90" -> inside = who DID score > 90, outside = NOT IN.
--     (I first wrote score < 90 inside, which flips the meaning.)
