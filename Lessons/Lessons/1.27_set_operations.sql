
CREATE TEMP TABLE jobs_2023 as 
    SELECT * EXCLUDE (job_id, job_posted_date)
    FROM job_postings_fact
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

select * from jobs_2023;

CREATE TEMP TABLE jobs_2024 as 
    SELECT * EXCLUDE (job_id, job_posted_date)
    FROM job_postings_fact
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

select * from jobs_2024;

-- What unique job posings in either 2023 or 2024?

SELECT
'jobs_2023' as table_name, 
count(*) as records
FROM jobs_2023
UNION 
SELECT 'jobs_2024' as table_name,
count(*) as records
FROM jobs_2024;


SELECT * FROM jobs_2023
UNION 
SELECT * FROM jobs_2024;

-- What job postings appeared across both 2023 and 2024 COUNTING DUPLICATES?
SELECT * FROM jobs_2023
UNION ALL 
SELECT * FROM jobs_2024;

-- Which job postings appeared in 2023 and not 2024?
SELECT * FROM jobs_2023
EXCEPT 
SELECT * FROM jobs_2024;

-- Which job postings from 2023 remain after subtracting matching 2024 postings, one-for-one?
SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;

-- Which job postings appeared in both 2023 and 2024?
SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

-- Which of the job postings appeared in both years, preserving duplicate counts?
SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;
