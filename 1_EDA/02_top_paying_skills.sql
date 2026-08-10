/*
Question: What are the highest paying skills for data engineers
- Calculate the median salary for each skill required 
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest 
     how common those skills are
*/

select  sd.skills, round(median(jpf.salary_year_avg)) as median_salary, count(sjd.skill_id) as demand_count
from job_postings_fact as jpf
inner join skills_job_dim as sjd
on jpf.job_id = sjd.job_id
inner join skills_dim  as sd
on sjd.skill_id = sd.skill_id
where jpf.job_title_short like '%Data Engineer%'
and jpf.job_work_from_home = True
group by sd.skills
having count(jpf.*) > 100
order by median_salary desc
limit 25;

/* 
Here's the breakdown of the highest-paying skills for Data Engineers

Key Insights:
- Rust is holding the highest median salart at ~190k a year.
- For the top 25 Airflow actually has the highest demanded salary.
- In the top 5 Terraform has the highest demand and salary @ 175k and over 4k job postings
- A couple honorable mentions in the top 10 like Terraform are:
    - Goland @ ~181k a year with over 1k job postings
    - Reddis @ ~170k a year with 942 job postings

┌───────────────┬───────────────┬──────────────┐
│    skills     │ median_salary │ demand_count │
│    varchar    │    double     │    int64     │
├───────────────┼───────────────┼──────────────┤
│ rust          │      199000.0 │          354 │
│ golang        │      181123.0 │         1057 │
│ groovy        │      180000.0 │          126 │
│ spring        │      175500.0 │          489 │
│ terraform     │      175000.0 │         4702 │
│ neo4j         │      171500.0 │          476 │
│ redis         │      170750.0 │          942 │
│ sheets        │      170159.0 │          113 │
│ gdpr          │      169616.0 │          798 │
│ zoom          │      168438.0 │          178 │
│ graphql       │      163750.0 │          559 │
│ django        │      160000.0 │          335 │
│ c             │      159500.0 │          614 │
│ mongo         │      158000.0 │          393 │
│ crystal       │      157112.0 │          144 │
│ ruby          │      155000.0 │         1002 │
│ atlassian     │      151500.0 │          344 │
│ cassandra     │      151000.0 │         1682 │
│ kubernetes    │      150929.0 │         5848 │
│ typescript    │      150500.0 │          558 │
│ css           │      150000.0 │          362 │
│ ruby on rails │      150000.0 │          113 │
│ dynamodb      │      150000.0 │         1677 │
│ couchbase     │      150000.0 │          102 │
│ airflow       │      150000.0 │        13395 │
└───────────────┴───────────────┴──────────────┘
  25 rows                            3 columns

*/

