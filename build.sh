#!/bin/bash

hash docker 2> /dev/null
if [ $? != 0 ]; then
  echo
  echo "docker is not installed"
  exit 1
fi

hash docker-compose 2> /dev/null
if [ $? != 0 ]; then
  echo
  echo "docker-compose is not installed"
  exit 1
fi

my_dir="$( cd "$( dirname "${0}" )" && pwd )"

docker-compose -f ${my_dir}/client/docker-compose.yml build
docker-compose -f ${my_dir}/server/docker-compose.yml build
