SELECT LENGTH('sql');

WITH title_lower as (
    SELECT
    job_title, 
    LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT 
    job_title,
    CASE
        WHEN  job_title_clean like '%data%' AND job_title_clean like '%analyst%' THEN 'Data Analyst'
        WHEN  job_title_clean like '%data%' AND job_title_clean like '%engineer%' THEN 'Data Engineer'
        WHEN  job_title_clean like '%data%' AND job_title_clean like '%scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END as job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 20;

SELECT 
    nullif(salary_year_avg, 0),
    nullif(salary_hour_avg, 0)
FROM    
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL 
LIMIT 10;



SELECT 
    job_title_short,
    salary_hour_avg,
    salary_year_avg,
    COALESCE(salary_year_avg,salary_hour_avg * 2080) as standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg,salary_hour_avg * 2080) IS NULL THEN 'Missing' 
        WHEN COALESCE(salary_year_avg,salary_hour_avg * 2080) < 75_000 THEN 'Low'
        WHEN COALESCE(salary_year_avg,salary_hour_avg * 2080) < 150_000 THEN 'Mid'
        ELSE 'High'
    END as salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC
LIMIT 10;