select *
FROM information_schema.schemata;

use jobs_mart;

--CREATE SCHEMA staging;

CREATE TABLE jobs_mart.staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR(100),
);

INSERT INTO jobs_mart.staging.preferred_roles (role_id, role_name)
VALUES

    (1, 'Data Scientist'),
    (2, 'Data Engineer'),
    (3, 'Machine Learning Engineer'),
    (4, 'Business Analyst'),
    (5, 'Data Analyst');

SELECT *
FROM jobs_mart.staging.preferred_roles;

ALTER TABLE jobs_mart.staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

UPDATE jobs_mart.staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id IN (1, 2, 3)
;

UPDATE jobs_mart.staging.priority_roles
SET priority_lvl = TRUE
WHERE priority_lvl IS NOT NULL;

ALTER TABLE jobs_mart.staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE jobs_mart.staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

SELECT *
FROM jobs_mart.staging.priority_roles;

ALTER TABLE jobs_mart.staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

ALTER TABLE jobs_mart.staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

SELECT *
FROM jobs_mart.staging.priority_roles;

UPDATE jobs_mart.staging.priority_roles
SET priority_lvl = FALSE
WHERE priority_lvl IS NULL;


UPDATE jobs_mart.staging.priority_roles
SET priority_lvl = TRUE
WHERE role_id IN (1, 2, 3)
;