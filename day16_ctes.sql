-- =====================================================
-- Day 16: CTEs (WITH ... AS) + Revision + LeetCode #1978
-- Date: November 13, 2026
-- =====================================================

-- KEY IDEAS
-- 1. A CTE (Common Table Expression) is a NAMED temporary table written at the TOP
--    of the query with WITH. Then the main query uses it like a normal table.
--
--      WITH cte_name AS (
--          SELECT ...
--          FROM ...
--      )
--      SELECT ...
--      FROM cte_name;
--
-- 2. Two types: simple CTE (what analysts use most) and recursive CTE (advanced).
-- 3. Several CTEs: ONE WITH at the top, then commas. A later CTE can use an earlier one.
-- 4. The CTE name goes in FROM (it is a table), never in SELECT.
-- 5. Calculate inside the CTE (SUM + GROUP BY, with AS name),
--    then use that name in the main query (WHERE, ORDER BY).
-- 6. Inside a CTE, a SUM becomes a normal column, so WHERE works instead of HAVING.
-- 7. No semicolon after the CTE's closing bracket.

-- Setup (SQLite Online)
CREATE TABLE products (product_id INT, name TEXT, category TEXT, price INT);
INSERT INTO products VALUES
(1,'Laptop','Electronics',900), (2,'Phone','Electronics',600),
(3,'Desk','Furniture',250),     (4,'Chair','Furniture',120),
(5,'Pen','Stationery',5),       (6,'Notebook','Stationery',8),
(7,'Monitor','Electronics',300);

CREATE TABLE sales (sale_id INT, product_id INT, quantity INT, sale_date TEXT);
INSERT INTO sales VALUES
(1,1,2,'2026-11-01'), (2,2,5,'2026-11-01'), (3,5,100,'2026-11-02'),
(4,3,1,'2026-11-03'), (5,1,1,'2026-11-04'), (6,6,40,'2026-11-05'),
(7,2,2,'2026-11-06'), (8,5,50,'2026-11-07');


-- -----------------------------------------------------
-- PART 1: Revision
-- -----------------------------------------------------

-- R1. Furniture or Stationery products under 200
SELECT name
FROM products
WHERE price < 200 AND category IN ('Furniture', 'Stationery');
-- Result: Chair, Pen, Notebook

-- R2. Price level for each product
SELECT name,
       CASE
           WHEN price >= 500 THEN 'Premium'
           WHEN price BETWEEN 100 AND 499 THEN 'Standard'
           ELSE 'Budget'
       END AS price_level
FROM products;
-- Mistakes I fixed:
--   * "500 or more" means >= (not >).
--   * Every condition uses WHEN. ELSE never has a condition.
--   * BETWEEN 100 AND 499 has no brackets.
--   * Close with END AS column_name.
--   * Copy label text exactly from the question ('Premium', not 'premiuim').
-- Memory trick: "CASE: WHEN THEN, WHEN THEN, ELSE, END AS"

-- R3. Products that were never sold
SELECT name
FROM products
WHERE product_id NOT IN (SELECT product_id FROM sales);
-- Result: Chair, Monitor
-- Mistakes I fixed:
--   * INNER JOIN drops unsold products, so they can never be found after the join.
--   * A missing sale is NULL, not 0.
--   * "Show the X that..." means filter rows -> condition goes in WHERE, not SELECT.


-- -----------------------------------------------------
-- PART 2: Day 16 CTE drills
-- -----------------------------------------------------

-- C0. Electronics products over 500
WITH electronics AS (
    SELECT *
    FROM products
    WHERE category = 'Electronics'
)
SELECT name, price
FROM electronics
WHERE price > 500;
-- Result: Laptop 900, Phone 600
-- Mistake I fixed: the CTE name goes in FROM, not SELECT.

-- C0b. Big sales (quantity over 10), highest first
WITH big_sales AS (
    SELECT *
    FROM sales
    WHERE quantity > 10
)
SELECT sale_id, quantity
FROM big_sales
ORDER BY quantity DESC;
-- Result: 100, 50, 40
-- Mistakes I fixed: SELECT = columns, FROM = table (sales). DESC for highest first.

-- C1. Products with total quantity sold over 10
WITH product_qty AS (
    SELECT product_id, SUM(quantity) AS total_qty
    FROM sales
    GROUP BY product_id
)
SELECT product_id, total_qty
FROM product_qty
WHERE total_qty > 10;
-- Result: product 5 - 150, product 6 - 40
-- Mistake I fixed: calculate SUM inside the CTE (where quantity exists), filter outside.
-- Same result without a CTE: GROUP BY product_id HAVING SUM(quantity) > 10

-- C2. Category with the highest total quantity sold
WITH category_total AS (
    SELECT category, SUM(sales.quantity) AS total_qty
    FROM products
    LEFT JOIN sales
      ON products.product_id = sales.product_id
    GROUP BY category
)
SELECT category, total_qty
FROM category_total
ORDER BY total_qty DESC
LIMIT 1;
-- CTE table: Electronics 10, Furniture 1, Stationery 190
-- Result: Stationery, 190
-- Mistakes I fixed: include category in the CTE, name the SUM, don't SUM again outside,
--   ORDER BY needs a column name.


-- -----------------------------------------------------
-- PART 3: LeetCode #1978 Employees Whose Manager Left the Company (Nov 12)
-- -----------------------------------------------------
SELECT employee_id
FROM Employees
WHERE salary < 30000
  AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id;
-- "Manager left" = manager_id is NOT IN the list of current employee_ids.
-- = NULL never works. Use IS NULL / IS NOT NULL.
