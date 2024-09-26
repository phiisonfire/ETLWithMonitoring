PGPASSWORD=password123 psql -U admin -d postgres -c '\q'
DB_EXIST=$(PGPASSWORD=password123 psql -U admin -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='dvdrental'")


step 1: setup spark cluster
step 2: setup postgres database
step 3: setup datalake (HDFS)
step 4: pipeline1: postgres -ingestion-> raw