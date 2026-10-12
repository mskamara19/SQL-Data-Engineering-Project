select 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
from job_postings_fact as jpf 
left join company_dim cd 
    on jpf.company_id = cd.company_id
    limit 10;

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


select * 
from job_postings_fact
limit 10;

select * 
from company_dim
limit 10;

explain
select 
    cd.name as company_name,
    COUNT(jpf.job_id) as count_of_jobs 
from job_postings_fact jpf
left join company_dim cd
on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count_of_jobs > 3000 
order by count_of_jobs desc
limit 10;
