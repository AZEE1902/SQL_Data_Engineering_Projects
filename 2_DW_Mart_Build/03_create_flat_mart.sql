-- Step 3: Mart - Create falt mart table

DROP SCHEMA if EXISTS flat_mart CASCADE;
create SCHEMA flat_mart;
CREATE OR REPLACE TABLE flat_mart.job_postings AS
SELECT
    jpf.job_id,
    jpf.company_id ,
    jpf.job_title_short ,
    jpf.job_title ,
    jpf.job_location ,
    jpf.job_via ,
    jpf.job_schedule_type ,
    jpf.job_work_from_home ,
    jpf.search_location ,
    jpf.job_posted_date,
    jpf.job_no_degree_mention ,
    jpf.job_health_insurance ,
    jpf.job_country ,
    jpf.salary_rate ,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    -- Company dimention fields
    cd.company_id,
    cd.name as company_name,
    ARRAY_AGG(
        STRUCT_PACK(
             type := sd.type,
             name := sd.skills
        )
    ) as skills_and_types
FROM 
    job_postings_fact as jpf
LEFT JOIN   
    company_dim as cd
    on jpf.company_id = cd.company_id
LEFT JOIN
    skills_job_dim as sjd
    on jpf.job_id = sjd.job_id        
LEFT JOIN
    skills_dim as sd
    on sjd.skill_id = sd.skill_id    
GROUP BY ALL;    

SELECT 'Flat Mart Job Postings' AS table_name, COUNT(*) AS record_count FROM flat_mart.job_postings;

SELECT '=== Flat Mart Sample ===' as info;
SELECT * FROM flat_mart.job_postings LIMIT 10;