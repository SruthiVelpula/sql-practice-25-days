-- =====================================================
-- Day 9: SELF JOIN + LeetCode SQL 50 (#197 Rising Temperature)
-- Date: November 6, 2026
-- =====================================================

-- KEY IDEAS
-- 1. There is NO "SELF JOIN" keyword. A self join is a normal JOIN
--    of a table to ITSELF.
-- 2. We give the same table two aliases (nicknames) so SQL can tell
--    the two copies apart. The alias goes right after the table name.
--    Example: FROM Staff w JOIN Staff b  ->  w = worker copy, b = boss copy
-- 3. Aliases are temporary. They only exist inside this one query.
-- 4. Use a self join when one row needs to be compared with ANOTHER row
--    in the same table (worker -> boss, today -> yesterday).


-- -----------------------------------------------------
-- Practice table: Staff (each worker has a boss_id that points
-- to another row in the SAME table)
-- -----------------------------------------------------
CREATE TABLE Staff (
    staff_id INT,
    name     VARCHAR(50),
    boss_id  INT
);

INSERT INTO Staff VALUES
(1, 'Priya', NULL),
(2, 'Ben',   1),
(3, 'Asha',  1),
(4, 'Leo',   2);


-- S1: Show each worker with their boss's name
-- (INNER JOIN: Priya has no boss, so she is not shown)
SELECT w.name AS worker,
       b.name AS boss
FROM Staff w
JOIN Staff b
  ON w.boss_id = b.staff_id;
-- Result: Ben-Priya, Asha-Priya, Leo-Ben


-- S2: Show EVERY worker, even the one with no boss
-- (LEFT JOIN keeps all rows from the first copy; no match -> NULL)
SELECT w.name AS worker,
       b.name AS boss
FROM Staff w
LEFT JOIN Staff b
  ON w.boss_id = b.staff_id;
-- Result: Priya-NULL, Ben-Priya, Asha-Priya, Leo-Ben


-- S3: How many workers does each boss have?
SELECT b.name     AS boss,
       COUNT(*)   AS num_workers
FROM Staff w
JOIN Staff b
  ON w.boss_id = b.staff_id
GROUP BY b.name;
-- Result: Priya 2, Ben 1


-- -----------------------------------------------------
-- LeetCode #197: Rising Temperature (MySQL)
-- Find the id of each day whose temperature is higher
-- than the day before.
-- -----------------------------------------------------
-- Idea: self join Weather to itself.
--   today     = w1
--   yesterday = w2
--   match rows where w1 is exactly 1 day after w2
-- Notes I learned:
--   * DATEDIFF(later, earlier) is MySQL. It returns the number of days.
--   * Column names take NO quotes. Text values take quotes.
SELECT w1.id
FROM Weather w1
JOIN Weather w2
  ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature;
