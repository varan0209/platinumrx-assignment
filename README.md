
Run (PostgreSQL):
  psql -d platinumrx -f SQL/01_Hotel_Schema_Setup.sql
  psql -d platinumrx -f SQL/02_Hotel_Queries.sql
  psql -d platinumrx -f SQL/03_Clinic_Schema_Setup.sql
  psql -d platinumrx -f SQL/04_Clinic_Queries.sql

Run (Python):
  python Python/01_Time_Converter.py 130
  python Python/02_Remove_Duplicates.py "balloon"
