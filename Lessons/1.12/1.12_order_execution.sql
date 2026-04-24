/*
Find the top 10 companies for posting jobs.
they must have >3000 postings.
Limit this only to US jobs.
*/

explain analyze
select 
    cd.name as company_name,
    count(jpf.job_id) as posting_count
from job_postings_fact as jpf
left join company_dim as cd    
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'    
group by cd.name            
having count(jpf.job_id) > 3000      
order by posting_count desc
limit 10
;      

