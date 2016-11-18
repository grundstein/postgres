#!/bin/bash

IP=172.18.0.3
# autogenerated postgres pass
SU_PASS=sP8cyls1PY7467RlB+ssawOK7OOiq1pH5H1J9OQVwhto4nLlJKyPoL9
# postgres user settings
SU_USER=postgres
# postgres management database, service will create their own databases
DB=postgres
# postgres host settings
HOST_PORT=5432
# postgres container settings
CONTAINER_NAME=magic-postgres
# this is the internal port of the container
CONTAINER_PORT=5432
# the container internal directory the postgres data will be stored in
PGDATA=/home/data/postgresql
# backup dir
DATA_DIR=/home/j/dev/grundstein/legung/bin/../../data

# gitlab data
GITLAB_DB_USER=gitlab
GITLAB_DB_PASS=O3uNxK5ZnWPXFlJ+Ztf847ruaYj80GU+yynyVyoISYCV84lOS79g2L0
GITLAB_DB_NAME=gitlabhq_production

# gitlab data
REDMINE_DB_USER=redmine
REDMINE_DB_PASS=U1grqTLRygtkoDnoK7ZETX3SpZVTxmSr2+vLShFmR1O51eSKnMtBfSk
REDMINE_DB_NAME=redmine_production
REDMINE_DB_PORT=5432


echo "container: $CONTAINER_NAME"

function build {
  docker build \
  --tag=$CONTAINER_NAME \
  . # dot!
}

function run() {
  # remove container first
  docker run \
    --detach \
    --name $CONTAINER_NAME \
    --env "POSTGRES_PASSWORD=$SU_PASS" \
    --env "POSTGRES_USER=$SU_USER" \
    --env "DB=$DB" \
    --env "SU_PASS=$SU_PASS" \
    --env "SU_USER=$SU_USER" \
    --env "PGDATA=$PGDATA" \
    --env "GITLAB_DB_USER=$GITLAB_DB_USER" \
    --env "GITLAB_DB_PASS=$GITLAB_DB_PASS" \
    --env "GITLAB_DB_NAME=$GITLAB_DB_NAME" \
    --env "REDMINE_DB_USER=$REDMINE_DB_USER" \
    --env "REDMINE_DB_PASS=$REDMINE_DB_PASS" \
    --env "REDMINE_DB_NAME=$REDMINE_DB_NAME" \
    --volume $DATA_DIR/postgres/data:/home/data/postgresql \
    --publish $HOST_PORT:$CONTAINER_PORT \
    --network user-defined \
    --ip $IP \
    $CONTAINER_NAME
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi
