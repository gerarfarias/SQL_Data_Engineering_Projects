SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*

- Rust is the salary outlier: highest median salary at $210K, but relatively modest demand (232 postings). It looks premium and specialized rather than broad-market.

Terraform and Kubernetes combine high pay with strong demand:
- Terraform: $184K, 3,248 demand
- Kubernetes: $150.5K, 4,202 demand
  These are especially strong infrastructure/cloud skills.

Airflow is the demand leader at 9,996, with a solid $150K median—clear evidence of broad demand for data-engineering workflows.

Golang has an attractive balance: $184K median with 912 demand. It trails Terraform in volume but remains a high-value backend/infrastructure skill.

Niche technologies can pay exceptionally well but offer fewer openings: Neo4j, Zoom, Crystal, FastAPI, and Mongo fall into this pattern. Good for specialists, but potentially less flexibility in job search.

Enterprise/platform ecosystem skills are reliable mid-to-high earners: Spring, GDPR, Bitbucket, Atlassian, VMware, and Ansible generally sit around $149K–$176K, though demand is comparatively limited.

Core web skills have decent salaries but lower demand in this sample: TypeScript ($151K, 388), Node ($150K, 179), CSS ($150K, 262), Django ($155K, 265). That may reflect the dataset’s job mix rather than the overall market.

Best “opportunity” cluster: cloud/platform/data tooling—Terraform, Kubernetes, Airflow, Golang, and likely Ansible—because they pair meaningful demand with strong compensation.

┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ atlassian  │      151500.0 │          249 │
│ c          │      151500.0 │          444 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ node       │      150000.0 │          179 │
│ ruby       │      150000.0 │          736 │
│ airflow    │      150000.0 │         9996 │
│ css        │      150000.0 │          262 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
└────────────┴───────────────┴──────────────┘
  25 rows                         3 columns
/*