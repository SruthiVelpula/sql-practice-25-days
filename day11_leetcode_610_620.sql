-- =====================================================
-- Day 11: LeetCode SQL 50 - CASE WHEN practice + odd/even filter
-- Date: November 8, 2026
-- =====================================================

-- KEY IDEAS
-- 1. CASE WHEN can check several conditions at once with AND.
-- 2. "Run" tests only the example. "Submit" tests hidden cases. Always Submit.
-- 3. % gives the remainder. id % 2 = 1 means id is odd; id % 2 = 0 means even.
-- 4. A query has only ONE semicolon, at the very end.
-- 5. Write table names exactly as given (Cinema, not cinema).


-- -----------------------------------------------------
-- LeetCode #610: Triangle Judgement
-- Three sides form a triangle only if any two sides together
-- are longer than the third side.
-- -----------------------------------------------------
SELECT x, y, z,
       CASE
           WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
           ELSE 'No'
       END AS triangle
FROM Triangle;
-- Mistake I fixed: my first try checked only x + y > z.
-- It passed "Run" by luck but would fail "Submit" (example: 10, 20, 5).


-- -----------------------------------------------------
-- LeetCode #620: Not Boring Movies
-- Movies with an odd id and a description that is not 'boring',
-- ordered by rating from highest to lowest.
-- -----------------------------------------------------
SELECT id, movie, description, rating
FROM Cinema
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating DESC;
-- Mistake I fixed: an extra ; after the WHERE line ended the query early,
-- so ORDER BY became a broken second query.
