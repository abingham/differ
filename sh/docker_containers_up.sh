#!/bin/bash
set -e

ip_address()
{
  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    echo localhost
  fi
}

readonly IP_ADDRESS=$(ip_address)

# - - - - - - - - - - - - - - - - - - - - - -

wait_until_ready()
{
  local -r name="${1}"
  local -r port="${2}"
  local -r max_tries=20
  echo -n "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries})
  do
    echo -n '.'
    if curl_cmd ${port} ready? ; then
      echo 'OK'
      return
    else
      sleep 0.1
    fi
  done
  echo 'FAIL'
  echo "${name} not ready after ${max_tries} tries"
  if [ -f /tmp/curl-probe ]; then
    echo "$(cat /tmp/curl-probe)"
  fi  
  docker logs ${name}
  exit 1
}

# - - - - - - - - - - - - - - - - - - -

curl_cmd()
{
  local -r port="${1}"
  local -r path="${2}"
  local -r cmd="curl --output /tmp/curl-probe --silent --fail --data {} -X GET http://${IP_ADDRESS}:${port}/${path}"
  if ${cmd} && [ "$(cat /tmp/curl-probe)" = '{"ready?":true}' ]; then
    true
  else
    false
  fi
}

# - - - - - - - - - - - - - - - - - - -

exit_unless_clean()
{
  local -r name="${1}"
  local -r docker_log=$(docker logs "${name}")
  local -r line_count=$(echo -n "${docker_log}" | grep -c '^')
  echo -n "Checking ${name} started cleanly..."
  if [ "${line_count}" == '3' ]; then
    echo 'OK'
  else
    echo 'FAIL'
    echo_docker_log "${name}" "${docker_log}"
    exit 1
  fi
}

# - - - - - - - - - - - - - - - - - - -

echo_docker_log()
{
  local -r name="${1}"
  local -r docker_log="${2}"
  echo "[docker logs ${name}]"
  echo "<docker_log>"
  echo "${docker_log}"
  echo "</docker_log>"
}

# - - - - - - - - - - - - - - - - - - -

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  up \
  -d \
  --force-recreate

readonly MY_NAME="test-differ-server"

wait_until_ready  "${MY_NAME}" 4567
exit_unless_clean "${MY_NAME}"
