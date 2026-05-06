#!/usr/local/bin/bash

tests='src/test/bash'
asserts="${tests}/asserts"
tgbots="src/main/bash"

. $tests/readme_test.sh
. $tests/license_test.sh
. $tests/get_me_test.sh
. $tests/send_document_test.sh
. $tests/send_message_test.sh

echo 'All tests were successful.'
