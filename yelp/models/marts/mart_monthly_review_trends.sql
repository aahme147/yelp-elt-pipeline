select d.year, d.month, count(*) as reviews,
       round(avg(f.stars),2) as avg_stars,
       count(distinct f.business_key) as active_businesses
from {{ ref('fact_review') }} f
join {{ ref('dim_date') }} d using (date_key)
group by d.year, d.month