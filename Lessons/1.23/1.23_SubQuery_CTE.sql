--  Subquery

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg is NOT NULL
        or salary_hour_avg IS NOT NULL
)
LIMIT 10;          


--  Scenerio 1 - Subquery in 'SELECT'
--  Show each job's salary next to the overall market median:

SELECT 
    job_title_short,
    salary_year_avg,
    (
        SELECT median(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
limit 10;    



--  Scenerio 2 - Subquery in FROM
--  Stage inly jobs that are remote before aggregating to determine the remote median salary per job:


SELECT 
    job_title_short,
    median(salary_year_avg) AS median_salary,
    (
        SELECT median(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM(
    SELECT
        job_title_short,
        salary_year_avg
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
) AS clean_jobs
WHERE salary_year_avg IS NOT NULL
group by job_title_short
limit 10;    



-- Scenerio 3 - Subquery in HAVING
-- Keep only job titles whose median salary is above the overall median:



SELECT 
    job_title_short,
    median(salary_year_avg) AS median_salary,
    (
        SELECT median(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM(
    SELECT
        job_title_short,
        salary_year_avg
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
) AS clean_jobs
group by job_title_short
HAVING median(salary_year_avg) > (
    SELECT median(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
limit 10;   




--  CTE

WITH valid_salaries AS(
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg is NOT NULL
        or salary_hour_avg IS NOT NULL
)
SELECT * FROM valid_salaries;


-- CTE example 
-- Compare how much more (or less) remote jobs pay compared to onsite roles for each job title.
-- Use a cte to calculate the median salary by title and work arrangement, then compare those medians.   

WITH title_median as(
    SELECT
        job_title_short,
        job_work_from_home,
        median(salary_year_avg):: int as median_salary
    FROM job_postings_fact
    WHERE job_country = 'Pakistan'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary as remote_median_salary,
    o.median_salary as onsite_median_salary,
    (r.median_salary - o.median_salary) as remote_premium
FROM title_median as r
inner join title_median as o
    on r.job_title_short = o.job_title_short 
WHERE r.job_work_from_home = TRUE  
AND o.job_work_from_home = false
order by remote_premium desc;
;    


-- Final Example
-- Identify job postings that have no associated skills before loading them into data mart

SELECT *
from job_postings_fact
order by job_id
limit 10;

SELECT *
from skills_job_dim
order by job_id
limit 40;

SELECT * from job_postings_fact as tgt
where not EXISTS(
    select 1
    from skills_job_dim as src
    where tgt.job_id = src.job_id
)
order by job_id;