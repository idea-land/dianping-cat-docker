#!/bin/sh
# wait-for-mysql.sh

set -e

#host="$1"
#shift
cmd="$@"

until mysqlshow -u ${DATABASE_USER} --password=${DATABASE_PASSWORD} --port 3306 --host ${DATABASE_HOST} ; do
  >&2 echo "mysql is unavailable - sleeping"
  sleep 1
done
>&2 echo "mysql is up - executing command"
exec $cmd