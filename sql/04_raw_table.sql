USE ROLE ACCOUNTADMIN;
USE WAREHOUSE yelp_wh;
USE DATABASE yelp_db;
USE SCHEMA raw;

CREATE TABLE IF NOT EXISTS business_raw (
  v VARIANT,
  src_file STRING,
  loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

COPY INTO business_raw (v, src_file)
FROM (SELECT $1, METADATA$FILENAME FROM @yelp_stage/business/)
FILE_FORMAT = (FORMAT_NAME = 'yelp_db.raw.json_fmt');

SELECT COUNT(*) FROM business_raw;
SELECT v:business_id::string AS business_id, v:name::string AS name, v:city::string AS city
FROM business_raw LIMIT 5;

CREATE TABLE IF NOT EXISTS checkin_raw (v VARIANT, src_file STRING, loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP());
CREATE TABLE IF NOT EXISTS tip_raw     (v VARIANT, src_file STRING, loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP());
CREATE TABLE IF NOT EXISTS review_raw  (v VARIANT, src_file STRING, loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP());
CREATE TABLE IF NOT EXISTS user_raw    (v VARIANT, src_file STRING, loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP());

COPY INTO checkin_raw (v, src_file) FROM (SELECT $1, METADATA$FILENAME FROM @yelp_stage/checkin/) FILE_FORMAT = (FORMAT_NAME = 'yelp_db.raw.json_fmt');
COPY INTO tip_raw     (v, src_file) FROM (SELECT $1, METADATA$FILENAME FROM @yelp_stage/tip/)     FILE_FORMAT = (FORMAT_NAME = 'yelp_db.raw.json_fmt');


COPY INTO review_raw (v, src_file) FROM (SELECT $1, METADATA$FILENAME FROM @yelp_stage/review/) FILE_FORMAT = (FORMAT_NAME = 'yelp_db.raw.json_fmt');
COPY INTO user_raw   (v, src_file) FROM (SELECT $1, METADATA$FILENAME FROM @yelp_stage/user/)   FILE_FORMAT = (FORMAT_NAME = 'yelp_db.raw.json_fmt');

SELECT 'review' AS t, COUNT(*) FROM review_raw   
UNION ALL
SELECT 'user', COUNT(*) FROM user_raw;           


