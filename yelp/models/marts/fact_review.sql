select
    r.review_id,
    coalesce(u.user_key, md5('UNKNOWN'))              as user_key,
    md5(r.business_id)                                as business_key,
    to_number(to_char(r.reviewed_at::date, 'YYYYMMDD')) as date_key,
    r.reviewed_at,
    r.stars,
    r.useful_votes,
    r.funny_votes,
    r.cool_votes,
    r.review_length
from {{ ref('stg_review') }} r
left join {{ ref('dim_user') }} u on u.user_id = r.user_id