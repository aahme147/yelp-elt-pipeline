select
    md5(business_id)                                  as business_key,
    to_number(to_char(checkin_at::date, 'YYYYMMDD'))  as date_key,
    checkin_at
from {{ ref('stg_checkin') }}