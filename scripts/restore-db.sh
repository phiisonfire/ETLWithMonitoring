#!/bin/bash

# Variables
DB_NAME="dvdrental"
BACKUP_FILE="/data/dvdrental.tar"  # Use the backup file location
PG_USER="admin"
PG_PASSWORD="password123"
PG_HOST="postgres"
PG_PORT="5432"

# Function to check if PostgreSQL is ready
function wait_for_postgres() {
    echo "Waiting for PostgreSQL to start..."
    until PGPASSWORD=$PG_PASSWORD psql -U $PG_USER -d postgres -c '\q'; do
        echo "PostgreSQL is unavailable - sleeping"
        sleep 2
    done
    echo "PostgreSQL is up!"
}

# Wait for PostgreSQL to start
# wait_for_postgres
sleep 10

# Check if the database already exists
DB_EXIST=$(PGPASSWORD=$PG_PASSWORD psql -U $PG_USER -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")

if [ "$DB_EXIST" == "1" ]; then
    echo "Database $DB_NAME already exists. Skipping restore."
else
    echo "Database $DB_NAME does not exist. Proceeding with restore..."

    # Check if the backup file exists
    if [ -f "$BACKUP_FILE" ]; then
        echo "Backup file found. Restoring database..."

        # Create the database first
        createdb -U $PG_USER $DB_NAME

        # Restore the database
        pg_restore -U $PG_USER -d $DB_NAME "$BACKUP_FILE"

        echo "Database restore completed."
    else
        echo "Backup file not found. Skipping restore."
    fi
fi