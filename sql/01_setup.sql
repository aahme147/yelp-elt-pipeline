USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE IF NOT EXISTS yelp_wh
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Database + medallion schemas
CREATE DATABASE IF NOT EXISTS yelp_db;
CREATE SCHEMA IF NOT EXISTS yelp_db.raw;        -- Bronze: COPY INTO lands JSON here
CREATE SCHEMA IF NOT EXISTS yelp_db.staging;    -- Silver: cleaned / flattened (dbt)
CREATE SCHEMA IF NOT EXISTS yelp_db.marts;      -- Gold: star schema (dbt)
CREATE SCHEMA IF NOT EXISTS yelp_db.snapshots;  -- SCD2 history (dbt snapshots)
CREATE SCHEMA IF NOT EXISTS yelp_db.ai;         -- LLM-enriched tables (OpenAI jobs)

-- Role that dbt / Airflow will use
CREATE ROLE IF NOT EXISTS dbt_role;
GRANT USAGE   ON WAREHOUSE yelp_wh TO ROLE dbt_role;
GRANT OPERATE ON WAREHOUSE yelp_wh TO ROLE dbt_role;
GRANT ALL ON DATABASE yelp_db TO ROLE dbt_role;
GRANT ALL ON ALL SCHEMAS IN DATABASE yelp_db TO ROLE dbt_role;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE yelp_db TO ROLE dbt_role;
GRANT ALL ON FUTURE TABLES IN DATABASE yelp_db TO ROLE dbt_role;
GRANT ALL ON FUTURE VIEWS IN DATABASE yelp_db TO ROLE dbt_role;

-- Let your login use the role
SET my_user = CURRENT_USER();
GRANT ROLE dbt_role TO USER IDENTIFIER($my_user);

-- Credit safety net
CREATE RESOURCE MONITOR IF NOT EXISTS yelp_monitor
  WITH CREDIT_QUOTA = 50
  TRIGGERS ON 80 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND;
ALTER ACCOUNT SET RESOURCE_MONITOR = yelp_monitor;

SELECT 'setup complete' AS status, CURRENT_ACCOUNT() AS account, CURRENT_REGION() AS region;

SHOW SCHEMAS IN DATABASE yelp_db;
SHOW GRANTS TO ROLE dbt_role;