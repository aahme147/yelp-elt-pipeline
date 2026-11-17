select c.category, count(*) as reviews, round(avg(f.stars),2) as avg_stars,
       count(distinct f.business_key) as businesses
from {{ ref('fact_review') }} f
join {{ ref('bridge_business_category') }} b using (business_key)
join {{ ref('dim_category') }} c using (category_key)
group by c.category