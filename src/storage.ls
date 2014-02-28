{assert} = require \chai
lo = require 'lodash-node'

export function create-storage-table (plx, schema, table, cb)
  <- plx.query """
  DROP TABLE IF EXISTS #table;
  CREATE TABLE #table (
    name text,
    data json
  );
  """
  cb?!

export function validate-storage-table-exists (plx, schema, table, cb)
  query = """
  SELECT EXISTS(
    SELECT *
    FROM information_schema.tables
    WHERE
      table_schema = '#schema' AND
      table_name = '#table'
  );
  """
  <- plx.query query
  cb? it[0].exists

export function validate-storage-table-schema (plx, schema, table, cb)
  <- plx.query """
  SELECT column_name, data_type
  FROM information_schema.columns
  WHERE
    table_name = '#table'
  """
  if it.length != 2
    cb? false
    return
  unless lo.find(it, (x) -> x.column_name == 'name' and x.data_type == 'text')
    cb? false
    return
  unless lo.find(it, (x) -> x.column_name == 'data' and x.data_type == 'json')
    cb? false
    return
  cb? yes
