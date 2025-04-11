SELECT
    table_schema AS TABSCHEMA,
    table_name AS TABNAME,
    column_name,
    CONCAT(column_name, ' as ',
        CASE
            WHEN data_type IN ('uniqueidentifier', 'varchar', 'nvarchar', 'json', 'text', 'ntext') THEN 'string'
            WHEN data_type IN ('bigint') THEN 'long'
            WHEN data_type IN ('int') THEN 'integer'
            WHEN data_type IN ('smallint', 'tinyint') THEN 'short'
            WHEN data_type IN ('bit') THEN 'boolean'
            WHEN data_type IN ('float', 'real') THEN 'float'
            WHEN data_type = 'decimal' OR data_type = 'numeric' THEN
                CASE 
                    WHEN COALESCE(numeric_precision, 0) = 0 AND COALESCE(numeric_scale, 0) = 0 THEN 'decimal(38,18)'
                    ELSE CONCAT('decimal(', COALESCE(numeric_precision, 0), ',', COALESCE(numeric_scale, 0), ')')
                END
            WHEN data_type IN ('date') THEN 'date'
            WHEN data_type IN ('datetime', 'datetime2', 'smalldatetime') THEN 'timestamp'
            WHEN data_type IN ('time') THEN 'string' -- ADF doesn't support time directly
            WHEN data_type IN ('binary', 'varbinary', 'image') THEN 'binary'
            ELSE 'string' -- fallback
        END
    ) AS dftype,
    ordinal_position AS COLNO,
    data_type AS original_type,
    COALESCE(character_maximum_length, numeric_precision) AS LENGTH,
    numeric_scale AS scale
FROM
    information_schema.COLUMNS c
WHERE
    table_name IN (
        'MM_BRANDCATEGORY'
    )
ORDER BY
    table_schema,
    table_name,
    ordinal_position;
