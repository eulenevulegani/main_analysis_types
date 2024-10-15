SELECT 
DATE_TRUNC(subscription_start,WEEK) as cohort_week,
COUNT(user_pseudo_id) Week_0,
COUNT(CASE WHEN subscription_start <=DATE_ADD(DATE_TRUNC(subscription_start,WEEK), INTERVAL 1 WEEK) AND 
subscription_end IS NULL OR subscription_end > DATE_ADD(DATE_TRUNC(subscription_start,WEEK),INTERVAL 1 WEEK)
THEN user_pseudo_id END) as week_1,
COUNT(CASE WHEN subscription_start <=DATE_ADD(DATE_TRUNC(subscription_start,WEEK), INTERVAL 2 WEEK) AND 
subscription_end IS NULL OR subscription_end > DATE_ADD(DATE_TRUNC(subscription_start,WEEK),INTERVAL 2 WEEK)
THEN user_pseudo_id END) as week_2,
COUNT(CASE WHEN subscription_start <=DATE_ADD(DATE_TRUNC(subscription_start,WEEK), INTERVAL 3 WEEK) AND 
subscription_end IS NULL OR subscription_end > DATE_ADD(DATE_TRUNC(subscription_start,WEEK),INTERVAL 3 WEEK)
THEN user_pseudo_id END) as week_3,
COUNT(CASE WHEN subscription_start <=DATE_ADD(DATE_TRUNC(subscription_start,WEEK), INTERVAL 4 WEEK) AND 
subscription_end IS NULL OR subscription_end > DATE_ADD(DATE_TRUNC(subscription_start,WEEK),INTERVAL 4 WEEK)
THEN user_pseudo_id END) as week_4,
COUNT(CASE WHEN subscription_start <=DATE_ADD(DATE_TRUNC(subscription_start,WEEK), INTERVAL 5 WEEK) AND 
subscription_end IS NULL OR subscription_end > DATE_ADD(DATE_TRUNC(subscription_start,WEEK),INTERVAL 5 WEEK)
THEN user_pseudo_id END) as week_5,
COUNT(CASE WHEN subscription_start <=DATE_ADD(DATE_TRUNC(subscription_start,WEEK), INTERVAL 6 WEEK) AND 
subscription_end IS NULL OR subscription_end > DATE_ADD(DATE_TRUNC(subscription_start,WEEK),INTERVAL 6 WEEK)
THEN user_pseudo_id END) as week_6

FROM
tc-da-1.turing_data_analytics.subscriptions 

GROUP BY 
ALL