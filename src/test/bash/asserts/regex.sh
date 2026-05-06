#!/usr/local/bin/bash

if test $# -ne 2; then
 echo 'Wrong arguments!'; exit 1; fi

ACTUAL_TEXT="$1"
REGEX="$2"

if [[ ! "${ACTUAL_TEXT}" =~ ${REGEX} ]]; then
 echo "Text...
---
${ACTUAL_TEXT}
---
...regex...
---
${REGEX}
---
error!
"
 exit 1
fi
