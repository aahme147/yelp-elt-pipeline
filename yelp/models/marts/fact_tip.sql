select
    t.tip_id,
    coalesce(u.user_key, md5('UNKNOWN'))              as user_key,
    md5(t.business_id)                                as business_key,
    to_number(to_char(t.tipped_at::date, 'YYYYMMDD')) as date_key,
    t.tipped_at,
    t.compliment_count,
    length(t.tip_text)                                as tip_length
from {{ ref('stg_tip') }} t
left join {{ ref('dim_user') }} u on u.user_id = t.user_id