WITH
  date_range AS (
  SELECT
    DATE('2020-12-01') AS start_date,
    DATE('2020-12-31') AS end_date),
  start_accounts AS (
  SELECT
    user_pseudo_id
  FROM
    tc-da-1.turing_data_analytics.subscriptions s
  INNER JOIN
    date_range d
  ON
    s.subscription_start <= d.start_date
    AND (s.subscription_end > d.start_date
      OR s.subscription_end IS NULL)
  GROUP BY user_pseudo_id),

  end_accounts AS (
  SELECT
    user_pseudo_id
  FROM
    tc-da-1.turing_data_analytics.subscriptions s JOIN
    date_range d
  ON
    s.subscription_start <= d.end_date
    AND (subscription_end > d.end_date
      OR s.subscription_end IS NULL)),

  churned_accounts AS (
  SELECT
    a.user_pseudo_id
  FROM
    start_accounts a
  LEFT OUTER JOIN
    end_accounts z
  ON
    a.user_pseudo_id = z.user_pseudo_id
  WHERE
    z.user_pseudo_id IS NULL ),

start_count  AS 
(SELECT 
COUNT (user_pseudo_id) AS total_start
FROM start_accounts),

churn_count AS 
(SELECT 
COUNT (user_pseudo_id) AS total_churn
FROM 
churned_accounts)

SELECT 
total_start,
total_churn,
ROUND((total_churn/total_start)*100,2) AS churn_rate,
100- ROUND((total_churn/total_start)*100,2) AS retention_rate 
FROM start_count, churn_count

