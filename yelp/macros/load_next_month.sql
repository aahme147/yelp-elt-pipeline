{% macro load_next_month() %}

    {% set q %}
        select to_char(dateadd(month, 1, to_date(max(batch_id) || '-01')), 'YYYY-MM')
        from yelp_db.raw.review_raw
        where batch_id <> 'history'
    {% endset %}
    {% set next_month = run_query(q).columns[0].values()[0] %}
    {% do log('Loading batch ' ~ next_month, info=True) %}

    {% set copy_sql %}
        copy into yelp_db.raw.review_raw (v, src_file, batch_id)
        from (
            select $1, metadata$filename,
                   regexp_substr(metadata$filename, '[0-9]{4}-[0-9]{2}')
            from @yelp_db.raw.yelp_stage/review/incoming/
        )
        pattern = '.*review_{{ next_month }}[.]json[.]gz'
        file_format = (format_name = 'yelp_db.raw.json_fmt')
    {% endset %}
    {% do run_query(copy_sql) %}

{% endmacro %}