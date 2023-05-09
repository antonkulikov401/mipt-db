#!/usr/bin/env bash

echo 'Starting ClickHouse server in docker container...'
docker run -d \
    --name ch-server \
    --ulimit nofile=262144:262144 \
    -v $(realpath ./ch_data):/var/lib/clickhouse/ \
    clickhouse/clickhouse-server
sleep 1

echo 'Creating and filling the database...'
docker run -it --rm \
    -v $(realpath .):/tmp \
    --link ch-server:clickhouse-server \
    --entrypoint clickhouse-client \
    clickhouse/clickhouse-server \
    --host clickhouse-server \
    --queries-file /tmp/create.sql

echo 'Executing some queries...'
docker run -it --rm \
    -v $(realpath .):/tmp \
    --link ch-server:clickhouse-server \
    --entrypoint clickhouse-client \
    clickhouse/clickhouse-server \
    --host clickhouse-server \
    --queries-file /tmp/queries.sql

echo 'Cleaning up...'
docker stop ch-server
docker rm ch-server
