SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1000000, 2) AS optimal_score
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
Terraform is the standout high-value specialization: highest score (0.97) and salary ($184K), though demand is lower (193). Best for compensation, less so for job-volume safety.

Python is the strongest all-rounder: highest practical blend of demand (1,133, the most in the table) and salary ($135K), earning the second-best score (0.95).

SQL is essential, not optional: virtually tied with Python in demand (1,128) and scores very highly (0.91). Its salary is slightly lower ($130K), but it offers broad employability.

Cloud skills are consistently valuable:
- AWS: $137K, 783 demand, 0.91
- Azure: $128K, 475 demand, 0.79
- GCP: $136K, 196 demand, 0.72
  AWS has the strongest balance here; Azure has more demand than GCP but lower median pay.

The data-engineering stack is especially strong: Airflow, Spark, Kafka, Snowflake, Databricks, Redshift, PySpark, and BigQuery all appear. Airflow is the leader in this group: $150K, 386 demand, 0.89.

Best skill combinations to pursue:
- Broad, resilient path: Python + SQL + AWS
- Data engineering: Python + SQL + Airflow + Spark + Kafka
- Cloud/platform engineering: Terraform + AWS + Kubernetes + Docker
- Modern analytics platform: Snowflake or Databricks + Spark + SQL

Kubernetes has high pay but limited count in this sample: $150.5K median, but only 147 demand, placing it mid-table on the composite score. It is valuable as a complement to cloud/IaC skills rather than as a sole focus.

Legacy-adjacent skills show weaker opportunity balance: Hadoop and R are still paid reasonably well, but their lower composite scores suggest they are less attractive than newer alternatives such as Spark, Databricks, Snowflake, and Airflow.

Interpret optimal_score as a balance metric, not a salary ranking: it favors the trade-off between pay and job volume. That is why Python and SQL outrank several higher-paying but scarcer skills.

┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │             5.3 │          0.97 │
│ python     │      135000.0 │         1133 │             7.0 │          0.95 │
│ sql        │      130000.0 │         1128 │             7.0 │          0.91 │
│ aws        │      137320.0 │          783 │             6.7 │          0.91 │
│ airflow    │      150000.0 │          386 │             6.0 │          0.89 │
│ spark      │      140000.0 │          503 │             6.2 │          0.87 │
│ kafka      │      145000.0 │          292 │             5.7 │          0.82 │
│ snowflake  │      135500.0 │          438 │             6.1 │          0.82 │
│ azure      │      128000.0 │          475 │             6.2 │          0.79 │
│ java       │      135000.0 │          303 │             5.7 │          0.77 │
│ scala      │      137290.0 │          247 │             5.5 │          0.76 │
│ git        │      140000.0 │          208 │             5.3 │          0.75 │
│ kubernetes │      150500.0 │          147 │             5.0 │          0.75 │
│ databricks │      132750.0 │          266 │             5.6 │          0.74 │
│ redshift   │      130000.0 │          274 │             5.6 │          0.73 │
│ gcp        │      136000.0 │          196 │             5.3 │          0.72 │
│ nosql      │      134415.0 │          193 │             5.3 │          0.71 │
│ hadoop     │      135000.0 │          198 │             5.3 │          0.71 │
│ pyspark    │      140000.0 │          152 │             5.0 │           0.7 │
│ mongodb    │      135750.0 │          136 │             4.9 │          0.67 │
│ docker     │      135000.0 │          144 │             5.0 │          0.67 │
│ r          │      134775.0 │          133 │             4.9 │          0.66 │
│ go         │      140000.0 │          113 │             4.7 │          0.66 │
│ github     │      135000.0 │          127 │             4.8 │          0.65 │
│ bigquery   │      135000.0 │          123 │             4.8 │          0.65 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
  25 rows                                                           5 columns
/*