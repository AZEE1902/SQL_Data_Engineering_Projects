--  Step 4: Mart - Create skills demand mart.

DROP schema if exists skills_mart CASCADE;

create schema skills_mart;

SELECT '=== Loading Skill dim for Skills Mart ===' as info;
CREATE TABLE skills_mart.dim_skills(
    skill_id INTEGER PRIMARY KEY,
    skills VARCHAR,
    TYPE VARCHAR
);
INSERT INTO skills_mart.dim_skills(
    skill_id,
    skills,
    TYPE
)
select
    skill_id,
    skills,
    TYPE
FROM skills_dim;

SELECT '=== Loading Date Dim for Skills Mart ===' as info;
CREATE table skills_mart.dim_date_month(
    month_start_date date PRIMARY KEY,
    YEAR INTEGER,
    month INTEGER,
    quarter integer,
    quarter_name varchar,
    year_quarter varchar
);
INSERT into skills_mart.dim_date_month(
    month_start_date,
    YEAR,
    month,
    quarter,
    quarter_name,
    year_quarter
)
SELECT DISTINCT
    DATE_TRUNC('month', job_posted_date) as month_start_date,
    EXTRACT(YEAR FROM job_posted_date) as year,
    EXTRACT(MONTH FROM job_posted_date) as month,
    EXTRACT(QUARTER FROM job_posted_date) as quarter,
    'Q-' || extract(QUARTER FROM job_posted_date)::varchar as quarter_name,
    EXTRACT(YEAR FROM job_posted_date)::varchar || '-Q' || 
    extract(QUARTER FROM job_posted_date)::varchar as year_quarter
FROM 
    job_postings_fact
ORDER BY month_start_date;    

SELECT '=== Loading Skill fact for Skills Mart ===' as info;

CREATE Table skills_mart.fact_skill_demand_monthly(
    skill_id INTEGER,
    month_start_date date,
    job_title_short VARCHAR,
    postings_count VARCHAR,
    remote_postings_count VARCHAR,
    health_insurance_postings_count VARCHAR,
    no_degree_mention_postings_count VARCHAR,
    PRIMARY KEY(skill_id, month_start_date, job_title_short),
    FOREIGN KEY (skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY (month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);

INSERT into skills_mart.fact_skill_demand_monthly(
    skill_id,
    month_start_date,
    job_title_short,
    postings_count,
    remote_postings_count,
    health_insurance_postings_count,
    no_degree_mention_postings_count 
)

WITH job_postings_prep as(
    
SELECT 
    sjd.skill_id,
    DATE_TRUNC('month', job_posted_date) as month_start_date,    
    jpf.job_title_short,
    -- Conver boolean flags (1 or 0)
    case WHEN jpf.job_work_from_home = true then 1 else 0 end as is_remote,
    case WHEN jpf.job_health_insurance = true then 1 else 0 end as has_health_insurance,
    case WHEN jpf.job_no_degree_mention = true then 1 else 0 end as no_degree_mentioned
FROM
    job_postings_fact as jpf
INNER JOIN
    skills_job_dim as sjd       
    on sjd.job_id = jpf.job_id
)    

SELECT 
    skill_id,
    month_start_date,
    job_title_short,
    COUNT(*) as postings_count,
    sum(is_remote) as remote_postings_count,
    sum(has_health_insurance) as health_insurance_postings_count,
    sum(no_degree_mentioned) as no_degree_mentioned_postings_count
FROM
    job_postings_prep
GROUP BY ALL
ORDER BY skill_id, month_start_date, job_title_short;


SELECT 'Skill Dimension' as table_name, count(*) as record_count from skills_mart.dim_skills
    UNION ALL
SELECT 'Date month dimension', count(*) from skills_mart.dim_date_month
    UNION ALL 
SELECT 'Skill demand fact', COUNT(*) from skills_mart.fact_skill_demand_monthly;      

SELECT '=== Skills Dimension Sample ===' as info;
SELECT * From skills_mart.dim_skills limit 5;

SELECT '=== Date Month Dimension Sample ===' as info;
SELECT * From skills_mart.dim_date_month limit 5;

SELECT '=== Skill Demand Fact Sample ===' as info;
SELECT * From skills_mart.fact_skill_demand_monthly limit 5;