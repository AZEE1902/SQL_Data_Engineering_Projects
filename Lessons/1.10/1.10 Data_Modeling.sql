select 
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
from
    job_postings_fact
limit 10;        

select * from company_dim where name in ('Facebook', 'Meta');


select table_name, column_name, data_type from information_schema.columns where table_catalog = 'data_jobs';

pragma show_tables_expanded;


describe job_postings_fact;