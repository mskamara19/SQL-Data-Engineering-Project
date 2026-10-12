-- Bucket Salaries
-- < 25 = 'Low'
-- 25-50 = 'Medium'
-- > 50 = 'High'

SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN  salary_hour_avg < 25 THEN 'Low'
        WHEN  salary_hour_avg < 50 THEN 'Medium'
        ELSE 'High'
    END as salary_categories
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;

-- Handling Missing Data (Nulls)
-- Filter NULL salary values

SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN  salary_hour_avg < 25 THEN 'Low'
        WHEN  salary_hour_avg < 50 THEN 'Medium'
        ELSE 'High'
    END as salary_categories
FROM job_postings_fact
LIMIT 10;

-- Categorizing Categorical Values
-- Classify the 'job_title' column values as:
    -- 'Data Analyst'
    -- 'Data Engineer'
    -- 'Data Scientist'

SELECT 
    job_title,
    CASE
        WHEN  job_title like '%Data%' AND job_title like '%Analyst%' THEN 'Data Analyst'
        WHEN  job_title like '%Data%' AND job_title like '%Engineer%' THEN 'Data Engineer'
        WHEN  job_title like '%Data%' AND job_title like '%Scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END as job_title_category,
    job_title_short
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

-- Conditional Agregation
-- Calculate Median Salaries for Different Buckets
    -- < $100K
    -- >= $100K

SELECT 
    job_title_short,
    count(*) as total_postings,
    median(
        case
        when salary_year_avg < 100_000 then salary_year_avg
        else null
        end
    ) as median_low_salary,
    median(
        case
        when salary_year_avg >= 100_000 then salary_year_avg
        else null
        end
    ) as median_high_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;

-- Final Example: Condtional Calculations
-- Compute a standarized_salary using yearly salary and adjusted hourly salary (e.g 2080 hours/years)
-- Categorize salaries into tiers of:
    -- < 75k 'Low'
    -- 75k - 150k 'Medium'
    -- >= 150k 'High'

with salaries as (
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        case
            when salary_year_avg is not null then salary_year_avg
            when salary_hour_avg is not null then salary_hour_avg * 2080
        end as standardized_salary
    FROM job_postings_fact
    WHERE salary_year_avg is not null or salary_hour_avg is not null
    )

SELECT 
    *,
    CASE
        WHEN standardized_salary < 75_000 THEN 'Low'
        WHEN standardized_salary < 150_000 THEN 'High'
        ELSE 'Medium'
    END as salary_bucket
FROM salaries
ORDER BY salary_bucket DESC
LIMIT 10;