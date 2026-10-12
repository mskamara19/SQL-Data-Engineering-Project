/*

Question: What are the most optimal skills for data engineers-balancing both demand and salary?
- Create a rank column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer postions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It ways core skills. 
*/

select  sd.skills, round(median(jpf.salary_year_avg)) as median_salary, 
round(ln(count(jpf.salary_year_avg)),1) as ln_demand_count,
count(jpf.*) as demand_count,
round((median(jpf.salary_year_avg) * ln(count(jpf.salary_year_avg))) /1_000_000,2) as optimal_score
from job_postings_fact as jpf
inner join skills_job_dim as sjd
on jpf.job_id = sjd.job_id
inner join skills_dim  as sd
on sjd.skill_id = sd.skill_id
where jpf.job_title_short like '%Data Engineer%'
and jpf.job_work_from_home = True
and jpf.salary_year_avg is not null
group by sd.skills
having count(jpf.*) > 100
order by optimal_score desc
limit 25;

/*
Here's the breakdown of the most optimal skills for Data Engineers, based on both high demand and high salaries:

Top Skills by Optimal Score:

- Python is leading the skills with a median salary listed @140k and 1525 job postings, resulting in the highest "optimal score"
- AWS and SQL dominate demand with over 1k postings each and strong median salaries of 140k and 133k.
- Top 5 skills have a salary range bewtween 133k and 175k with a combination of over 4k job postings


┌────────────┬───────────────┬─────────────────┬──────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ demand_count │ optimal_score │
│  varchar   │    double     │     double      │    int64     │    double     │
├────────────┼───────────────┼─────────────────┼──────────────┼───────────────┤
│ python     │      140000.0 │             7.3 │         1525 │          1.03 │
│ aws        │      140000.0 │             7.0 │         1076 │          0.98 │
│ sql        │      133600.0 │             7.3 │         1499 │          0.98 │
│ terraform  │      175000.0 │             5.5 │          238 │          0.96 │
│ airflow    │      150000.0 │             6.3 │          525 │          0.94 │
│ spark      │      140000.0 │             6.5 │          673 │          0.91 │
│ snowflake  │      140000.0 │             6.4 │          612 │           0.9 │
│ kafka      │      150000.0 │             6.0 │          401 │           0.9 │
│ azure      │      135000.0 │             6.5 │          654 │          0.88 │
│ java       │      141750.0 │             6.1 │          428 │          0.86 │
│ scala      │      145000.0 │             5.9 │          357 │          0.85 │
│ databricks │      137500.0 │             5.9 │          381 │          0.82 │
│ kubernetes │      150929.0 │             5.4 │          212 │          0.81 │
│ redshift   │      134008.0 │             6.0 │          386 │           0.8 │
│ nosql      │      142500.0 │             5.6 │          275 │           0.8 │
│ gcp        │      140000.0 │             5.6 │          273 │          0.79 │
│ bigquery   │      150000.0 │             5.3 │          196 │          0.79 │
│ git        │      140000.0 │             5.5 │          257 │          0.78 │
│ hadoop     │      135000.0 │             5.6 │          269 │          0.76 │
│ pyspark    │      140000.0 │             5.3 │          206 │          0.75 │
│ mongodb    │      140000.0 │             5.3 │          204 │          0.74 │
│ docker     │      140000.0 │             5.2 │          187 │          0.73 │
│ go         │      145000.0 │             5.0 │          152 │          0.73 │
│ postgresql │      134000.0 │             5.3 │          196 │          0.71 │
│ mysql      │      140000.0 │             5.1 │          165 │          0.71 │
└────────────┴───────────────┴─────────────────┴──────────────┴───────────────┘
  25 rows                                                           5 columns
*/