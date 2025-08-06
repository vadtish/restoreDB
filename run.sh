#!/bin/bash
set -euo pipefail  # Exit on error, unset variables, and fail on pipeline errors

echo "Waiting for PostgreSQL to be ready..."

# Wait until the PostgreSQL server is accepting connections
until pg_isready -h db -U postgres > /dev/null 2>&1; do
  sleep 1
done

echo "PostgreSQL is up, starting work..."

# Download the backup dump JSON using the ACCESS_TOKEN
curl -s "https://hackattic.com/challenges/backup_restore/problem?access_token=${ACCESS_TOKEN}" -o dump

# Extract base64-encoded dump from JSON
jq -r .dump dump > dump.b64

# Decode base64 and decompress gzip to get the SQL file
base64 -d dump.b64 | gunzip > dump.sql

# Restore the database from the SQL dump
psql -U postgres -d postgres -h db -f dump.sql

# Query alive social security numbers from the database, output plain text, trim whitespace
psql -U postgres -d postgres -h db -t -A -c "SELECT ssn FROM public.criminal_records WHERE status = 'alive';" > result.txt

# Convert newline-separated SSNs to JSON array under key "alive_ssns"
RESPONSE=$(jq -R -s '{alive_ssns: split("\n")[:-1]}' result.txt)

echo "Response JSON: $RESPONSE"

# POST the JSON result to the challenge endpoint
curl -s -X POST "https://hackattic.com/challenges/backup_restore/solve?access_token=${ACCESS_TOKEN}" \
     -H "Content-Type: application/json" \
     -d "$RESPONSE"

# Clean up temporary files
rm -f dump dump.b64 dump.sql result.txt
