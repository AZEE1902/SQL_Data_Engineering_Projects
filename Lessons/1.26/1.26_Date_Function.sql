SELECT
    job_posted_date,
    job_posted_date::DATE as date,
    job_posted_date::TIME as time,
    job_posted_date::TIMESTAMP as timestamp,
    job_posted_date::TIMESTAMPTZ as timestamptz
FROM 
    job_postings_fact
LIMIT 10;


SELECT 
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) as job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) as job_posted_month,
    EXTRACT(DAY FROM job_posted_date) as job_posted_day
from job_postings_fact;    


SELECT 
    EXTRACT(YEAR FROM job_posted_date) as job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) as job_posted_month,
    count(job_id) as job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date)
ORDER BY    
    job_posted_year,
    job_posted_month;


SELECT 
    job_posted_date,
    DATE_TRUNC('year', job_posted_date) as job_posted_year,
    DATE_TRUNC('quarter', job_posted_date) as job_posted_quarter,
    DATE_TRUNC('month', job_posted_date) as job_posted_month,
    DATE_TRUNC('week', job_posted_date) as job_posted_week,
    DATE_TRUNC('day', job_posted_date) as job_posted_day,
    DATE_TRUNC('hour', job_posted_date) as job_posted_hour
FROM job_postings_fact
ORDER BY RANDOM()
limit 10;

SELECT 
    DATE_TRUNC('month', job_posted_date) as job_posted_month,
    count(job_id) as job_count
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Engineer' AND
    DATE_TRUNC('year', job_posted_date) = '2024-01-01'
    -- EXTRACT(YEAR FROM job_posted_date) = 2024

GROUP BY
    DATE_TRUNC('month', job_posted_date)
ORDER BY    
    job_posted_month;

SELECT
    '2026-01-01 00:00:00'::timestamptz;    


SELECT
    job_title_short,
    job_location,
    job_posted_date at time zone 'UTC' at time zone 'EST'
from 
    job_postings_fact    
WHERE job_location LIKE 'New York, NY';


SELECT
    EXTRACT(HOUR FROM job_posted_date at time zone 'UTC' at time zone 'EST') as job_posted_hour,
    COUNT(job_id)
FROM 
    job_postings_fact    
WHERE job_location LIKE 'New York, NY'
GROUP BY 
    EXTRACT(HOUR FROM job_posted_date at time zone 'UTC' at time zone 'EST')
ORDER BY
    job_posted_hour;    