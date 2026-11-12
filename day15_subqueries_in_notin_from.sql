-- =====================================================
-- Day 15: Subqueries (one value, IN / NOT IN, subquery in FROM) + Revision
-- Date: November 12, 2026
-- =====================================================

-- KEY IDEAS
-- 1. A subquery is a query inside a query. Build and run the INSIDE first.
-- 2. Subquery returns ONE value (like AVG)  -> use =, >, <
--    Subquery returns a LIST                -> use IN / NOT IN
-- 3. Where a subquery can go:
--      WHERE  -> filter rows
--      SELECT -> add a column
--      FROM   -> acts like a temporary table (must have a name: AS t)
--      HAVING -> filter groups
-- 4. "Never / didn't" questions: inside = who DID it, outside = NOT IN.

-- Setup (SQLite Online)
CREATE TABLE customers (customer_id INT, name TEXT, city TEXT);
INSERT INTO customers VALUES
(1,'Asha','Baltimore'), (2,'Ben','Chicago'), (3,'Cara','Dallas'), (4,'Dev','Denver');

CREATE TABLE orders (order_id INT, customer_id INT, amount INT, order_date TEXT, status TEXT);
INSERT INTO orders VALUES
(101,1,120,'2026-10-01','Shipped'),  (102,1, 80,'2026-10-03','Delivered'),
(103,2,250,'2026-10-04','Pending'),  (104,1,300,'2026-10-07','Delivered'),
(105,3, 90,'2026-10-08','Shipped'),  (106,2,150,'2026-10-10','Shipped'),
(107,4, 60,'2026-10-12','Cancelled'),(108,2,200,'2026-10-15','Delivered'),
(109,3,110,'2026-10-18','Delivered');


-- -----------------------------------------------------
-- PART 1: Revision
-- -----------------------------------------------------

-- R1. Shipped or Delivered orders over 100
SELECT *
FROM orders
WHERE amount > 100 AND (status = 'Shipped' OR status = 'Delivered');
-- Shorter: WHERE amount > 100 AND status IN ('Shipped', 'Delivered');
-- Result: 101, 104, 106, 108, 109
-- Mistakes I fixed:
--   * OR needs the column every time (status = ... OR status = ...).
--   * AND runs before OR, so put ( ) around the OR part.
--   * Text is case-sensitive: 'Delivered', not 'DElivered'.

-- R2. Customers with 3 or more orders
SELECT customer_id, COUNT(order_id) AS num_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 3;
-- Result: 1 - 3, 2 - 3

-- R3. Orders above the average amount
SELECT order_id
FROM orders
WHERE amount > (SELECT AVG(amount) FROM orders);
-- Result: 103, 104, 108 (average is about 151.1)
-- Mistake I fixed: I first put the comparison in SELECT, which made a 1/0 column.
--   SELECT = columns, WHERE = rows.


-- -----------------------------------------------------
-- PART 2: Day 15 drills
-- -----------------------------------------------------

-- D1. Customers with at least one order over 200
-- JOIN version (needs DISTINCT to avoid duplicate names):
SELECT DISTINCT customers.name
FROM customers
INNER JOIN orders
  ON orders.customer_id = customers.customer_id
WHERE amount > 200;

-- Subquery version (never duplicates):
SELECT name
FROM customers
WHERE customer_id IN (SELECT customer_id
                      FROM orders
                      WHERE amount > 200);
-- Result: Asha, Ben
-- Mistake I fixed: the inside must return customer_ids (SELECT customer_id ... WHERE amount > 200),
--   not "SELECT amount > 200", which returns 1s and 0s.


-- D2. Customers who NEVER placed a 'Shipped' order
SELECT name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id
                          FROM orders
                          WHERE status = 'Shipped');
-- Result: Dev
-- Mistakes I fixed:
--   * WHERE (subquery) with nothing in front lets every row pass. Need "customer_id NOT IN".
--   * "Never shipped" is NOT the same as "has a non-shipped order".
--   * IS NOT compares one value. NOT IN compares a whole list.


-- D3. Highest total spending by any customer
SELECT MAX(total) AS highest_spending
FROM (SELECT customer_id, SUM(amount) AS total
      FROM orders
      GROUP BY customer_id) AS t;
-- Inside table: 1-500, 2-600, 3-200, 4-60
-- Result: 600
-- A subquery in FROM is a temporary table and must have a name (AS t).
