select
	table_schema as TABSCHEMA,
	table_name as TABNAME,
	''|| (column_name) || ' as ' ||
    case
		data_type
		when 'uuid' then 'string'
        when 'bigint' then 'long'
		when 'date' then 'date'
		when 'numeric' then 'decimal(' || coalesce(numeric_precision,
		0) || ',' || coalesce(numeric_scale,
		0) || ')'
		when 'double precision' then 'float'
		when 'integer' then 'long'
		when 'timestamp without time zone' then 'timestamp'
		when 'timestamp with time zone' then 'timestamp'
		when 'character varying' then 'string'
		when 'boolean' then 'boolean'
		when 'time without time zone' then 'string'
		when 'jsonb' then 'string'
		when 'text' then 'string'
	end || ',' as dftype,
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