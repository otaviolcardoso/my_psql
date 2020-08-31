#!/usr/bin/env sh
 
DB_SCHEMA_LOCATION="postgres_schema.sql"
export PGPASSWORD=$POSTGRES_PASSWORD

if [ -f replicated.txt ]; then
  echo "PSQL schema has already been created"
else

  echo "Wait for PSQL to accept connections..."
  sleep 5
  psql -U $POSTGRES_USER -h $DATABASE_HOST $POSTGRES_DB < $DB_SCHEMA_LOCATION; 
  echo "Schema done..."
  touch replicated.txt
fi
