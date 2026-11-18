{{ config(
    materialized='incremental',
    unique_key='review_id',
    incremental_strategy='merge'
) }}

with source as (
    select *
    from {{ source('raw', 'review_raw') }}
    {% if is_incremental() %}
    where loaded_at > (select max(loaded_at) from {{ this }})
    {% endif %}
),

deduped as (
    select * from source
    qualify row_number() over (
        partition by v:review_id::string order by loaded_at desc
    ) = 1
),

cleaned as (
    select
        v:review_id::string                          as review_id,
        v:user_id::string                            as user_id,
        v:business_id::string                        as business_id,
        try_to_double(v:stars::string)               as stars,
        try_to_timestamp(v:date::string)             as reviewed_at,
        try_to_number(v:useful::string)              as useful_votes,
        try_to_number(v:funny::string)               as funny_votes,
        try_to_number(v:cool::string)                as cool_votes,
        nullif(trim(v:text::string), '')             as review_text,
        batch_id,
        src_file,
        loaded_at
    from deduped
)

select
    *,
    (stars between 1 and 5)                          as is_valid_stars,
    length(review_text)                              as review_length
from cleaned
where review_id is not null