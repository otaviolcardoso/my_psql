#!/usr/bin/env sh
 
DB_DUMP_LOCATION="postgres_seed.sql"
export PGPASSWORD=$POSTGRES_PASSWORD

if [ -f replicated.txt ]; then
  echo "PSQL schema has already been created"
else
  echo "Wait for PSQL to accept connections..."
  sleep 8
  psql -U $POSTGRES_USER -h $DATABASE_HOST $POSTGRES_DB < $DB_DUMP_LOCATION; 
  echo "Dump done..."
  touch replicated.txt
fi