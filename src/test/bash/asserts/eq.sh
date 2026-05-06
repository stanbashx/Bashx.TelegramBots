#!/usr/local/bin/bash

if test $# -ne 2; then
 echo 'Wrong arguments!'; exit 1; fi

if test -z "${ISSUER}"; then
 echo 'No issuer!'; exit 1; fi

if [ "$1" != "$2" ]; then
 echo "Issuer \"${ISSUER}\" error!"
 echo "Expected: \"$2\""
 echo "Actual:   \"$1\""
 exit 1
fi
