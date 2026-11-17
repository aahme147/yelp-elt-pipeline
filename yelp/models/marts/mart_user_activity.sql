{{ config(materialized='table') }}

with r as (
    select user_key,
           count(*)                  as total_reviews_written,
           round(avg(stars), 2)      as avg_stars_given,
           sum(useful_votes)         as total_useful_votes_received
    from {{ ref('fact_review') }}
    group by user_key
),

t as (
    select user_key,
           count(*)                  as total_tips_written,
           sum(compliment_count)     as total_compliments_received
    from {{ ref('fact_tip') }}
    group by user_key
)

select
    u.user_key,
    u.user_id,
    u.user_name,
    u.yelping_since,
    coalesce(r.total_reviews_written, 0)        as total_reviews_written,
    r.avg_stars_given,
    coalesce(r.total_useful_votes_received, 0)  as total_useful_votes_received,
    coalesce(t.total_tips_written, 0)           as total_tips_written,
    coalesce(t.total_compliments_received, 0)   as total_compliments_received
from {{ ref('dim_user') }} u
left join r using (user_key)
left join t using (user_key)