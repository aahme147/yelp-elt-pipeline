select
    md5(user_id)      as user_key,
    user_id,
    user_name,
    yelping_since,
    review_count,
    fans,
    average_stars
from {{ ref('stg_user') }}

union all

select
    md5('UNKNOWN'), 'UNKNOWN', 'Unknown user', null, null, null, null