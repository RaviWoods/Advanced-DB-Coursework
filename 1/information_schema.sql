-- List all tables in the public (default) schema of the database
SELECT table_name
FROM   information_schema.tables
WHERE  table_schema='public';

-- List all columns are their datatypes in the public schema
SELECT tables.table_name,
       column_name,
       data_type,
       is_nullable
FROM   information_schema.tables 
       JOIN information_schema.columns 
       ON   information_schema.tables.table_name=information_schema.columns.table_name
WHERE  tables.table_schema='public'
ORDER BY tables.table_name,
       ordinal_position;

-- List the primary key of all tables in the public schema
SELECT table_constraints.constraint_name,
       table_constraints.table_name,
       column_name
FROM   information_schema.table_constraints 
       JOIN information_schema.key_column_usage
       ON   table_constraints.constraint_name=key_column_usage.constraint_name
WHERE  table_constraints.constraint_type='PRIMARY KEY'
AND    table_constraints.constraint_schema='public'
ORDER BY table_name;

-- List foreign keys of all tables in the public schema
SELECT foreign_key.constraint_name,
       foreign_key.table_name AS fk_table,
       fk_column_usage.column_name AS fk_column,
       primary_key.table_name AS pk_table,
       pk_column_usage.column_name AS pk_column
FROM   information_schema.table_constraints AS foreign_key
       JOIN information_schema.key_column_usage AS fk_column_usage
       ON   foreign_key.constraint_name=fk_column_usage.constraint_name
       JOIN information_schema.referential_constraints
       ON   foreign_key.constraint_name=referential_constraints.constraint_name
       JOIN information_schema.table_constraints AS primary_key
       ON   referential_constraints.unique_constraint_name=primary_key.constraint_name
       JOIN information_schema.key_column_usage AS pk_column_usage
       ON   primary_key.constraint_name=pk_column_usage.constraint_name
       AND  pk_column_usage.ordinal_position=fk_column_usage.ordinal_position
WHERE  foreign_key.constraint_type='FOREIGN KEY'
AND    foreign_key.constraint_schema='public'
ORDER BY foreign_key.table_name;
