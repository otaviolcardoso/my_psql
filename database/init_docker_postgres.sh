#!/bin/bash

DATABASE_NAME="kw_test"
DB_DUMP_LOCATION="/tmp/psql_data/postgres_seed.sql"

echo "*** CREATING DATABASE ***"

psql -U kwx $DATABASE_NAME < $DB_DUMP_LOCATION; 

echo "*** DATABASE CREATED! ***"
