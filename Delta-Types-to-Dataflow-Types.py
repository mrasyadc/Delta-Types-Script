import re

def convert_struct_fields(struct_fields: str) -> str:
    type_mapping = {
        "StringType()": "string",
        "DecimalType(": "decimal(",
        "DateType()": "date",
        "TimestampType()": "timestamp",
        "LongType()": "long",
        "FloatType()": "float",
        "IntegerType()": "integer",
    }
    
    # Regex pattern to extract field name and type
    pattern = re.compile(r'StructField\("(.*?)",(.*?),True\)')
    
    result_lines = []
    for match in pattern.finditer(struct_fields):
        field_name, field_type = match.groups()
        
        # Replace field type using the mapping
        for key, value in type_mapping.items():
            if key in field_type:
                field_type = field_type.replace(key, value)
                break
        
        result_lines.append(f"{field_name} as {field_type}")
    
    return ",\n".join(result_lines)

# Example input
input_text = 
    """
    StructField("PONUM",StringType(),True), \
    StructField("ITEMNUM",StringType(),True), \
    StructField("STORELOC",StringType(),True), \
    StructField("MODELNUM",StringType(),True), \
    StructField("CATALOGCODE",StringType(),True), \
    """

# Convert and print output
converted_text = convert_struct_fields(input_text)
print(converted_text)
