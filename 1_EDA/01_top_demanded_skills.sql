/*
    Question:
     What are the most in-demand skills for data engineers?
     - Identify the top 10 in-demand skills for data engineers
     - Focus on remote jobs
     - Why? Retreives the top 10 skills with the higher 
     provideing insights into the most valuable skills
*/


select * 
from job_postings_fact
where job_title_short like '%Data Engineer%'
limit 10;

select distinct type
from skills_dim
limit 10;

select * 
from skills_job_dim
limit 10;

select count(sjd.skill_id), sd.skills 
from job_postings_fact as jpf
inner join skills_job_dim as sjd
on jpf.job_id = sjd.job_id
inner join skills_dim  as sd
on sjd.skill_id = sd.skill_id
where jpf.job_title_short like '%Data Engineer%'
and jpf.job_work_from_home = True
group by sd.skills 
order by count(sjd.skill_id) desc
limit 10;

/*

Here's the breakdown of the most demanded skills for data engineers;
SQL and Python are by far the mosr in-demand skills, with around ~ 39,000 job postings each - nearly double the next.
Cloud platforms round out the top skills, with AWS leading ~24,000 postings, followed by Azure at ~18,000.
Apache Spark completes the top 5 with nearly 13,000 postings, highlighting the importance of big data processing skills


Key Takawys:
-SQL and Python remain the foundational skills for data engineers
- Cloud platforms (AWS, Azure) are critical for modern data engineering
- Data pipeline tools (Aireflow, Snowflake, Databricks) show growing demand
- Java and GCP round out the top 10 most requested skills

┌─────────────────────┬────────────┐
│ count(sjd.skill_id) │   skills   │
│        int64        │  varchar   │
├─────────────────────┼────────────┤
│               38368 │ sql        │
│               38117 │ python     │
│               24514 │ aws        │
│               18707 │ azure      │
│               17591 │ spark      │
│               13395 │ airflow    │
│               11781 │ snowflake  │
│               10962 │ databricks │
│                9993 │ java       │
│                9315 │ kafka      │
└─────────────────────┴────────────┘
*/