-- Rank events per event category and user
WITH unique_events AS (
    -- Select unique user events, ranking them by timestamp to get the first occurrence
    SELECT
        user_pseudo_id,
        event_name,
        country,
        ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, event_name ORDER BY event_timestamp ASC) AS rank_number
    FROM
        `tc-da-1.turing_data_analytics.raw_events`
),

-- Aggregate counts of unique events per country after filtering for the first occurrence
event_counts AS (
    SELECT
        event_name,
        country,
        COUNT(DISTINCT user_pseudo_id) AS no_events
    FROM
        unique_events
    WHERE
        rank_number = 1  -- Only consider the first occurrence of each event
    GROUP BY
        event_name, country  
),

-- Identify the top 3 countries by total events 
top_countries AS (
     SELECT 
        country,
        SUM(no_events) AS total_events
    FROM 
        event_counts
    GROUP BY 
        country
    ORDER BY 
        total_events DESC    
)

-- Main query to select event counts for the top countries 
SELECT
    -- Assign an order to the events for the funnel analysis
    CASE ec.event_name
        WHEN 'session_start' THEN 1
        WHEN 'view_item' THEN 2
        WHEN 'add_to_cart' THEN 3
        WHEN 'begin_checkout' THEN 4
        WHEN 'add_payment_info' THEN 5
        WHEN 'purchase' THEN 6
        ELSE 7  
    END AS event_order,
    ec.event_name,
    -- Use SUM with a CASE to sum events for the top countries
    SUM(CASE WHEN ec.country = (SELECT country FROM top_countries LIMIT 1) THEN ec.no_events END) AS `1st Country events`,
    SUM(CASE WHEN ec.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 1) THEN ec.no_events END) AS `2nd Country events`,
    SUM(CASE WHEN ec.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 2) THEN ec.no_events END) AS `3rd Country events`
FROM
    event_counts ec
JOIN
    top_countries tc ON ec.country = tc.country  -- Join with top countries to filter results
WHERE
    ec.event_name IN ('session_start', 'view_item', 'add_to_cart', 'begin_checkout', 'add_payment_info', 'purchase')  
GROUP BY
    ec.event_name  
ORDER BY
    event_order;  
