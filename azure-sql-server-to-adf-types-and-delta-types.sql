SELECT
    table_schema AS TABSCHEMA,
    table_name AS TABNAME,
    column_name,
    CONCAT(column_name, ' as ',
        CASE
            WHEN data_type IN ('bigint', 'int', 'smallint', 'tinyint') THEN 'long'
            WHEN data_type IN ('bit') THEN 'boolean'
            WHEN data_type IN ('float', 'real') THEN 
                'decimal(' + 
                COALESCE(CAST(numeric_precision AS VARCHAR), '38') + 
                ',' + 
                COALESCE(CAST(numeric_scale AS VARCHAR), '18') + 
                ')'
            WHEN data_type IN ('decimal', 'numeric') THEN
                CASE 
                    WHEN COALESCE(numeric_precision, 0) = 0 AND COALESCE(numeric_scale, 0) = 0 THEN 'decimal(38,18)'
                    ELSE 'decimal(' + COALESCE(CAST(numeric_precision AS VARCHAR), '0') + ',' + COALESCE(CAST(numeric_scale AS VARCHAR), '0') + ')'
                END
            WHEN data_type IN ('uniqueidentifier', 'varchar', 'nvarchar', 'json', 'text', 'ntext', 'char', 'nchar') THEN 'string'
            WHEN data_type IN ('date') THEN 'date'
            WHEN data_type IN ('datetime', 'datetime2', 'smalldatetime') THEN 'timestamp'
            WHEN data_type IN ('time') THEN 'string'
            WHEN data_type IN ('binary', 'varbinary', 'image') THEN 'binary'
            ELSE 'string'
        END
    ) AS dftype,
    ordinal_position AS COLNO,
    data_type AS original_type,
    COALESCE(character_maximum_length, numeric_precision) AS LENGTH,
    numeric_scale AS scale,
    -- Updated struct_field with precision/scale for DecimalType
    CONCAT(
        'StructField("', 
        column_name, 
        '", ',
        CASE
            WHEN data_type IN ('bigint', 'int', 'smallint', 'tinyint') THEN 'LongType()'
            WHEN data_type = 'bit' THEN 'BooleanType()'
            WHEN data_type IN ('varchar', 'nvarchar', 'text', 'ntext', 'char', 'nchar', 'uniqueidentifier', 'json', 'time') THEN 'StringType()'
            WHEN data_type IN ('datetime', 'datetime2', 'smalldatetime') THEN 'TimestampType()'
            WHEN data_type = 'date' THEN 'DateType()'
            WHEN data_type IN ('binary', 'varbinary', 'image') THEN 'BinaryType()'
            -- Handle DecimalType with precision/scale
            WHEN data_type IN ('float', 'real') THEN 
                'DecimalType(' + 
                COALESCE(CAST(numeric_precision AS VARCHAR), '38') + 
                ',' + 
                COALESCE(CAST(numeric_scale AS VARCHAR), '18') + 
                ')'
            WHEN data_type IN ('decimal', 'numeric') THEN
                CASE 
                    WHEN COALESCE(numeric_precision, 0) = 0 AND COALESCE(numeric_scale, 0) = 0 
                        THEN 'DecimalType(38,18)'
                    ELSE 
                        'DecimalType(' + 
                        COALESCE(CAST(numeric_precision AS VARCHAR), '0') + 
                        ',' + 
                        COALESCE(CAST(numeric_scale AS VARCHAR), '0') + 
                        ')'
                END
            ELSE 'StringType()'
        END,
        ', True), \'  -- Maintain backslash for line continuation
    ) AS struct_field
FROM
    information_schema.COLUMNS
WHERE
    table_name IN ('ANALYSISJOB',
'ANALYSISRESULT',
'HAULINGREQUEST',
'HAULINGREQUEST_DETAIL_PORTIONBLENDING',
'LOADING_REQUEST_BLU',
'LOADING_REQUEST_BLU_BARGE',
'LOADING_REQUEST_BLU_BARGE_PRODUCT',
'LOADING_REQUEST_LOADING_PLAN',
'SAMPLE',
'SAMPLEDETAILGENERAL',
'SAMPLEDETAILLOADING',
'SAMPLESCHEME',
'SCHEME',
'TUNNEL',
'UPLOAD_SAMPLING_ROM')
ORDER BY
    table_schema,
    table_name,
    ordinal_position;
