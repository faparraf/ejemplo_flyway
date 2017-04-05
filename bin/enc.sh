#!/bin/bash

set -e -u

enc="${1}"

> /tmp/gpg.log
> /tmp/base64.log

if ! gpg --lock-never --list-key drone@udistritaloas.edu.co >> /tmp/gpg.log 2>&1
then
  cat /tmp/gpg.log > /dev/stderr
  exit 1
fi

dec="$(base64 -d <<< "${enc}" 2>>/tmp/base64.log | gpg --lock-never -d 2>>/tmp/gpg.log)"

if [ -z "${dec}" ]
then
  cat /tmp/base64.log > /dev/stderr
  cat /tmp/gpg.log > /dev/stderr
  exit 1
fi

echo -n "${dec}"
