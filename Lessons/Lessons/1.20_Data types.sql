SELECT
    *
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

SELECT 
    cast(job_id as varchar) || '-' || CAST(company_id as varchar),
    CAST(job_work_from_home as INT) AS job_work_from_home,
    CAST(job_posted_date AS DATE) AS job_posted_date,
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
    LIMIT 10;