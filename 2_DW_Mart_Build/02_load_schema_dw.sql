-- Setp 2: DW - Load data from CSV files into tables

SELECT '=== Loading company_dim Table ===' AS info;
INSERT INTO company_dim(company_id, name) 
select 
    company_id, name
from read_csv('https://storage.googleapis.com/sql_de/company_dim.csv', auto_detect=true);


SELECT '=== Loading skills_dim Table ===' AS info;

INSERT INTO skills_dim (skill_id, skills, type)
select skill_id, skills, type
from read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv', auto_detect=true);


SELECT '=== Loading job_postings_fact Table ===' AS info;

INSERT INTO job_postings_fact(
    job_id,
    company_id ,
    job_title_short ,
    job_title ,
    job_location ,
    job_via ,
    job_schedule_type ,
    job_work_from_home ,
    search_location ,
    job_posted_date,
    job_no_degree_mention ,
    job_health_insurance ,
    job_country ,
    salary_rate ,
    salary_year_avg,
    salary_hour_avg
)

select
    job_id,
    company_id ,
    job_title_short ,
    job_title ,
    job_location ,
    job_via ,
    job_schedule_type ,
    job_work_from_home ,
    search_location ,
    job_posted_date,
    job_no_degree_mention ,
    job_health_insurance ,
    job_country ,
    salary_rate ,
    salary_year_avg,
    salary_hour_avg
from read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', auto_detect=true);


SELECT '=== Loading skills_job_dim Table ===' AS info;

INSERT INTO skills_job_dim(skill_id, job_id)
select skill_id, job_id
from read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', auto_detect=true);

SELECT '=== Row Counts ===' AS info;
select 'Company Dim' as table_name, count(*) as record_count from company_dim
UNION ALL
select 'Skills Dim' as table_name, count(*) from skills_dim
UNION ALL
select 'Job Postings Fact' as table_name, count(*)from job_postings_fact
UNION ALL
select 'Skills Job Dim' as table_name, count(*)from skills_job_dim;

SELECT '=== Company Dimension Sample ===' as info;
select * from company_dim LIMIT 5;
SELECT '=== Skills Dimension Sample ===' as info;
select * from skills_dim LIMIT 5;
SELECT '=== Job Posting Fact Sample ===' as info;
select * from job_postings_fact LIMIT 5;
SELECT '=== Skills job bridge Sample ===' as info;
select * from skills_job_dim LIMIT 5;