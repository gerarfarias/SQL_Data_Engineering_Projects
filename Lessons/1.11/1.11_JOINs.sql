SELECT TOP 10
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id