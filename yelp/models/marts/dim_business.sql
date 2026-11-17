select
    md5(business_id)                          as business_key,
    business_id,
    business_name,
    address,
    city,
    state,
    postal_code,
    latitude,
    longitude,
    stars,
    review_count,
    is_open,
    split_part(categories, ',', 1)            as primary_category
from {{ ref('stg_business') }}