#!/bin/bash
set -e

echo "Waiting for PostgreSQL to be ready..."

until pg_isready -h db -U postgres; do
  sleep 1
done

echo "PostgreSQL is up, starting work..."

curl "https://hackattic.com/challenges/backup_restore/problem?access_token=${ACCESS_TOKEN}" > dump

jq -r .dump dump > dump.b64
base64 -d dump.b64 > dump.sql.gz
gunzip dump.sql.gz

psql -U postgres -d postgres -h db -f dump.sql

psql -U postgres -d postgres -h db -c "SELECT ssn FROM public.criminal_records WHERE status = 'alive';" -t -A > result.txt

RESPONSE=$(jq -R -s '{alive_ssns: split("\n")[:-1]}' result.txt)
echo "Response JSON: $RESPONSE"

curl -X POST "https://hackattic.com/challenges/backup_restore/solve?access_token=${ACCESS_TOKEN}" \
     -H "Content-Type: application/json" \
     -d "$RESPONSE"
rm dump.sql result.txt
