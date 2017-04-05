#!/bin/bash

set -e -u

http_code="$(curl -Sfs https://s3.amazonaws.com/drone-helper-bucket/${CI_REPO}/${1}/${CI_COMMIT}/done -o /dev/null -w '%{http_code}')"

if [[ "${http_code}" == "${http_code#2}" ]]
then
  exit 1
fi
