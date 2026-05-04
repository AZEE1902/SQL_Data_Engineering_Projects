CREATE or REPLACE Table main.priority_jobs_snapshot(
    job_id INTEGER primary KEY,
    job_title_short VARCHAR,
    company_name VARCHAR,
    job_posted_date TIMESTAMP,
    salary_year_avg DOUBLE,
    priority_lvl INTEGER,
    updated_at TIMESTAMP
);
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
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP
FROM 
    data_jobs.job_postings_fact as jpf
LEFT JOIN data_jobs.company_dim as cd
    on jpf.company_id = cd.company_id    
INNER JOIN staging.priority_roles as r
    on jpf.job_title_short = r.role_name;

select  
    job_title_short,
    count (*) as job_count,
    min(priority_lvl) as priority_lvl,
    min(updated_at) as updated_at    
from priority_jobs_snapshot
group by job_title_short
ORDER BY job_count DESC;    