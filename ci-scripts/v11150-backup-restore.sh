#!/usr/bin/env bash
# Verify backup and restore ONLY for GitHub CI's disposable thiendo_test DB.
set -Eeuo pipefail
expected='postgresql://thiendo:thiendo_ci_only@127.0.0.1:5432/thiendo_test'
if [[ "${CI:-}" != true || "${DATABASE_URL:-}" != "$expected" ]]; then
  echo 'BLOCKED: refusing backup/restore against any non-disposable target' >&2
  exit 2
fi
for bin in psql pg_dump pg_restore; do command -v "$bin" >/dev/null || { echo "BLOCKED: missing $bin" >&2; exit 2; }; done
suffix="${GITHUB_RUN_ID:-manual}"
[[ "$suffix" =~ ^[0-9]+$ ]] || exit 2
restore_db="thiendo_restore_v11150_$suffix"
restore_url="${expected%/*}/$restore_db"
tmp="$(mktemp -d)"
created=0
cleanup() {
  result=$?
  trap - EXIT
  if [[ "$created" == 1 ]]; then psql "$expected" -q -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS $restore_db WITH (FORCE)" >/dev/null || echo 'WARN: Could not clean up restore database' >&2; fi
  rm -rf "$tmp"
  exit "$result"
}
trap cleanup EXIT
sql_tables="SELECT count(*) FROM pg_tables WHERE schemaname='public'"
sql_names="SELECT md5(string_agg(tablename, ',' ORDER BY tablename)) FROM pg_tables WHERE schemaname='public'"
before_tables="$(psql "$expected" -At -v ON_ERROR_STOP=1 -c "$sql_tables")"
before_migrations="$(psql "$expected" -At -v ON_ERROR_STOP=1 -c 'SELECT count(*) FROM schema_migrations')"
before_names="$(psql "$expected" -At -v ON_ERROR_STOP=1 -c "$sql_names")"
if (( before_tables < 10 || before_migrations < 1 )); then echo 'BLOCKED: migrations/schema prerequisite not met' >&2; exit 2; fi
pg_dump --format=custom --no-owner --no-acl --file="$tmp/backup.dump" "$expected"
test -s "$tmp/backup.dump"
pg_restore --list "$tmp/backup.dump" > "$tmp/archive-list.txt"
psql "$expected" -q -v ON_ERROR_STOP=1 -c "CREATE DATABASE $restore_db" >/dev/null
created=1
pg_restore --no-owner --no-acl --exit-on-error --dbname="$restore_url" "$tmp/backup.dump"
after_tables="$(psql "$restore_url" -At -v ON_ERROR_STOP=1 -c "$sql_tables")"
after_migrations="$(psql "$restore_url" -At -v ON_ERROR_STOP=1 -c 'SELECT count(*) FROM schema_migrations')"
after_names="$(psql "$restore_url" -At -v ON_ERROR_STOP=1 -c "$sql_names")"
if [[ "$before_tables" != "$after_tables" || "$before_migrations" != "$after_migrations" || "$before_names" != "$after_names" ]]; then
  echo 'FAIL: restored table names/schema counts or migration ledger differ' >&2
  exit 1
fi
echo "PASS: disposable PostgreSQL pg_dump/pg_restore — $after_tables tables, $after_migrations migrations."
echo 'Not proof of production offsite backup, PITR or RTO/RPO.'
