-- step 6: Mart - Update priority roles mart
SELECT '=== Updating Roles For Priority Mart ===' as info;


-- Update Data Engineer to priority 1
UPDATE priority_mart.priority_roles
set priority_lvl = 1
WHERE role_name = 'Data Engineer';

--  Add Data Scientist as level 3
insert into priority_mart.priority_roles (role_id, role_name, priority_lvl)
VALUES (4, 'Data Scientist', 3);

SELECT * FROM priority_mart.priority_roles;

SELECT '=== Creating Temp Source Table For Priority Mart ===' as info;
--  CREATE TEMP Table

CREATE or REPLACE temp table src_priority_jobs as 
select 
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP as updated_at
FROM 
    job_postings_fact as jpf
LEFT JOIN company_dim as cd
    on jpf.company_id = cd.company_id    
INNER JOIN priority_mart.priority_roles as r
    on jpf.job_title_short = r.role_name;


SELECT '=== Batch Updating priority_jobs_snapshot for Priority Mart ===' as info;
-- Merge Into
MERGE INTO priority_mart.priority_jobs_snapshot as tgt
USING src_priority_jobs as src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

when not matched then 
insert (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
VALUES ( 
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
)

WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Final Check Query
select  
    job_title_short,
    count (*) as job_count,
    min(priority_lvl) as priority_lvl,
    min(updated_at) as updated_at    
from priority_mart.priority_jobs_snapshot
group by job_title_short
ORDER BY job_count DESC;   