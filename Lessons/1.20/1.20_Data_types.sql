select 
    table_name,
    column_name,
    data_type
from information_schema.columns    
where table_name = 'job_postings_fact';

describe 
select 
    job_title_short,
    salary_year_avg
from 
    job_postings_fact;    


select cast(123  varchar);


select 
    cast(job_id  varchar) || '-' ||cast(company_id  varchar)  company_job_id,  -- "more" unique identifiers
    cast(job_work_from_home  int)  job_work_from_home, -- from boolean to numeric value
    cast(job_posted_date  date)  job_posted_date, -- from timestamps to date only
    cast(salary_year_avg  decimal (10, 0)) -- from double to no decimal places
from
    job_postings_fact
where salary_year_avg is not null    
limit 10;        



select 
    job_id::varchar || '-' ||company_id::varchar as unique_id,  -- "more" unique identifiers
    job_work_from_home::int  job_work_from_home, -- from boolean to numeric value
    job_posted_date::date  job_posted_date, -- from timestamps to date only
    salary_year_avg::decimal (10, 0) -- from double to no decimal places
from
    job_postings_fact
where salary_year_avg is not null    
limit 10;        





