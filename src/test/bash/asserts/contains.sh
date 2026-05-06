#!/usr/local/bin/bash

if test $# -ne 2; then
 echo 'Wrong arguments!'; exit 1; fi

ACTUAL_TEXT="$1"
EXPECTED_SUBTEXT="$2"

if [[ "${ACTUAL_TEXT}" != *"${EXPECTED_SUBTEXT}"* ]]; then
 echo "Text...
---
${ACTUAL_TEXT}
---
...does not contain:
---
${EXPECTED_SUBTEXT}
---
"
 exit 1
fi
