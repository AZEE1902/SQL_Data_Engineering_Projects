select count(*) from job_postings_fact;

select 
    jpf.job_id,               
    jpf.job_title_short,
    cd.company_id,
    cd.name as Company_name,
    jpf.job_location
from
    job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id;


select 
    jpf.job_id,               
    jpf.job_title_short,
    cd.company_id,
    cd.name as Company_name,
    jpf.job_location
from
    job_postings_fact as jpf
inner join company_dim as cd
    on jpf.company_id = cd.company_id;


select 
    jpf.job_id,               
    jpf.job_title_short,
    cd.company_id,
    cd.name as Company_name,
    jpf.job_location
from
    job_postings_fact as jpf
full outer join company_dim as cd
    on jpf.company_id = cd.company_id;


select 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
from job_postings_fact as jpf
left join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join skills_dim as sd
    on sjd.skill_id = sd.skill_id;   

 

select 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
from job_postings_fact as jpf
inner join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
inner join skills_dim as sd
    on sjd.skill_id = sd.skill_id;   


select 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
from job_postings_fact as jpf
full join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
full join skills_dim as sd
    on sjd.skill_id = sd.skill_id;   
