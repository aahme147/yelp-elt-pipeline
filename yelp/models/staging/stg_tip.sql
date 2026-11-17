with source as (
    select * from {{ source('raw', 'tip_raw') }}
),

cleaned as (
    select
        v:user_id::string                            as user_id,
        v:business_id::string                        as business_id,
        nullif(trim(v:text::string), '')             as tip_text,
        try_to_timestamp(v:date::string)             as tipped_at,
        try_to_number(v:compliment_count::string)    as compliment_count,
        src_file,
        loaded_at
    from source
),

deduped as (
    select *
    from cleaned
    where user_id is not null
      and business_id is not null
      and tipped_at is not null
    qualify row_number() over (
        partition by user_id, business_id, tipped_at
        order by loaded_at desc
    ) = 1
)

select
    md5(user_id || '|' || business_id || '|' || to_varchar(tipped_at)) as tip_id,
    *
from deduped