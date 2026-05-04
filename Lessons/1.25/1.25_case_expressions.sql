--  Bucket salaries
--  < 25 = 'Low'
--  25 - 40 = 'Medium'
--  ? 50 = 'High'

SELECT
    job_title_short,
    salary_hour_avg,
    CASE 
        WHEN salary_hour_avg < 25 THEN 'Low' 
        WHEN salary_hour_avg < 50 THEN 'Medium' 
        ELSE  'High'
    END as salary_category
FROM job_postings_fact
where salary_hour_avg is not NULL
limit 10;

-- Handling missing values (Nulls)
-- Filter null salary values

SELECT
    job_title_short,
    salary_hour_avg,
    CASE 
        WHEN salary_hour_avg IS NULL then 'Missing'
        WHEN salary_hour_avg < 25 THEN 'Low' 
        WHEN salary_hour_avg < 50 THEN 'Medium' 
        ELSE  'High'
    END as salary_category
FROM job_postings_fact
limit 10;


-- Categorizing Categorical values
-- Classifying the 'job_title' column values as:
    -- 'Data Analyst'  
    -- 'Data Engineer'
    -- 'Data Scientist'

SELECT
    job_title,
    CASE 
        WHEN job_title like '%Data%' AND job_title LIKE '%Analyst%' THEN  'Data Analyst'
        WHEN job_title like '%Data%' AND job_title LIKE '%Engineer%' THEN  'Data Engineer'
        WHEN job_title like '%Data%' AND job_title LIKE '%Scientist%' THEN  'Data Scientist'
        ELSE 'Other'
    END as job_title_category,
    job_title_short
from job_postings_fact
ORDER BY RANDOM()
limit 20;        

-- Conditional Aggregation
-- Calculate Median Salaries For Different Buckets
    -- < $100K
    -- >= $100K

SELECT
    job_title_short,
    count(*) as total_postings,
    MEDIAN(
        CASE 
            WHEN salary_year_avg < 100_000 THEN  salary_year_avg 
        END
    )  AS median_low_salary,

    MEDIAN(
        CASE 
            WHEN salary_year_avg >= 100_000 THEN  salary_year_avg
        END
    )  AS median_high_salary
FROM job_postings_fact
where salary_year_avg IS NOT NULL
GROUP BY job_title_short;

-- Final example: Conditional Calculations
-- Compute a standardized_salary using yearly salary and adjusted hourly salary (e.g. 2080 hours/years) 
-- Categorize salaries into tiers of:
    --  < 75K 'Low'
    --  75K - 150K 'Median'
    -- >= 150K 'High'

WITH salaries AS(
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE 
            WHEN salary_year_avg IS NOT NULL THEN  salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN  salary_hour_avg * 2080
        END as standardized_salary
    FROM 
    job_postings_fact    
)

SELECT
    *,
    CASE 
        WHEN standardized_salary IS NULL THEN  'Missing'
        WHEN standardized_salary < 75_000 THEN  'Low'
        WHEN standardized_salary < 150_000 THEN  'Medium'
        ELSE  'High'
    END AS salary_bucket
from salaries    
limit 10;