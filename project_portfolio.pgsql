-- What are the top paying jobs for my role Data Analyst
SELECT job_id,
job_title,
salary_year_avg,
job_posted_date :: DATE,
job_location
from job_postings_fact
WHERE job_title = 'Data Analyst' AND job_location = 'Anywhere'
 AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
Limit 10;

-- what are the skills required for these top paying roles
WITH top_job AS (SELECT job_id,
job_title,
salary_year_avg,
job_posted_date :: DATE,
job_location
from job_postings_fact
WHERE job_title = 'Data Analyst' AND 
salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
Limit 10)

SELECT top_job.*,
skills_job_dim.skill_id,
skills_dim.skills
FROM top_job
INNER JOIN skills_job_dim
ON top_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

-- what are the most in-demand skills for my role (data analyst)
WITH top_job AS (SELECT job_id,
job_title,
salary_year_avg,
job_posted_date :: DATE,
job_location
from job_postings_fact
WHERE job_title = 'Data Analyst' AND 
salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
)

SELECT 
skills_dim.skills,
COUNT(skills_job_dim.skill_id) AS job_skills_count
FROM top_job
INNER JOIN skills_job_dim
ON top_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY job_skills_count DESC
LIMIT 10;

-- what are the top skills based on salary for data analyst role
WITH top_job AS (SELECT job_id,
job_title,
salary_year_avg,
job_posted_date :: DATE,
job_location
from job_postings_fact
WHERE job_title = 'Data Analyst' AND 
salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
)

SELECT 
skills_dim.skills,
COUNT(skills_job_dim.skill_id) AS job_skills_count,
ROUND (AVG (top_job.salary_year_avg), 2) AS avg_salary_skills
FROM top_job
INNER JOIN skills_job_dim
ON top_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY avg_salary_skills DESC
LIMIT 10;

-- what are the most optimal(High Demand and High Paying) skills to learn

WITH top_job AS (SELECT job_id,
job_title,
salary_year_avg,
job_posted_date :: DATE,
job_location
from job_postings_fact
WHERE job_title = 'Data Analyst' AND 
salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
)

SELECT 
skills_dim.skills,
COUNT(skills_job_dim.skill_id) AS job_skills_count,
ROUND (AVG (top_job.salary_year_avg), 2) AS avg_salary_skills
FROM top_job
INNER JOIN skills_job_dim
ON top_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
HAVING ROUND (AVG (top_job.salary_year_avg), 2) > 90000
ORDER BY job_skills_count DESC;