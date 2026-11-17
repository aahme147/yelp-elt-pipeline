USE ROLE ACCOUNTADMIN;
USE DATABASE yelp_db;
USE SCHEMA raw;

CREATE OR REPLACE FILE FORMAT yelp_db.raw.json_fmt
  TYPE = JSON
  COMPRESSION = AUTO
  STRIP_OUTER_ARRAY = FALSE;

CREATE OR REPLACE STAGE yelp_db.raw.yelp_stage
  URL = 's3://ayan-yelp-raw-2026/yelp/raw/'
  STORAGE_INTEGRATION = yelp_s3_int
  FILE_FORMAT = yelp_db.raw.json_fmt;

LIST @yelp_db.raw.yelp_stage;