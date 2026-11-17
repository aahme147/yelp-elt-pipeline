select distinct
    md5(business_id)  as business_key,
    md5(category)     as category_key
from {{ ref('stg_business_categories') }}