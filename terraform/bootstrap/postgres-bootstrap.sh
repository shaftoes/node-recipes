set -e
su -s /bin/bash postgres -c psql < /tmp/bootstrap/postgres.sql
