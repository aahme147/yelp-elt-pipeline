select
    b.business_id,
    trim(c.value::string) as category
from {{ ref('stg_business') }} b,
     lateral flatten(input => split(b.categories, ',')) c
where b.categories is not null
  and trim(c.value::string) <> ''