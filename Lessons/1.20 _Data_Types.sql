select 
table_name, column_name, data_type
from information_schema.columns
where table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;



