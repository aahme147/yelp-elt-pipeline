with source as (
    select * from {{ source('raw', 'user_raw') }}
),

deduped as (
    select * from source
    qualify row_number() over (
        partition by v:user_id::string order by loaded_at desc
    ) = 1
)

select
    v:user_id::string                                as user_id,
    nullif(trim(v:name::string), '')                 as user_name,
    try_to_number(v:review_count::string)            as review_count,
    try_to_timestamp(v:yelping_since::string)        as yelping_since,
    try_to_number(v:useful::string)                  as useful_votes,
    try_to_number(v:funny::string)                   as funny_votes,
    try_to_number(v:cool::string)                    as cool_votes,
    try_to_number(v:fans::string)                    as fans,
    try_to_double(v:average_stars::string)           as average_stars,
    src_file,
    loaded_at
from deduped
where v:user_id::string is not null