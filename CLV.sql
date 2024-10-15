WITH
  purchase_data AS (
  SELECT
    user_pseudo_id,
    SUM(purchase_revenue_in_usd) AS revenue,
    COUNT(*) AS orders
  FROM
    `tc-da-1.turing_data_analytics.raw_events`
  WHERE
    event_name = "purchase"
  GROUP BY
    user_pseudo_id),
  metrics AS (
  SELECT
    SUM(revenue) AS total_revenue,
    SUM (orders) AS total_orders,
    COUNT(DISTINCT(user_pseudo_id)) AS total_customers
  FROM
    purchase_data )
SELECT
  ROUND(total_revenue/total_orders,2) AS average_order_value,
  ROUND(total_orders/total_customers,2) AS purchase_frequency,
  ROUND((total_revenue/total_orders) * (total_orders/total_customers),2) AS customer_value,
  ROUND(((total_revenue/total_orders) * (total_orders/total_customers))*12,2) AS customer_lifetime_value
FROM
  metrics