{{ config(
    materialized='incremental',
    unique_key='review_id',
    incremental_strategy='merge'
) }}

select
    r.review_id,
    coalesce(u.user_key, md5('UNKNOWN'))                  as user_key,
    md5(r.business_id)                                    as business_key,
    to_number(to_char(r.reviewed_at::date, 'YYYYMMDD'))   as date_key,
    r.reviewed_at,
    r.stars,
    r.useful_votes,
    r.funny_votes,
    r.cool_votes,
    r.review_length,
    r.batch_id,
    r.loaded_at
from {{ ref('stg_review') }} r
left join {{ ref('dim_user') }} u on u.user_id = r.user_id
{% if is_incremental() %}
where r.loaded_at > (select max(loaded_at) from {{ this }})
{% endif %}