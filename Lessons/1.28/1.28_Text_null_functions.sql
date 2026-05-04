SELECT char_LENGTH('SQL');

select left('SQL', 2);

select right('SQL', 2);

select SUBSTRING('SQL', 2, 1);

select concat('SQL', '-', 'Functions');

select 'SQL'|| '-'|| 'Functions';

SELECT TRIM(' SQL ');

SELECT REPLACE('SQL', 'Q', '_');

WITH job_title_lower as(
    SELECT
        job_title,
        LOWER(TRIM(job_title)) as job_title_clean
    FROM job_postings_fact    
)
SELECT
    job_title,
    CASE 
        WHEN job_title_clean like '%data%' AND job_title_clean LIKE '%analyst%' THEN  'Data Analyst'
        WHEN job_title_clean like '%data%' AND job_title_clean LIKE '%engineer%' THEN  'Data Engineer'
        WHEN job_title_clean like '%data%' AND job_title_clean LIKE '%scientist%' THEN  'Data Scientist'
        ELSE 'Other'
    END as job_title_category,
from job_title_lower
ORDER BY RANDOM()
limit 100;    


SELECT NULLIF(10,30);

SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
from job_postings_fact
where salary_year_avg is not null or salary_hour_avg is not null    
limit 10;


-- Final example - Simplify with coalesce

SELECT
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) as standardized_salary,
    CASE 
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) IS NULL THEN  'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75_000 THEN  'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 150_000 THEN  'Medium'
        ELSE  'High'
    END AS salary_bucket
from job_postings_fact
ORDER BY standardized_salary DESC;