with r as (
    select business_key, count(*) as review_count,
           avg(stars) as avg_review_stars, sum(useful_votes) as useful_votes
    from {{ ref('fact_review') }} group by 1
),
c as (select business_key, count(*) as checkin_count from {{ ref('fact_checkin') }} group by 1),
t as (select business_key, count(*) as tip_count from {{ ref('fact_tip') }} group by 1)
select b.business_key, b.business_name, b.city, b.state, b.primary_category, b.is_open,
       coalesce(r.review_count,0)  as review_count,
       r.avg_review_stars,
       coalesce(c.checkin_count,0) as checkin_count,
       coalesce(t.tip_count,0)     as tip_count
from {{ ref('dim_business') }} b
left join r using (business_key)
left join c using (business_key)
left join t using (business_key)