select
    table_schema as TABSCHEMA,
    table_name as TABNAME,
    'StructField("' || upper(column_name) || '", ' ||
    case
        when data_type = 'uuid' then 'StringType()'
        when data_type = 'bigint' then 'LongType()'
        when data_type = 'date' then 'DateType()'
        when data_type = 'numeric' then 
            case 
                when coalesce(numeric_precision, 0) = 0 and coalesce(numeric_scale, 0) = 0 then 'DecimalType(38, 18)'
                else 'DecimalType(' || coalesce(numeric_precision, 0) || ',' || coalesce(numeric_scale, 0) || ')'
            end
        when data_type = 'double precision' then 'FloatType()'
        when data_type = 'integer' then 'LongType()'
        when data_type = 'timestamp without time zone' then 'TimestampType()'
        when data_type = 'timestamp with time zone' then 'TimestampType()'
        when data_type = 'character varying' then 'StringType()'
        when data_type = 'boolean' then 'BooleanType()'
        when data_type = 'time without time zone' then 'TimestampType()'
        when data_type = 'jsonb' then 'StringType()'
        when data_type = 'text' then 'StringType()'
    end || ', True), \' as Struct,
    ordinal_position as COLNO,
    data_type as TYPENAME,
    coalesce(character_maximum_length, numeric_precision) as LENGTH,
    numeric_scale as scale
from
    information_schema.columns
where
    table_name in ('users', 'location', 'labors', 'conveyor_status', 'activity_plan_daily', 'activity_plan_weekly', 'activity_actual_daily', 'labor_activity_plan_daily', 'activity_actual_daily_labors', 'activity_plan_equipments', 'activity_plan_daily_equipments', 'activity_plan_weekly_equipments')
order by
    table_schema,
    table_name,
    ordinal_position;
