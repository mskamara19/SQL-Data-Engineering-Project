-- Subquery

SELECT *
from (
    SELECT * 
    FROM job_postings_fact
    WHERE salary_hour_avg is not null
    or salary_year_avg is not null
)
LIMIT 10;

-- CTEs

WITH valid_salaries as (
    SELECT *
    FROM job_postings_fact
    WHERE salary_hour_avg is not null
    or salary_year_avg is not null
)

SELECT * 
FROM valid_salaries;

-- Scenario 1 - Subquery in 'SELECT'
-- Show each job's salary next to the overall market median:

SELECT
    job_title_short, salary_year_avg,
    (
        SELECT median(salary_year_avg) 
        FROM job_postings_fact 
    ) as market_median_salary
    FROM job_postings_fact
    WHERE salary_year_avg is not null
    LIMIT 10;

-- Scenario 2 - Subquery in FROM
-- Stage only jobs that are remote before aggrgating to determine the remote median salary per job:

SELECT
    job_title_short, median(salary_year_avg) as median_salary,
    (
        SELECT median(salary_year_avg) 
        FROM job_postings_fact
        WHERE job_work_from_home = true
    ) as market_median_remote_salary
    FROM (
        SELECT job_title_short,
        salary_year_avg
        FROM job_postings_fact
        WHERE job_work_from_home = true
    ) as clean_jobs
    GROUP BY job_title_short
    LIMIT 10;

    -- Scenario 3 Subquery in HAVING
    --Keep only job titles whose median salary is above the overall median


SELECT
    job_title_short, median(salary_year_avg) as median_salary,
    (
        SELECT median(salary_year_avg) 
        FROM job_postings_fact
        WHERE job_work_from_home = true
    ) as market_median_remote_salary
    FROM (
        SELECT job_title_short,
        salary_year_avg
        FROM job_postings_fact
        WHERE job_work_from_home = true
    ) as clean_jobs
    GROUP BY job_title_short
    HAVING (
        median(salary_year_avg) > 
        (SELECT median(salary_year_avg) 
        FROM job_postings_fact
        WHERE job_work_from_home = true)
    )
    LIMIT 10;


SELECT *
FROM range(2) as tgt(key);

SELECT *
FROM range(3) as src(key)
WHERE EXISTS (
    SELECT 1
    FROM range(2) as tgt(key)
    WHERE tgt.key = src.key
);

-- Final Example
-- Identify job postings that have no associated skills before loading them into a data mart

SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT * 
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;


SELECT *
FROM job_postings_fact as tgt
WHERE NOT EXISTS (
    SELECT 1 
    FROM skills_job_dim as src
    WHERE tgt.job_id = src.job_id
)
ORDER BY tgt.job_id;

-- Exists Filtering

SELECT 
cd.company_id,
cd.name
FROM company_dim as cd
WHERE EXISTS (
    SELECT 1
    FROM job_postings_fact as jpf
        INNER JOIN skills_job_dim as sjd 
            ON jpf.job_id = sjd.job_id 
        INNER JOIN skills_dim as sd 
            ON sd.skill_id = sjd.skill_id
    WHERE cd.company_id = jpf.company_id
        AND sd.skills = 'python'
);

SELECT 
cd.name,
cd.company_id
FROM company_dim as cd
WHERE EXISTS (
    SELECT 1
    FROM job_postings_fact as jpf
    WHERE cd.company_id =jpf.company_id
);

SELECT 
cd.name,
cd.company_id
FROM company_dim as cd
WHERE NOT EXISTS (
    SELECT 1
    FROM job_postings_fact as jpf
    WHERE cd.company_id =jpf.company_id
);

SELECT 
cd.name,
cd.company_id
FROM company_dim as cd
WHERE EXISTS (
    SELECT 1
    FROM job_postings_fact as jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim as sd
        ON sjd.skill_id = sd.skill_id
    WHERE cd.company_id = jpf.company_id
        AND sd.skills = 'SQL'
);



-- CTE Example 
-- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
-- Use a CTE to calculate the median salary by title and work arrangement, then compare those medians.

WITH title_median AS
    (SELECT
        job_title_short,
        job_work_from_home,
        median(salary_year_avg)::INT AS median_salary
        FROM job_postings_fact
        WHERE job_country = 'United States'
        GROUP BY job_title_short, job_work_from_home)

SELECT
    r.job_title_short,
    r.median_salary as remote_median_salary,
    o.median_salary as onsite_median_salary,
    r.median_salary - o.median_salary as remote_premium
FROM title_median as r 
INNER JOIN title_median as o
ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = True
AND o.job_work_from_home = False
ORDER BY remote_premium DESC;