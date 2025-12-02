

SELECT b.booking_id,
       b.booking_date,
       b.room_no,
       u.name AS guest_name
FROM bookings b
JOIN users u ON u.user_id = b.user_id
ORDER BY b.booking_date DESC, b.booking_id DESC
LIMIT 1;

WITH nov_bills AS (
  SELECT bc.bill_id,
         SUM(bc.item_quantity * i.item_rate) AS bill_amount
  FROM booking_commercials bc
  JOIN items i ON i.item_id = bc.item_id
  WHERE bc.bill_date >= TIMESTAMP '2021-11-01 00:00:00'
    AND bc.bill_date <  TIMESTAMP '2021-12-01 00:00:00'
  GROUP BY bc.bill_id
)
SELECT bill_id, bill_amount
FROM nov_bills
ORDER BY bill_amount DESC;

SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000
ORDER BY total_amount DESC;

WITH monthly_item_qty AS (
  SELECT DATE_TRUNC('month', bc.bill_date)::date AS month_start,
         i.item_name,
         SUM(bc.item_quantity) AS total_qty
  FROM booking_commercials bc
  JOIN items i ON i.item_id = bc.item_id
  GROUP BY 1, 2
),
ranked AS (
  SELECT month_start,
         item_name,
         total_qty,
         RANK() OVER (PARTITION BY month_start ORDER BY total_qty DESC) AS rnk_desc,
         RANK() OVER (PARTITION BY month_start ORDER BY total_qty ASC)  AS rnk_asc
  FROM monthly_item_qty
)
SELECT month_start, 'MOST'  AS extreme, item_name, total_qty FROM ranked WHERE rnk_desc = 1
UNION ALL
SELECT month_start, 'LEAST' AS extreme, item_name, total_qty FROM ranked WHERE rnk_asc = 1
ORDER BY month_start, extreme DESC;

WITH bill_totals AS (
  SELECT bc.bill_id,
         SUM(bc.item_quantity * i.item_rate) AS total_amount
  FROM booking_commercials bc
  JOIN items i ON i.item_id = bc.item_id
  GROUP BY bc.bill_id
),
ranking AS (
  SELECT bill_id, total_amount,
         DENSE_RANK() OVER (ORDER BY total_amount DESC) AS rnk
  FROM bill_totals
)
SELECT bill_id, total_amount
FROM ranking
WHERE rnk = 2
ORDER BY total_amount DESC;
