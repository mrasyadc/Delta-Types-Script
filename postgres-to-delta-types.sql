select
	table_schema as TABSCHEMA,
	table_name as TABNAME,
	'StructField("' || upper(column_name) || '", ' ||
    case
		data_type
		when 'uuid' then 'StringType()'
        when 'bigint' then 'LongType()'
		when 'date' then 'DateType()'
		when 'numeric' then 'DecimalType(' || coalesce(numeric_precision,
		0) || ',' || coalesce(numeric_scale,
		0) || ')'
		when 'double precision' then 'FloatType()'
		when 'integer' then 'LongType()'
		when 'timestamp without time zone' then 'TimestampType()'
		when 'timestamp with time zone' then 'TimestampType()'
		when 'character varying' then 'StringType()'
		when 'boolean' then 'BooleanType()'
		when 'time without time zone' then 'TimestampType()'
		when 'jsonb' then 'StringType()'
		when 'text' then 'StringType()'
	end || ', True), \' as Struct,
	ordinal_position as COLNO,
	data_type as TYPENAME,
	coalesce(character_maximum_length,
	numeric_precision) as LENGTH,
	numeric_scale as scale
from
	information_schema.columns
where
	table_name in ('users', 'locations', 'labors', 'conveyor_status', 'activity_plan_daily', 'activity_plan_weekly', 'activity_actual_daily', 'labor_activity_plan_daily', 'activity_actual_daily_labors', 'activity_plan_equipments', 'activity_plan_daily_equipments', 'activity_plan_weekly_equipments')
order by
	table_schema,
	table_name,
	ordinal_position;
