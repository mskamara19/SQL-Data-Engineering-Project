-- Array Intro 
SELECT [1, 2, 3];


SELECT'python' as skill
UNION ALL 
SELECT 'sql'
UNION ALL
SELECT 'r';


-- MAP

WITH skill_map AS (
    SELECT MAP{'skill': 'python','type': 'programming'} AS skill_type
)
SELECT 
    skill_type['skill'],
    skill_type['type']
FROM 
    skill_map;

-- JSON
WITH raw_skill_json AS (
    SELECT 
        '{"skill":"python","type":"programming"}':: JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM 
    raw_skill_json;

-- Arrays - Final Example
-- Build a flat skill table for co-workers to access jjob titles, salary info, and skills in one table

CREATE OR REPLACE TEMP TABLE job_skills_array AS
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(sd.skills) AS skills_array
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id=sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sd.skill_id=sjd.skill_id
    GROUP BY ALL;

-- From the perspective of a Data Analyst, analyze the median salary per skill

WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_array) AS skill
    FROM
        job_skills_array
)
SELECT
    sKill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC
LIMIT 50; 