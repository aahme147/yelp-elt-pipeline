select
    md5(category)     as category_key,
    category
from {{ ref('stg_business_categories') }}
group by category