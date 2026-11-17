with source as (
    select * from {{ source('raw', 'business_raw') }}
),

deduped as (
    select *
    from source
    qualify row_number() over (
        partition by v:business_id::string
        order by loaded_at desc
    ) = 1
),

cleaned as (
    select
        v:business_id::string                                   as business_id,
        nullif(trim(v:name::string), '')                        as business_name,
        nullif(trim(v:address::string), '')                     as address,
        initcap(nullif(trim(v:city::string), ''))               as city,
        upper(nullif(trim(v:state::string), ''))                as state,
        nullif(trim(v:postal_code::string), '')                 as postal_code,
        try_to_double(v:latitude::string)                       as latitude,
        try_to_double(v:longitude::string)                      as longitude,
        try_to_double(v:stars::string)                          as stars,
        try_to_number(v:review_count::string)                   as review_count,
        v:is_open::int = 1                                      as is_open,
        nullif(trim(v:categories::string), '')                  as categories,
        v:attributes                                            as attributes,
        v:hours                                                 as hours,
        src_file,
        loaded_at
    from deduped
)

select
    *,
    (stars between 1 and 5)                                     as is_valid_stars,
    (latitude between -90 and 90 and longitude between -180 and 180) as is_valid_geo
from cleaned
where business_id is not null