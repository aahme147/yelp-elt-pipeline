with days as (
    select dateadd(day, seq4(), '2004-01-01'::date) as date_day
    from table(generator(rowcount => 9000))
)
select
    to_number(to_char(date_day, 'YYYYMMDD'))  as date_key,
    date_day                                  as date,
    year(date_day)                            as year,
    quarter(date_day)                         as quarter,
    month(date_day)                           as month,
    monthname(date_day)                       as month_name,
    day(date_day)                             as day_of_month,
    dayofweekiso(date_day)                    as day_of_week,
    dayname(date_day)                         as day_name,
    dayofweekiso(date_day) in (6, 7)          as is_weekend
from days
where date_day <= '2028-12-31'