#!/usr/bin/env bash

test -f /run/secrets/DATABASE_PASSWORD && DATABASE_PASSWORD=$(cat /run/secrets/DATABASE_PASSWORD)
test -f /run/secrets/PK &&  DATABASE_PASSWORD=$(echo "${DATABASE_PASSWORD}" | base64 -d|openssl des3 -d -k "$(cat /run/secrets/PK)");

start=$SECONDS
end=$((SECONDS+${WAIT_MAX_SECONDS:-30}));
until mysqlshow -u ${DATABASE_USER} --password=${DATABASE_PASSWORD} --port 3306 --host ${DATABASE_HOST} ; do
 if [  $SECONDS -gt $end ] ; then
   echo "check timeout:$end !";
   exit 1;
 fi
  >&2 echo "mysql is unavailable - sleeping"
  sleep 1
done
>&2 echo "mysql is up - startApp..."

if [ ! -f /data/appdatas/inited ] ; then
RESULT=`mysqlshow -u ${DATABASE_USER} --password=${DATABASE_PASSWORD} --port 3306 --host ${DATABASE_HOST} cat | grep -v Wildcard | grep -o dailygraph`
if [ "$RESULT" != "dailygraph" ]; then
    mysql -u ${DATABASE_USER} --password=${DATABASE_PASSWORD} --port 3306 --host ${DATABASE_HOST} < /app/Cat.sql
    echo 'Init database from Cat.sql'
fi

sed -i "s/jdbcHost/$DATABASE_HOST/g" /data/appdatas/cat/datasources.xml
sed -i "s/jdbcUser/$DATABASE_USER/g" /data/appdatas/cat/datasources.xml
sed -i "s/jdbcPassword/$DATABASE_PASSWORD/g" /data/appdatas/cat/datasources.xml
 echo "init at:$(date)" >> /data/appdatas/inited
fi
catalina.sh run