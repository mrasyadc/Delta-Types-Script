SELECT
    table_schema AS TABSCHEMA,
    table_name AS TABNAME,
    column_name,
    CONCAT(column_name, ' as ',
        CASE
            -- All integer types become 'long'
            WHEN data_type IN ('bigint', 'int', 'smallint', 'tinyint') THEN 'long'
            
            -- Bit becomes boolean
            WHEN data_type IN ('bit') THEN 'boolean'
            
            -- Floating types become decimal
            WHEN data_type IN ('float', 'real') THEN 
                'decimal(' || 
                COALESCE(CAST(numeric_precision AS VARCHAR), '38') || 
                ',' || 
                COALESCE(CAST(numeric_scale AS VARCHAR), '18') || 
                ')'
            
            -- Decimal types keep their original precision/scale
            WHEN data_type IN ('decimal', 'numeric') THEN
                CASE 
                    WHEN COALESCE(numeric_precision, 0) = 0 AND COALESCE(numeric_scale, 0) = 0 THEN 'decimal(38,18)'
                    ELSE 'decimal(' || COALESCE(CAST(numeric_precision AS VARCHAR), '0') || ',' || COALESCE(CAST(numeric_scale AS VARCHAR), '0') || ')'
                END
            
            -- String types
            WHEN data_type IN ('uniqueidentifier', 'varchar', 'nvarchar', 'json', 'text', 'ntext', 'char', 'nchar') THEN 'string'
            
            -- Date/time types
            WHEN data_type IN ('date') THEN 'date'
            WHEN data_type IN ('datetime', 'datetime2', 'smalldatetime') THEN 'timestamp'
            WHEN data_type IN ('time') THEN 'string'  -- ADF doesn't support time directly
            
            -- Binary types
            WHEN data_type IN ('binary', 'varbinary', 'image') THEN 'binary'
            
            -- Fallback to string
            ELSE 'string'
        END
    ) AS dftype,
    ordinal_position AS COLNO,
    data_type AS original_type,
    COALESCE(character_maximum_length, numeric_precision) AS LENGTH,
    numeric_scale AS scale
FROM
    information_schema.COLUMNS
WHERE
    table_name IN ('MM_BRANDCATEGORY')  -- Add your tables/views here
ORDER BY
    table_schema,
    table_name,
    ordinal_position;
