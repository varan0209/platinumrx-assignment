

SELECT sales_channel,
       SUM(amount) AS total_revenue
FROM clinic_sales
GROUP BY sales_channel
ORDER BY total_revenue DESC;

SELECT cs.cid,
       c.clinic_name,
       cs.sales_channel,
       SUM(cs.amount) AS total_revenue
FROM clinic_sales cs
JOIN clinics c ON c.cid = cs.cid
GROUP BY cs.cid, c.clinic_name, cs.sales_channel
ORDER BY cs.cid, total_revenue DESC;

WITH sales_m AS (
  SELECT date_trunc('month', cs."datetime")::date AS month_start,
         cs.cid,
         SUM(cs.amount) AS revenue
  FROM clinic_sales cs
  GROUP BY 1, cs.cid
),
exp_m AS (
  SELECT date_trunc('month', e."datetime")::date AS month_start,
         e.cid,
         SUM(e.amount) AS expenses
  FROM expenses e
  GROUP BY 1, e.cid
)
SELECT COALESCE(s.month_start, e.month_start) AS month_start,
       COALESCE(s.cid, e.cid) AS cid,
       c.clinic_name,
       COALESCE(s.revenue, 0)  AS revenue,
       COALESCE(e.expenses, 0) AS expenses,
       COALESCE(s.revenue, 0) - COALESCE(e.expenses, 0) AS profit_loss
FROM sales_m s
FULL OUTER JOIN exp_m e
  ON s.month_start = e.month_start AND s.cid = e.cid
LEFT JOIN clinics c ON c.cid = COALESCE(s.cid, e.cid)
ORDER BY month_start, cid;
