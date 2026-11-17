with source as (
    select * from {{ source('raw', 'checkin_raw') }}
),

flattened as (
    select
        v:business_id::string                        as business_id,
        try_to_timestamp(trim(d.value::string))      as checkin_at,
        s.src_file,
        s.loaded_at
    from source s,
         lateral flatten(input => split(s.v:date::string, ',')) d
)

select distinct
    business_id,
    checkin_at,
    src_file,
    loaded_at
from flattened
where business_id is not null
  and checkin_at is not null