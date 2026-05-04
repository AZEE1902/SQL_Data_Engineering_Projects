-- Array Intro

SELECT [1,2,3];

WITH skills AS(
    SELECT 'Python' as skill
    UNION ALL
    SELECT 'SQL'
    UNION ALL
    SELECT 'R'
), skills_array AS (
SELECT ARRAY_AGG(skill ORDER BY skills) as skills
FROM skills
)
SELECT
    skills[1] as first_skill,
    skills[2] as second_skill,
    skills[3] as third_skill
FROM skills_array;    

-- Struct

SELECT {skill: 'Python', type: 'Programming'} as skill_struct;

WITH skill_struct as (
    SELECT
            STRUCT_PACK(
                skill:='Python',
                type:='Programming'
            ) as s
)
SELECT
    s.skill, s.type
FROM skill_struct;


WITH skill_table AS(
    SELECT 'Python' as skills, 'Programming' as types
    UNION ALL
    SELECT 'SQL', 'Query language'
    UNION ALL
    SELECT 'R', 'Programming'
)

SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
from skill_table;    


-- Array of structs

SELECT[
    {skill:'python', type:'programming'},
    {skill:'sql', type:'query lang'}
] as skills_array_of_structs;


WITH skill_table AS(
    SELECT 'Python' as skills, 'Programming' as types
    UNION ALL
    SELECT 'SQL', 'Query language'
    UNION ALL
    SELECT 'R', 'Programming'
), skills_array_sruct as(
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
        )
        ) as array_struct
    from skill_table
)
SELECT 
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
FROM 
    skills_array_sruct;

-- Maps

WITH skill_map as (
       SELECT MAP{'skill': 'python', 'type':'programming'} as skill_type
)
SELECT
    skill_type['skill'],
    skill_type['type']
FROM
    skill_map;    

-- JSON
WITH raw_skill_json AS(
    SELECT
        '{"skills":"python", "type":"programming"}'::JSON as skill_json
)
SELECT
    STRUCT_PACK(
        skill:=JSON_EXTRACT_STRING(skill_json, '$.skills'),
        type:=JSON_EXTRACT_STRING(skill_json, '$.type')
    )
FROM raw_skill_json;

-- JSON to array of structs

WITH raw_json as(
    SELECT
    '[
        {"skill":"python","type":"programming"},
        {"skill":"sql","type":"query_language"},
        {"skill":"R","type":"programming"}
    ]'::JSON as skills_json
)
 SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill:=JSON_EXTRACT_STRING(e.value, '$.skill'),
            type:=JSON_EXTRACT_STRING(e.value, '$.type')
        )
        ORDER BY JSON_EXTRACT_STRING(e.value, '$.skill')
    ) as skills
FROM raw_json, json_each(skills_json) as e;   


-- Array Final example
-- Build a flat skill table for co_workers to access job titles, salary info and skills in one table

CREATE or REPLACE temp table job_skills_array as
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) as skills_array
from job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
LEFT JOIN skills_dim as sd
    on sd.skill_id = sjd.skill_id
GROUP BY all;            

-- From the prespective of data analyst, analyze median salary per skill

WITH flat_skills as (  
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_array) as skill
    FROM
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) as median_salary
from flat_skills
GROUP BY skill;        

-- Array of structs - final example
--  Build a flat skill & type table for co-workers to acess job titles, salary info, skills and type in one table

CREATE or REPLACE temp table job_skills_array_struct as
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) as skills_type
from job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
LEFT JOIN skills_dim as sd
    on sd.skill_id = sjd.skill_id
GROUP BY all;    

-- From the perspective if a data analyst, analyze the median salary per type of skill

    WITH flat_skills as (  
    SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type as skills_type,
    UNNEST(skills_type).skill_name as skills_name
FROM
    job_skills_array_struct
)
SELECT
    skills_type,
    MEDIAN(salary_year_avg) as median_salary
from flat_skills
GROUP BY skills_type;        