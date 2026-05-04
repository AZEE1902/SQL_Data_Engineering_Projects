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
    data_jobs.job_postings_fact as jpf
LEFT JOIN data_jobs.company_dim as cd
    on jpf.company_id = cd.company_id    
INNER JOIN staging.priority_roles as r
    on jpf.job_title_short = r.role_name;


-- UPDATE Statement

UPDATE main.priority_jobs_snapshot as tgt
SET
    priority_lvl = src.priority_lvl,
    updated_at = src.priority_lvl
from src_priority_jobs as src    
where tgt.job_id = src.job_id 
    and tgt.priority_lvl is distinct from src.priority_lvl;

--  INSERT Statement 

insert INTO main.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
select 
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
from src_priority_jobs as src    
where not exists (
    select 1 
    FROM main.priority_jobs_snapshot as tgt
    where tgt.job_id = src.job_id
);

-- DELETE Statement 

delete from main.priority_jobs_snapshot as tgt
where not exists (
    select 1 
    from src_priority_jobs as src
    where src.job_id = tgt.job_id
);


-- Final Check Query
select  
    job_title_short,
    count (*) as job_count,
    min(priority_lvl) as priority_lvl,
    min(updated_at) as updated_at    
from priority_jobs_snapshot
group by job_title_short
ORDER BY job_count DESC;   